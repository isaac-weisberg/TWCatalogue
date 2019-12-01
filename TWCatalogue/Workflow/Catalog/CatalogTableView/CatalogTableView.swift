import RxSwift
import RxCocoa
import UIKit
import RxSche

class CatalogTableView: UITableView {
    // Certainly would've went for RxDataSources.
    // This time decided not to
    let disposeBag = DisposeBag()

    let theDataSource = CatalogTableViewDataSource()

    init() {
        super.init(frame: .zero, style: .plain)
        theDataSource.tableView = self
        register(UINib(nibName: "CatalogCell", bundle: .main), forCellReuseIdentifier: CatalogCell.identifier)
        dataSource = theDataSource
    }

    required init?(coder: NSCoder) {
        fatalError("Fuck you, decong views sucks")
    }
}
