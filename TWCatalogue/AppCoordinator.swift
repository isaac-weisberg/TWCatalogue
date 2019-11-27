import RxSwift
import UIKit

class AppCoordinator {
    typealias Deps = CatalogInteractor.Dependencies

    typealias View = UIWindow
    typealias Result = Never

    let view: View
    let deps: Deps

    init(view: View, deps: Deps) {
        self.view = view
        self.deps = deps
    }

    func start() -> Single<Result> {
        return Single.deferred { [view, deps] in
            let interactor = CatalogInteractor(deps)
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
