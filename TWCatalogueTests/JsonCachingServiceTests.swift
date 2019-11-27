import XCTest
@testable import TWCatalogue

class JsonCachingServiceTests: XCTestCase {
    class CachedData: Equatable, Codable {
        static func == (lhs: JsonCachingServiceTests.CachedData, rhs: JsonCachingServiceTests.CachedData) -> Bool {
            return lhs.value == rhs.value && lhs.string == rhs.string
        }

        let value: Int
        let string: String

        init(_ params: (Int, String)) {
            (value, string) = params
        }
    }

    func testMultipleWritesAndReads() {
        let container = randomString(length: 64)
        let service = JsonCachingService<[CachedData]>(container: container);

        {
            let res = service.read()
            XCTAssertNotNil(res.error, "Should've thrown an error")
        }()

        let models = [
            (3, "13"),
            (1, "rwbhwrntgi"),
            (135, "ergjiwerg"),
            (31, "35939"),
        ].map(CachedData.init(_:));

        {
            let res = service.write(models)
            XCTAssertNotNil(res.value, "Should've succeeded")
        }();

        {
            let res = service.read()
            XCTAssertNil(res.error, "Shoudlve' not errored out")
            XCTAssertEqual(res.value, models, "Should've read all the same we wrote previously")
        }()

        let newModels = [
            (3, "13"),
            (1, "rwbhwrntgi"),
            (133, "weo"),
            (350, "49"),
        ].map(CachedData.init(_:));

        {
            let res = service.write(newModels)
            XCTAssertNotNil(res.value, "Should've succeeded")
        }();


        {
            let res = service.read()
            XCTAssertNil(res.error, "Shoudlve' not errored out")
            XCTAssertEqual(res.value, newModels, "Should've read all the same we wrote previously")
            XCTAssertNotEqual(res.value, models, "Should not get anything written there previously")
        }()
    }
}
