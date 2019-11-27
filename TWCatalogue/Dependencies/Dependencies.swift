protocol HasDownloadService {
    var downloadService: DownloadServiceProtocol { get }
}

protocol HasCatalogItemCachingService {
    var catalogItemCachingService: JsonCachingServiceAbstract<[CatalogItemDSO]> { get }
}

protocol HasJsonDownloadService {
    var jsonDownloadService: JsonDownloadServiceProtocol { get }
}

typealias HasAllDependencies = HasDownloadService
    & HasCatalogItemCachingService
    & HasJsonDownloadService

class DependenciesDefault: HasAllDependencies {
    let downloadService: DownloadServiceProtocol
    let catalogItemCachingService: JsonCachingServiceAbstract<[CatalogItemDSO]>
    let jsonDownloadService: JsonDownloadServiceProtocol

    init() {
        downloadService = DownloadService(urlSession: .shared)
        catalogItemCachingService = JsonCachingService(container: "this_cache_is_4_catalog_items")
        jsonDownloadService = JsonDownloadService(downloadService: downloadService)
    }
}
