import RxSwift
import Foundation
@testable import TWCatalogue

class CatalogItemsDownloadServiceStub: CatalogItemsDownloadServiceProtocol {
    func download(from url: URL) -> Single<Result<[CatalogItemDTO], JsonDownloadError>> {
        return Single.just(stubResult)
            .observeOn(ConcurrentDispatchQueueScheduler(queue: .global()))
    }

    init(stubResult: Result<[CatalogItemDTO], JsonDownloadError>) {
        self.stubResult = stubResult
    }

    let stubResult: Result<[CatalogItemDTO], JsonDownloadError>
}
