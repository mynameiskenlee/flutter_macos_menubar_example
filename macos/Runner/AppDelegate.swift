import Cocoa
import FlutterMacOS

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
    let flutterEngine = FlutterEngine(name: "my flutter engine", project: nil)
    flutterEngine.run(withEntrypoint: nil)
    self.flutterEngine = flutterEngine
    
    let controller = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
    RegisterGeneratedPlugins(registry: flutterEngine)
    
    let popoverController = PopoverContentController(flutterViewController: controller)
    popover.contentSize = NSSize(width: 360, height: 360) //change this to your desired size
    popover.contentViewController = popoverController //set the content view controller for the popover to flutter view controller
    statusBar = StatusBarController.init(popover)
    guard let window = mainFlutterWindow else {
            print("mainFlutterWindow is nil")
            return
        }
    window.close()
  }
}