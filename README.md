# flutter_macos_menubar_example

starter template for building menubar app in flutter

<img src="https://github.com/mynameiskenlee/flutter_macos_menubar_example/blob/master/Demo.png?raw=true" width="250" />

Use [multi_windows](https://github.com/mynameiskenlee/flutter_macos_menubar_example/tree/multi_windows) branch for example with addtional windows (select include all branches when using this template)

![multi_windows demo](multi_window.gif)

-------------------------------------------------------
## Getting Started (for single window menu bar app only)
use this template or follow the following step in your flutter project:

1. Change to Content of macos/Runner/AppDelegate.swift
```swift
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
```
2. Add a new Swift file named 'PopoverContentController.swift' in macos/Runner
```swift
import Cocoa
import FlutterMacOS

class PopoverContentController: NSViewController {
    private let flutterViewController: FlutterViewController
    
    init(flutterViewController: FlutterViewController) {
        self.flutterViewController = flutterViewController
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable, message: "Loading from a nib is not supported")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChild(flutterViewController)
        view.addSubview(flutterViewController.view)
        flutterViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            flutterViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            flutterViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            flutterViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            flutterViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        // Ensure the window becomes key and the app is active when the popover appears
        self.view.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
```
3. Add a new Swift file named 'StatusBarController.swift' in macos/Runner
![Xcode > File > New > File...](Step2.1.png)
![Select Swift File](Step2.2.png)
![Name it StatusBarController.swift](Step2.3.png)
Add the following code to the StatusBarController.swift
```swift
import AppKit

class StatusBarController {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    
    init(_ popover: NSPopover) {
        self.popover = popover
        statusBar = NSStatusBar.system
        statusItem = statusBar.statusItem(withLength: 28.0)
        
        if let statusBarButton = statusItem.button {
            statusBarButton.image = #imageLiteral(resourceName: "AppIcon") //change this to your desired image
            statusBarButton.image?.size = NSSize(width: 18.0, height: 18.0)
            statusBarButton.image?.isTemplate = true
            statusBarButton.action = #selector(togglePopover(sender:))
            statusBarButton.target = self
        }
    }
    
    @objc func togglePopover(sender: AnyObject) {
        if(popover.isShown) {
            hidePopover(sender)
        }
        else {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: AnyObject) {
        if let statusBarButton = statusItem.button {
            popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
        }
    }
    
    func hidePopover(_ sender: AnyObject) {
        popover.performClose(sender)
    }
}
```
4. Add the following to macos/Runner/Info.plist to hide the dock icon and application menu
```[language=xml]
<key>LSUIElement</key>
<true/>
```
To close the app programmatically, use the following code
```[language=dart]
exit(0)
```
5. Done!
You can now build your menubar app with flutter.
![Complete](Demo.png)
-------------------------------------------------------

This project is a starting point for a Flutter menubar application in macOS.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
