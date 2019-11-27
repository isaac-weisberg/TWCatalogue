import RxSwift

protocol CatalogViewModelProtocol {
    var catalogItems: Observable<[CatalogItemViewModel]> { get }

    var errorAlert: Observable<String> { get }

    var isLoading: Observable<Bool> { get }

    var reload: PublishSubject<Void> { get }
}

struct CatalogViewModel: CatalogViewModelProtocol {
    let catalogItems: Observable<[CatalogItemViewModel]>

    let errorAlert: Observable<String>

    let isLoading: Observable<Bool>

    let reload = PublishSubject<Void>()

    let disposeBag = DisposeBag()

    init(interactor: CatalogInteractorProtocol) {
        catalogItems = interactor.items
            .observeOn(MainScheduler.instance)
            .map { items in
                items.map { item in
                    let viewModel = CatalogItemViewModel(item)

                    viewModel.navigation.detail
                        .map { _ in
                            item
                        }
                        .bind(to: interactor.requestDetail)
                        .disposed(by: viewModel.disposeBag)

                    return viewModel
                }
            }
            .observeOn(MainScheduler.instance)

        isLoading = interactor.isLoading
            .observeOn(MainScheduler.instance)

        errorAlert = interactor.noDataError
            .map { error in
                "Unfortunately, no data could be retrieved. Not from cache. Not from network :("
            }
            .observeOn(MainScheduler.instance)

        reload
            .bind(to: interactor.reloadRelay)
            .disposed(by: disposeBag)
    }
}
