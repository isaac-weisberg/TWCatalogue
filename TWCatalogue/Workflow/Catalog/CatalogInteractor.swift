import RxSwift

struct CatalogInteractorNavigation {
    let detailRequested: Observable<CatalogItem>
}

struct CatalogInteractorNoDataError: Error { }

protocol CatalogInteractorProtocol {
    var items: Observable<[CatalogItem]> { get }

    var noDataError: Observable<CatalogInteractorNoDataError> { get }

    var isLoading: Observable<Bool> { get }

    var navigation: CatalogInteractorNavigation { get }

    var requestDetail: PublishSubject<CatalogItem> { get }
}

class CatalogInteractor: CatalogInteractorProtocol {
    typealias Dependencies = HasCatalogItemCachingService
        & HasCatalogItemsDownloadService

    enum State {
        enum CachingWriteResult {
            case success
            case failure(JsonCachingWriteError)
        }

        case downloaded(items: [CatalogItem], cacheWrite: CachingWriteResult)

        enum CachingReadResult {
            case success(items: [CatalogItem])
            case failed(lastKnownItems: [CatalogItem], reason: JsonCachingReadError)
        }

        case downloadFailed(reason: JsonDownloadError, cacheRead: CachingReadResult)
        case loading(lastItems: [CatalogItem])

        var getAvailableItems: [CatalogItem] {
            switch self {
            case .downloaded(let items, cacheWrite: _):
                return items
            case .loading(lastItems: let items):
                return items
            case .downloadFailed(reason: _, cacheRead: .success(let items)):
                return items
            case .downloadFailed(reason: _, cacheRead: .failed(let lastItems, reason: _)):
                return lastItems
            }
        }
        var isLoading: Bool {
            switch self {
            case .loading:
                return true
            case .downloaded, .downloadFailed:
                return false
            }
        }
    }

    let items: Observable<[CatalogItem]>
    let isLoading: Observable<Bool>
    let noDataError: Observable<CatalogInteractorNoDataError>
    let navigation: CatalogInteractorNavigation

    let requestDetail = PublishSubject<CatalogItem>()
    let reloadRelay = PublishSubject<Void>()

    let disposeBag = DisposeBag()

    init(_ deps: Dependencies) {
        let downloadUrl = URL(string: "https://foo.com/bar/baz")!

        let download: Single<Result<[CatalogItemDTO], JsonDownloadError>>
            = deps.catalogItemsDownloadService.download(from: downloadUrl)

        let cacheWrite = { (items: [CatalogItem]) -> Single<Result<Void, JsonCachingWriteError>> in
            Single.deferred {
                let models = items.map { item in
                    CatalogItemDSO(model: item)
                }
                let result = deps.catalogItemCachingService.write(models)
                return .just(result)
            }
        }

        let cacheRead = Single<Result<[CatalogItem], JsonCachingReadError>>.deferred {
            return .just(deps.catalogItemCachingService.read().map { dsos in
                dsos.map { dso in
                    CatalogItem(dso: dso)
                }
            })
        }

        let state = BehaviorSubject<State>(value: .loading(lastItems: []))

        let downloadHappened = state
            .flatMapLatest { state -> Single<[CatalogItem]> in
                switch state {
                case .loading(let lastItems):
                    return .just(lastItems)
                case .downloaded, .downloadFailed:
                    return .never()
                }
            }
            .flatMapLatest { lastItems in
                download
                    .map { downloadResult in
                        (downloadResult, lastItems)
                    }
            }
            .share(replay: 1)

        let downloadWasAFailure = downloadHappened
            .flatMapLatest { result, lastItems -> Single<(JsonDownloadError, [CatalogItem])> in
                switch result {
                case .failure(let error):
                    return .just((error, lastItems))
                case .success:
                    return .never()
                }
            }
            .flatMapLatest { downloadError, lastItems in
                cacheRead
                    .map { cacheReadResult in
                        (cacheReadResult, downloadError, lastItems)
                    }
            }
            .map { arg -> State in
                let (cacheReadResult, downloadError, lastItems) = arg
                let cacheRead: State.CachingReadResult
                switch cacheReadResult {
                case .success(let items):
                    cacheRead = .success(items: items)
                case .failure(let cacheReadError):
                    cacheRead = .failed(lastKnownItems: lastItems, reason: cacheReadError)
                }
                return .downloadFailed(reason: downloadError,
                                       cacheRead: cacheRead)
            }


        let downloadWasSuccessful = downloadHappened
            .flatMapLatest { result, _ -> Single<[CatalogItem]> in
                switch result {
                case .success(let items):
                    let items = items.map { item in
                        CatalogItem(dto: item)
                    }
                    return .just(items)
                case .failure:
                    return .never()
                }
            }
            .flatMapLatest { downloadedItems in
                cacheWrite(downloadedItems)
                    .map { result in
                        (downloadedItems, result)
                    }
            }
            .map { arg -> State in
                let (items, cachingResult) = arg
                let stage: State
                switch cachingResult {
                case .success:
                    stage = .downloaded(items: items, cacheWrite: .success)
                case .failure(let error):
                    stage = .downloaded(items: items, cacheWrite: .failure(error))
                }
                return stage
            }

        Observable
            .merge(downloadWasAFailure, downloadWasSuccessful)
            .bind(to: state)
            .disposed(by: disposeBag)

        reloadRelay
            .withLatestFrom(state)
            .map { state in
                State.loading(lastItems: state.getAvailableItems)
            }
            .bind(to: state)
            .disposed(by: disposeBag)


        items = state
            .map { state in
                state.getAvailableItems
            }

        isLoading = state
            .map { state in
                state.isLoading
            }

        noDataError = state
            .flatMapLatest { state -> Single<CatalogInteractorNoDataError> in
                switch state {
                case .downloadFailed(reason: _, cacheRead: CatalogInteractor.State.CachingReadResult.failed):
                    return .just(CatalogInteractorNoDataError())
                case .downloaded, .loading, .downloadFailed(reason: _, .success):
                    return .never()
                }
            }

        navigation = .init(
            detailRequested: requestDetail.asObservable()
        )
    }
}
