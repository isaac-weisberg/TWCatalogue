import RxSwift
import RxCocoa
import UIKit

class CatalogController: UIViewController {
    var viewModel: CatalogViewModelProtocol!

    let disposeBag = DisposeBag()

    @IBOutlet var tableView: CatalogTableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.catalogItems
            .bind(to: tableView.items)
            .disposed(by: disposeBag)
    }
}
