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
            catalogItemCachingService: CatalogItemCachingFaultyStub(),
            catalogItemsDownloadService: CatalogItemsDownloadServiceStub(stubResult: .failure(.badStatusCode(500)))
        )

        let interactor = CatalogInteractor(deps)

        let exp = expectation(description: "Should throw an error once")

        let delay = Observable.just(())
            .delay(.seconds(3), scheduler: MainScheduler.instance)

        _ = interactor.noDataError
            .takeUntil(delay)
            .toArray()
            .subscribe(onSuccess: { errorsThrown in
                XCTAssertEqual(errorsThrown.count, 1, "Should've thrown and only once")
                exp.fulfill()
            })

        interactor.reloadRelay.onNext(())

        wait(for: [exp], timeout: 5)
    }

    func testWhenNoDataIsNotThrown() {
        let deps = CatalogInteractorDeps(
            catalogItemCachingService: CatalogItemCachingFaultyStub(),
            catalogItemsDownloadService: CatalogItemsDownloadServiceStub(stubResult: .success([ ]))
        )

        let interactor = CatalogInteractor(deps)

        let exp = expectation(description: "Should not throw an error")

        let delay = Observable.just(())
            .delay(.seconds(3), scheduler: MainScheduler.instance)

        _ = interactor.noDataError
            .takeUntil(delay)
            .toArray()
            .subscribe(onSuccess: { errorsThrown in
                XCTAssertEqual(errorsThrown.count, 0, "Should've not thrown a single error")
                exp.fulfill()
            })
        
        interactor.reloadRelay.onNext(())

        wait(for: [exp], timeout: 5)
    }

    func testThatDataIsEmptyWhenNoCacheNoInternet() {
        let deps = CatalogInteractorDeps(
            catalogItemCachingService: CatalogItemCachingStub(nil),
            catalogItemsDownloadService: CatalogItemsDownloadServiceStub(stubResult: .failure(.noData))
        )

        let interactor = CatalogInteractor(deps)

        let delay = Observable.just(())
            .delay(.seconds(3), scheduler: MainScheduler.instance)

        let exp1 = expectation(description: "Emits just 1 empty array of items because none were downloaded later on")
        let exp2 = expectation(description: "Emits a no data error, and only once")
        let exp3 = expectation(description: "Starts in loading state, ends in not-loading")

        let disposebag = DisposeBag()

        interactor.items
            .takeUntil(delay)
            .toArray()
            .subscribe(onSuccess: { itemsArray in
                XCTAssertEqual(itemsArray.first, [], "Should've emitted only empty")
                XCTAssertEqual(itemsArray.count, 1, "Should've emitted only once")
                exp1.fulfill()
            })
            .disposed(by: disposebag)

        interactor.noDataError
            .takeUntil(delay)
            .toArray()
            .subscribe(onSuccess: { errorsThrown in
                XCTAssertEqual(errorsThrown.count, 1, "Should've thrown and only once")
                exp2.fulfill()
            })
            .disposed(by: disposebag)

        interactor.isLoading
            .takeUntil(delay)
            .toArray()
            .subscribe(onSuccess: { statuses in
                XCTAssertEqual(statuses, [false, true, false], "Should've emitted twice and these values")
                exp3.fulfill()
            })
            .disposed(by: disposebag)

        interactor.reloadRelay.onNext(())

        wait(for: [exp1, exp2, exp3], timeout: 5)
    }
}
