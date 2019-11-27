import UIKit

class ItemDetailController: UIViewController {
    var viewModel: ItemDetailViewModelProtocol!

    @IBOutlet var bodyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        bodyLabel.text = viewModel.body
    }
}
