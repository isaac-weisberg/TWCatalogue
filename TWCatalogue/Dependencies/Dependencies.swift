protocol HasDownloadService {
    var downloadService: DownloadServiceProtocol { get }
}

protocol HasCatalogItemCachingService {
    var catalogItemCachingService: JsonCachingServiceAbstract<[CatalogItemDSO]> { get }
}

protocol HasJsonDownloadService {
    var jsonDownloadService: JsonDownloadServiceProtocol { get }
}

protocol HasCatalogItemsDownloadService {
    var catalogItemsDownloadService: CatalogItemsDownloadServiceProtocol { get }
}

typealias HasAllDependencies = HasDownloadService
    & HasCatalogItemCachingService
    & HasJsonDownloadService
    & HasCatalogItemsDownloadService

class DependenciesDefault: HasAllDependencies {
    let downloadService: DownloadServiceProtocol
    let catalogItemCachingService: JsonCachingServiceAbstract<[CatalogItemDSO]>
    let jsonDownloadService: JsonDownloadServiceProtocol
    let catalogItemsDownloadService: CatalogItemsDownloadServiceProtocol

    init() {
        downloadService = DownloadService(urlSession: .shared)
        catalogItemCachingService = JsonCachingService(container: "this_cache_is_4_catalog_items")
        jsonDownloadService = JsonDownloadService(downloadService: downloadService)
        catalogItemsDownloadService = CatalogItemsDownloadService(jsonDownloadService: jsonDownloadService)
    }
}
