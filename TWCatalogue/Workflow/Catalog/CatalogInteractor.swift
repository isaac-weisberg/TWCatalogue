import RxSwift

struct CatalogInteractorNavigation {
    let detailRequested: Observable<CatalogItem>
}

class CatalogInteractor {
    let items: Observable<[CatalogItem]>

    let requestDetail = PublishSubject<CatalogItem>()
    let navigation: CatalogInteractorNavigation

    init() {
        items = .just([
            CatalogItem(),
            CatalogItem(),
            CatalogItem(),
            CatalogItem(),
        ])

        navigation = .init(
            detailRequested: requestDetail.asObservable()
        )
    }
}
