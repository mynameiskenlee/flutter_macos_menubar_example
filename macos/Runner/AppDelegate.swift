import Cocoa
import FlutterMacOS
import os.log

@main
class AppDelegate: FlutterAppDelegate {
  var statusBar: StatusBarController?
  var popover = NSPopover.init()
  override init() {
    popover.behavior = NSPopover.Behavior.transient //to make the popover hide when the user clicks outside of it
  }
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
  return true
}

  var flutterEngine: FlutterEngine?
  
  override func applicationDidFinishLaunching(_ aNotification: Notification) {
    guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
        fatalError("bundleIdentifier must not be nil")
    }
    let newFlutterEngine = FlutterEngine(name: bundleIdentifier, project: nil)
    newFlutterEngine.run(withEntrypoint: nil)
    self.flutterEngine = newFlutterEngine
    
    let controller = FlutterViewController(engine: newFlutterEngine, nibName: nil, bundle: nil)
    RegisterGeneratedPlugins(registry: newFlutterEngine)
    
    let popoverController = PopoverContentController(flutterViewController: controller)
    popover.contentSize = NSSize(width: 360, height: 360) //change this to your desired size
    popover.contentViewController = popoverController //set the content view controller for the popover to flutter view controller
    statusBar = StatusBarController.init(popover)
    guard let window = mainFlutterWindow else {
            os_log("mainFlutterWindow is nil", type: .error)
            return
        }
    window.close()
    super.applicationDidFinishLaunching(aNotification)
  }
}