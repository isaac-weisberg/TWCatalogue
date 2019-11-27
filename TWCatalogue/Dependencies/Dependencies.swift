protocol HasDownloadService {
    var downloadService: DownloadServiceProtocol { get }
}

protocol HasCatalogItemCachingService {
    var catalogItemCachingService: CachingServiceAbstract<CatalogItemDSO> { get }
}

typealias HasAllDependencies = HasDownloadService
    & HasCatalogItemCachingService

class DependenciesDefault: HasAllDependencies {
    let downloadService: DownloadServiceProtocol
    let catalogItemCachingService: CachingServiceAbstract<CatalogItemDSO>

    init() {
        downloadService = DownloadService(urlSession: .shared)
        catalogItemCachingService = CachingService(container: "this_cache_is_4_catalog_items")
    }
}
