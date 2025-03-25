import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
//    let flutterEngineName = "dropspot_flutter_engine"
//    lazy var flutterEngine = FlutterEngine(name: flutterEngineName)
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // FlutterEngine 실행
//        flutterEngine.run()
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
