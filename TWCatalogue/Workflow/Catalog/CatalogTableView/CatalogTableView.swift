import RxSwift
import RxCocoa
import UIKit
import RxSche

class CatalogTableView: UITableView {
    // Certainly would've went for RxDataSources.
    // This time decided not to
    let disposeBag = DisposeBag()

    lazy var theDataSource = CatalogTableViewDataSource(self)

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        dataSource = theDataSource
    }
}
