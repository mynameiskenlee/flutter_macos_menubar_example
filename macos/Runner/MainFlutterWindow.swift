import Cocoa
import FlutterMacOS
import multi_window_macos

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    MultiWindowMacosPlugin.registerGeneratedPlugins = RegisterGeneratedPlugins
    let flutterViewController = MultiWindowViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    RegisterGeneratedPlugins(registry: flutterViewController)
    super.awakeFromNib()
  }
}
