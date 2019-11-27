import RxSwift
import UIKit

class AppCoordinator {
    typealias View = UIWindow
    typealias Result = Never

    let view: View

    init(view: View) {
        self.view = view
    }

    func start() -> Single<Result> {
        return Single.deferred { [view] in
            let interactor = CatalogInteractor()
            let viewModel = CatalogViewModel(interactor: interactor)
            let controller = CatalogController.instantiateFromMain()
            controller.viewModel = viewModel

            interactor.navigation.detailRequested
                .flatMapLatest { [unowned controller] item in
                    ItemDetailCoordinator(controller, item: item)
                        .start()
                }
                .subscribe()
                .disposed(by: controller.disposeBag)

            view.rootViewController = controller
            view.makeKeyAndVisible()

            return .never()
        }
    }
}
