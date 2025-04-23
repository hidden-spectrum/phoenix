//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//


extension Equatable {
    func isEqual(to other: any Equatable) -> Bool {
        guard let other = other as? Self else {
            return other.isExactlyEqual(to: self)
        }
        return self == other
    }
    
    private func isExactlyEqual(to other: any Equatable) -> Bool {
        guard let other = other as? Self else {
            return false
        }
        return self == other
    }
}


func areEqual(_ first: Any, _ second: Any) -> Bool {
    guard let equatableOne = first as? any Equatable,
          let equatableTwo = second as? any Equatable
    else {
        return false
    }
    
    return equatableOne.isEqual(to: equatableTwo)
}
