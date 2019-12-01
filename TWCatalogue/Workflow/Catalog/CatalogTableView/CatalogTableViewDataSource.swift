import UIKit
import RxSwift
import RxSche

class CatalogTableViewDataSource: NSObject, UITableViewDataSource {
    var disposeBag: DisposeBag!
    private var dataSet: [CatalogItemViewModel] = []

    unowned var tableView: CatalogTableView!

    func apply(items: ScheduledObservable<[CatalogItemViewModel], MainScheduler>) {
        disposeBag = DisposeBag()

        items
            .subscribe(onNext: { [unowned self] items in
                self.dataSet = items
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSet.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSet[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CatalogCell.identifier, for: indexPath) as! CatalogCell

        cell.apply(viewModel: item)

        return cell
    }
}
