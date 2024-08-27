import Foundation

// swiftlint:disable force_try force_unwrapping
public struct TestHelper {

    public static var sampleDiaryEntry: DiaryEntry {
        return try! JSONDecoder().decode(
            DiaryEntry.self,
            from: TestHelper.jsonData(forResource: "diary_entry_valid")
        )
    }

    public static func jsonData(forResource resource: String) -> Data {
        let fileURLPath = Bundle.module.url(forResource: resource,
                                            withExtension: "json",
                                            subdirectory: "JSON/Mocks")

        return try! Data(contentsOf: fileURLPath!)
    }
}
// swiftlint:enable force_try force_unwrapping
