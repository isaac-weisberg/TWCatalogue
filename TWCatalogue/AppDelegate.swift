import RxSwift
import UIKit

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    var appSubcription: Disposable!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        let deps = DependenciesDefault()

        appSubcription = AppCoordinator(view: window, deps: deps)
            .start()
            .subscribe()

        return true
    }
}
