@testable import TWCatalogue

class CatalogItemCachingStub: JsonCachingServiceAbstract<[CatalogItemDSO]> {
    struct FakeError: Error { }

    var store: [CatalogItemDSO]?

    init(_ store: [CatalogItemDSO]?) {
        self.store = store
    }

    override func read() -> Result<[CatalogItemDSO], JsonCachingReadError> {
        if let store = store {
            return .success(store)
        }
        return .failure(.dataRead(FakeError()))
    }

    var shouldWriteFail = false
    override func write(_ model: [CatalogItemDSO]) -> Result<Void, JsonCachingWriteError> {
        if shouldWriteFail {
            return .failure(.dataWrite(FakeError()))
        }
        store = model
        return .success(())
    }
}
