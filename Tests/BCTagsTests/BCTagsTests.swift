import Testing
import BCTags

struct BCTagsTests {
    @Test @MainActor func example() throws {
        addKnownTags()
        for tag in globalTags {
            print("\(String(describing: tag.name ?? "nil")) = \(tag.value)")
        }
    }
}
