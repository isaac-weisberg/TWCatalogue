import RxSwift
import UIKit

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    var appSubcription: Disposable!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        appSubcription = AppCoordinator(view: window)
            .start()
            .subscribe()

        return true
    }
}
