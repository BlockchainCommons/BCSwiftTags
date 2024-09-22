import Testing
import BCTags

struct BCTagsTests {
    @Test @MainActor func addTag() throws {
        addKnownTags()
        let tag = Tag(12345, ["TestTag"])
        globalTags.insert(tag)
    }
    
    @Test func enumerateTags() {
        for tag in globalTags {
            print("\(String(describing: tag.name ?? "nil")) = \(tag.value)")
        }
    }
}
