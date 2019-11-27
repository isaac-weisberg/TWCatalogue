protocol HasDownloadService {
    var downloadService: DownloadServiceProtocol { get }
}

protocol HasCatalogItemCachingService {
    var catalogItemCachingService: JsonCachingServiceAbstract<CatalogItemDSO> { get }
}

typealias HasAllDependencies = HasDownloadService
    & HasCatalogItemCachingService

class DependenciesDefault: HasAllDependencies {
    let downloadService: DownloadServiceProtocol
    let catalogItemCachingService: JsonCachingServiceAbstract<CatalogItemDSO>

    init() {
        downloadService = DownloadService(urlSession: .shared)
        catalogItemCachingService = JsonCachingService(container: "this_cache_is_4_catalog_items")
    }
}
