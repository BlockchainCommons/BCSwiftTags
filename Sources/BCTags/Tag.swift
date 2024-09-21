import Foundation

/// A CBOR tag.
public struct Tag: Sendable {
    /// The tag's value.
    public let value: UInt64
    
    /// The tag's known names, if any.
    ///
    /// If the array contains more than one element, the first is the preferred name.
    public let names: [String]
    
    /// The tag's preferred name, if any.
    public var name: String? {
        names.first
    }
    
    /// Creates a tag with the given values, and an array of known names.
    ///
    /// If the array contains more than one element, the first is the preferred name.
    public init(_ value: UInt64, _ names: [String]) {
        self.value = value
        self.names = names
    }

    /// Creates a tag with the given value, and optionally a known name.
    public init(_ value: UInt64, _ name: String? = nil) {
        self.init(value, name.map { [$0] } ?? [])
    }
}

extension Tag: Hashable {
    public static func ==(lhs: Tag, rhs: Tag) -> Bool {
        lhs.value == rhs.value
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension Tag: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(UInt64(value), nil)
    }
}

extension Tag: CustomStringConvertible {
    public var description: String {
        name ?? String(value)
    }
}
