import UIKit

extension UIViewController {
    static func instantiateFromMain() -> Self {
        return UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "\(self)") as! Self
    }
}
