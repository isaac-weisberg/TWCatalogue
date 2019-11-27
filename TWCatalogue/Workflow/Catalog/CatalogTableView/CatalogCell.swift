import RxSwift
import UIKit

class CatalogCell: UITableViewCell {
    var viewModel: CatalogItemViewModel!
    var disposeBag: DisposeBag!

    let tapGesture = UITapGestureRecognizer()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addGestureRecognizer(tapGesture)
    }

    func apply(viewModel: CatalogItemViewModel) {
        disposeBag = DisposeBag()
        self.viewModel = viewModel

        tapGesture.rx.event
            .filter { recognizer in
                recognizer.state == .recognized
            }
            .map{ _ in () }
            .debug()
            .bind(to: viewModel.detailRequest)
            .disposed(by: disposeBag)
    }
}
