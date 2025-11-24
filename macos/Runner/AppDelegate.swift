import Cocoa
import FlutterMacOS
import os.log

@main
class AppDelegate: FlutterAppDelegate {
  var statusBar: StatusBarController?
  var popover = NSPopover.init()
  private enum Popover {
    static let width: CGFloat = 360
    static let height: CGFloat = 360
    //change this to your desired size
  }
  override init() {
    popover.behavior = NSPopover.Behavior.transient //to make the popover hide when the user clicks outside of it
  }
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
  
  override func applicationDidFinishLaunching(_ aNotification: Notification) {
    guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
        fatalError("bundleIdentifier must not be nil")
    }
    let newFlutterEngine = FlutterEngine(name: bundleIdentifier, project: nil)
    newFlutterEngine.run(withEntrypoint: nil)
        
    let controller = FlutterViewController(engine: newFlutterEngine, nibName: nil, bundle: nil)
    RegisterGeneratedPlugins(registry: newFlutterEngine)
    
    let popoverController = PopoverContentController(flutterViewController: controller)
    popover.contentSize = NSSize(width: Popover.width, height: Popover.height)
    popover.contentViewController = popoverController
    statusBar = StatusBarController.init(popover)
    guard let window = mainFlutterWindow else {
            os_log("mainFlutterWindow is nil", type: .error)
            return
        }
    window.close()
    super.applicationDidFinishLaunching(aNotification)
  }
}