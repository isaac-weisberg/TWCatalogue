import RxSwift
import RxCocoa

protocol CatalogViewModelProtocol {
    var catalogItems: Observable<[CatalogItemViewModel]> { get }

    var errorAlert: Observable<String> { get }

    var isLoading: Observable<Bool> { get }
}

struct CatalogViewModel: CatalogViewModelProtocol {
    let catalogItems: Observable<[CatalogItemViewModel]>

    let errorAlert: Observable<String>

    let isLoading: Observable<Bool>

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

        errorAlert = interactor.noDataError
            .observeOn(MainScheduler.instance)
            .map { error in
                "Unfortunately, no data could be retrieved. Not from cache. Not from network :("
            }

        isLoading = interactor.isLoading
            .observeOn(MainScheduler.instance)
    }
}
