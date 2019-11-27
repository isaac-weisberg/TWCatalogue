import RxSwift

struct CatalogItemViewModelNavigation {
    let detail: Observable<Void>
}

class CatalogItemViewModel {
    let navigation: CatalogItemViewModelNavigation

    let disposeBag = DisposeBag()
    let detailRequest = PublishSubject<Void>()

    let title: String
    let body: String

    init(_ item: CatalogItem) {
        title = item.title
        body = item.body

        navigation = .init(
            detail: detailRequest.asObservable()
        )
    }
}
