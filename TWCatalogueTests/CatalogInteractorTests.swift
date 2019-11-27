import RxSwift
import XCTest
@testable import TWCatalogue

class CatalogInteractorTests: XCTestCase {
    struct CatalogInteractorDeps: CatalogInteractor.Dependencies {
        let catalogItemCachingService: JsonCachingServiceAbstract<[CatalogItemDSO]>
        let catalogItemsDownloadService: CatalogItemsDownloadServiceProtocol
    }

    func testNoDataError() {
        let deps = CatalogInteractorDeps(
            catalogItemCachingService: CatalogItemCachingStub(),
            catalogItemsDownloadService: CatalogItemsDownloadServiceStub(stubResult: .failure(.badStatusCode(500)))
        )

        let interactor = CatalogInteractor(deps)

        let exp = expectation(description: "Should throw an error once")

        let delay = Observable.just(())
            .delay(3, scheduler: MainScheduler.instance)

        _ = interactor.noDataError
            .takeUntil(delay)
            .toArray()
            .subscribe(onSuccess: { errorsThrown in
                XCTAssertEqual(errorsThrown.count, 1, "Should've thrown and only once")
                exp.fulfill()
            })

        wait(for: [exp], timeout: 5)
    }

    func testWhenNoDataIsNotThrown() {
        let deps = CatalogInteractorDeps(
            catalogItemCachingService: CatalogItemCachingStub(),
            catalogItemsDownloadService: CatalogItemsDownloadServiceStub(stubResult: .success([ ]))
        )

        let interactor = CatalogInteractor(deps)

        let exp = expectation(description: "Should not throw an error")

        let delay = Observable.just(())
            .delay(3, scheduler: MainScheduler.instance)

        _ = interactor.noDataError
            .takeUntil(delay)
            .toArray()
            .subscribe(onSuccess: { errorsThrown in
                XCTAssertEqual(errorsThrown.count, 0, "Should've not thrown")
                exp.fulfill()
            })

        wait(for: [exp], timeout: 5)
    }
}
