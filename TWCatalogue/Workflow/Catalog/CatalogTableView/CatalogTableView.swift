import RxSwift
import RxCocoa
import UIKit

private let identifier = "CatalogCell"

class CatalogTableView: UITableView {
    let items = BehaviorRelay<[CatalogItemViewModel]>(value: [])
    let disposeBag = DisposeBag()

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

        items
            .bind(onNext: { _ in
                self.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension CatalogTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CatalogCell

        cell.apply(viewModel: item)

        return cell
    }
}
