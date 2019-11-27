import RxSwift
import UIKit

class ItemDetailCoordinator {
    typealias View = UIViewController

    enum Result {
        case dismiss
    }

    let item: CatalogItem
    let view: View

    init(_ view: View, item: CatalogItem) {
        self.view = view
        self.item = item
    }

    func start() -> Single<Result> {
        return Single.deferred { [view, item] in
            let viewModel = ItemDetailViewModel(item: item)
            let controller = ItemDetailController.instantiateFromMain()
            controller.viewModel = viewModel

            view.present(controller, animated: true)

            return controller.rx.deallocated
                .map { _ in
                    Result.dismiss
                }
                .take(1)
                .asSingle()
        }
    }
}
