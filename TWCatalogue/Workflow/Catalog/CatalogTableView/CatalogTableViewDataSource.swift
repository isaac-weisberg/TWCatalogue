import UIKit
import RxSwift
import RxSche

private let identifier = "CatalogCell"

class CatalogTableViewDataSource: NSObject, UITableViewDataSource {
    unowned let tableView: CatalogTableView

    var items: ScheduledObserver<[CatalogItemViewModel], MainScheduler> {
        return ScheduledObserver(onNext: { [unowned self] items in
            self.dataSet = items
            self.tableView.reloadData()
        })
    }

    private var dataSet: [CatalogItemViewModel] = []

    init(_ tableView: CatalogTableView) {
        self.tableView = tableView
        tableView.register(UINib(nibName: "CatalogCell", bundle: .main), forCellReuseIdentifier: identifier)
    }

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
