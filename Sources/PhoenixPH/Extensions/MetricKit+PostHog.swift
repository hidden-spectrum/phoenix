//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import MetricKit
import Phoenix


extension MXCallStackTree {
    
    func toPostHogFrames() -> [AnalyticsParameters] {
        let data = jsonRepresentation()
        
        guard let tree = try? JSONDecoder().decode(ParsedStackTree.self, from: data),
              let rootStack = tree.callStacks.first,
              let rootFrame = rootStack.callStackRootFrames.first
        else {
            return []
        }
        
        // 3. Flatten the Tree into a Linear List
        var frames: [AnalyticsParameters] = []
        var currentFrame: ParsedFrame? = rootFrame
        
        // Get App Name to check 'in_app' boolean
        let appBinaryName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        
        // Walk down the tree (Root -> Child -> Grandchild -> Crash)
        while let frame = currentFrame {
            
            let isAppFrame = (frame.binaryName == appBinaryName)
            let addressString = String(frame.offsetIntoBinaryTextSegment)
            
            let frameDict: AnalyticsParameters = [
                .filename: frame.binaryName,
                .function: frame.formattedFunction,
                .lineno: 0,
                .inApp: isAppFrame,
                .absPath: addressString,
                .platform: "custom",
                .lang: "swift"
            ]
            
            frames.append(frameDict)
            
            // Go deeper: Move to the next frame in the stack.
            // MetricKit sorts subFrames by sampleCount, so .first is usually the crash path.
            currentFrame = frame.subFrames?.first
        }
        
        // 4. Reverse the array
        // MetricKit starts at the bottom (Start of Thread) and goes up to the Crash.
        // PostHog (and most crash tools) expect Index 0 to be the Crash.
        return frames.reversed()
    }
}


// MARK: Parsed Stack Tree Models

fileprivate struct ParsedStackTree: Decodable {
    let callStacks: [ParsedCallStack]
}

fileprivate struct ParsedCallStack: Decodable {
    let callStackRootFrames: [ParsedFrame]
}

fileprivate struct ParsedFrame: Decodable {
    // Keys matching your JSON example
    let binaryName: String
    let binaryUUID: String
    let offsetIntoBinaryTextSegment: Int
    let sampleCount: Int
    let address: UInt64
    
    // The key that creates the "Tree" (Recursive)
    // Even if your snippet didn't show it, this exists in deep stacks
    let subFrames: [ParsedFrame]?
    
    // Helper to format for PostHog display
    var formattedFunction: String {
        return "\(binaryName) + \(offsetIntoBinaryTextSegment)"
    }
}
