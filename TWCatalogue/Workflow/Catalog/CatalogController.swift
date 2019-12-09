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

        viewModel.isLoading
            .bind(onNext: { isLoading in
                print("isLoading = \(isLoading)")
            })
            .disposed(by: disposeBag)

        viewModel.reload.onNext(())

        DispatchQueue(label: "start q", attributes: .concurrent).async {
            let one = Observable.just(())
                .observeOn(MainScheduler.instance)
            let two = Observable.just(())
                .delay(.milliseconds(40), scheduler: ConcurrentDispatchQueueScheduler.init(queue: .init(label: "asdf1", attributes: .concurrent)))

            Observable
                .combineLatest(one, two) { _, _ in () }
                .subscribeOn(ConcurrentDispatchQueueScheduler(queue: .global()))
                .subscribe(onNext: { void in
                    print(void)
                })
                .disposed(by: self.disposeBag)
        }
    }
}
