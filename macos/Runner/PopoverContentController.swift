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
        self.view.autoresizingMask = [.width, .height]
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
