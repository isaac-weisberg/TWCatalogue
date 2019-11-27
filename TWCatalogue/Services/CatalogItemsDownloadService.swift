import RxSwift
import Foundation

protocol CatalogItemsDownloadServiceProtocol {
    func download(from url: URL) -> Single<Result<[CatalogItemDTO], JsonDownloadError>>
}

class CatalogItemsDownloadService: CatalogItemsDownloadServiceProtocol {
    let jsonDownloadService: JsonDownloadServiceProtocol

    init(jsonDownloadService: JsonDownloadServiceProtocol) {
        self.jsonDownloadService = jsonDownloadService
    }

    func download(from url: URL) -> Single<Result<[CatalogItemDTO], JsonDownloadError>> {
        return jsonDownloadService.download(from: url)
    }
}
