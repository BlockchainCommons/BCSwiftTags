import Foundation

/// A type that can map between tags and their names.
public protocol TagsStoreProtocol {
    func assignedName(for tag: Tag) -> String?
    func name(for tag: Tag) -> String
    func tag(for value: UInt64) -> Tag?
    func tag(for name: String) -> Tag?
}

public func name(for tag: Tag, knownTags: TagsStoreProtocol?) -> String {
    knownTags?.name(for: tag) ?? String(tag.value)
}

/// A dictionary of mappings between tags and their names.
public final class TagsStore: TagsStoreProtocol {
    var tagsByValue: [UInt64: Tag]
    var tagsByName: [String: Tag]
    
    public init<T>(_ tags: T) where T: Sequence, T.Element == Tag {
        tagsByValue = [:]
        tagsByName = [:]
        for tag in tags {
            Self._insert(tag, tagsByValue: &tagsByValue, tagsByName: &tagsByName)
        }
    }
    
    @MainActor
    public func insert(_ tag: Tag) {
        Self._insert(tag, tagsByValue: &tagsByValue, tagsByName: &tagsByName)
    }
    
    public func assignedName(for tag: Tag) -> String? {
        self.tag(for: tag.value)?.name
    }
    
    public func name(for tag: Tag) -> String {
        assignedName(for: tag) ?? String(tag.value)
    }
    
    public func tag(for name: String) -> Tag? {
        tagsByName[name]
    }
    
    public func tag(for value: UInt64) -> Tag? {
        tagsByValue[value]
    }

    static func _insert(_ tag: Tag, tagsByValue: inout [UInt64: Tag], tagsByName: inout [String: Tag]) {
        precondition(!tag.names.isEmpty)
        tagsByValue[tag.value] = tag
        for name in tag.names {
            tagsByName[name] = tag
        }
    }
}

// Conform to Sequence protocol to make TagsStore iterable.
extension TagsStore: Sequence {
    public func makeIterator() -> TagsIterator {
        return TagsIterator(tagsByValue: tagsByValue)
    }
}

// Iterator that iterates over tags in numeric order.
public struct TagsIterator: IteratorProtocol {
    private var sortedTags: [Tag]
    private var currentIndex: Int = 0
    
    init(tagsByValue: [UInt64: Tag]) {
        self.sortedTags = tagsByValue.values.sorted(by: { $0.value < $1.value })
    }
    
    public mutating func next() -> Tag? {
        guard currentIndex < sortedTags.count else { return nil }
        let tag = sortedTags[currentIndex]
        currentIndex += 1
        return tag
    }
}

extension TagsStore: ExpressibleByArrayLiteral {
    public convenience init(arrayLiteral elements: Tag...) {
        self.init(elements)
    }
}

// Safe because the only mutating function is @MainActor.
nonisolated(unsafe) public let globalTags = TagsStore()
