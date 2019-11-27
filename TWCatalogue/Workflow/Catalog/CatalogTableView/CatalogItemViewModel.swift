import RxSwift

struct CatalogItemViewModelNavigation {
    let detail: Observable<Void>
}

class CatalogItemViewModel {
    let navigation: CatalogItemViewModelNavigation

    let disposeBag = DisposeBag()
    let detailRequest = PublishSubject<Void>()

    init(_ item: CatalogItem) {
        navigation = .init(
            detail: detailRequest.asObservable()
        )
    }
}
