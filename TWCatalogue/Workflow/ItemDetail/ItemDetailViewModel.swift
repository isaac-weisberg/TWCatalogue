import RxSwift
import RxCocoa

protocol ItemDetailViewModelProtocol {
    var body: String { get }
}

struct ItemDetailViewModel: ItemDetailViewModelProtocol {
    let body: String

    init(item: CatalogItem) {
        body = item.body
    }
}
