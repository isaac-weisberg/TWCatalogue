import RxSwift
import RxCocoa
import UIKit
import RxSche

private let identifier = "CatalogCell"

class CatalogTableView: UITableView {
    // Certainly would've went for RxDataSources.
    // This time decided not to

    let disposeBag = DisposeBag()

    var items: ScheduledObserver<[CatalogItemViewModel], MainScheduler> {
        return ScheduledObserver(onNext: { [unowned self] items in
            self.dataSet = items
            self.reloadData()
        })
    }

    private var dataSet: [CatalogItemViewModel] = []

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        register(UINib(nibName: "CatalogCell", bundle: .main), forCellReuseIdentifier: identifier)
        dataSource = self
    }
}

extension CatalogTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSet.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSet[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CatalogCell

        cell.apply(viewModel: item)

        return cell
    }
}
