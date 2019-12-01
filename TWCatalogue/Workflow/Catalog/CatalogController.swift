import RxSwift
import RxCocoa
import UIKit

class CatalogController: UIViewController {
    var viewModel: CatalogViewModelProtocol!

    let disposeBag = DisposeBag()

    let tableView = CatalogTableView()

    init(viewModel: CatalogViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        tableView.theDataSource.apply(items: viewModel.catalogItems)

        viewModel.isLoading
            .bind(onNext: { isLoading in
                print("isLoading = \(isLoading)")
            })
            .disposed(by: disposeBag)

        viewModel.reload.onNext(())
    }

    required init?(coder: NSCoder) {
        fatalError("Fuck you")
    }
}
