@testable import TWCatalogue

class CatalogItemCachingStub: JsonCachingServiceAbstract<[CatalogItemDSO]> {
    struct FakeReadError: Error { }

    override func read() -> Result<[CatalogItemDSO], JsonCachingReadError> {
        return .failure(.dataRead(FakeReadError()))
    }

    struct FakeWriteError: Error { }

    override func write(_ model: [CatalogItemDSO]) -> Result<Void, JsonCachingWriteError> {
        return .failure(.dataWrite(FakeWriteError()))
    }
}
