import RxSwift
import Foundation
@testable import TWCatalogue

class JsonDownloadServiceStub<LockModel>: JsonDownloadServiceProtocol {
    func download<Model: Decodable>(from url: URL) -> PrimitiveSequence<SingleTrait, Result<Model, JsonDownloadError>> {
        return Single.just(stubResult as! Result<Model, JsonDownloadError>)
            .observeOn(ConcurrentDispatchQueueScheduler(queue: .global()))
    }

    init(stubResult: Result<LockModel, JsonDownloadError>) {
        self.stubResult = stubResult
    }

    let stubResult: Result<LockModel, JsonDownloadError>
}
