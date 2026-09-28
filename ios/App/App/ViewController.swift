import UIKit
import Capacitor

@objc(ViewController)
class ViewController: CAPBridgeViewController {
    override open func capacitorDidLoad() {
        super.capacitorDidLoad()
        bridge?.registerPluginInstance(HPFStoreKitPlugin())
    }
}
