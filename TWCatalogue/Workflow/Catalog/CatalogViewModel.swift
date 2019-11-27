import RxSwift
import RxCocoa

protocol CatalogViewModelProtocol {
    var catalogItems: Observable<[CatalogItemViewModel]> { get }
}

struct CatalogViewModel: CatalogViewModelProtocol {
    let catalogItems: Observable<[CatalogItemViewModel]>

    init(interactor: CatalogInteractor) {
        catalogItems = interactor.items
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
    }
}
