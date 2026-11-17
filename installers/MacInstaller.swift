import Cocoa

final class InstallerDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var destination: NSTextField!
    var appPath: NSTextField!
    var details: NSTextView!
    var install: NSButton!
    var choose: NSButton!
    var restart: NSButton!
    var root = ""
    var busy = false
    var installed = false
    let resources = Bundle.main.resourceURL!
    let removing = Bundle.main.object(forInfoDictionaryKey: "SorterRole") as? String == "uninstall"
    let args = CommandLine.arguments
    var font: NSFont { NSFont(name: "Times New Roman", size: 17) ?? NSFont(name: "Times", size: 17)! }

    func argument(_ name: String) -> String? {
        guard let i = args.firstIndex(of: name), i + 1 < args.count else { return nil }
        return args[i + 1]
    }
    func execute(_ command: String, _ arguments: [String]) throws -> String {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: command)
        process.arguments = arguments
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        try process.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        process.waitUntilExit()
        let text = String(data: data, encoding: .utf8) ?? ""
        if process.terminationStatus != 0 { throw NSError(domain: "Codex Sidebar Sort", code: Int(process.terminationStatus), userInfo: [NSLocalizedDescriptionKey: text.isEmpty ? "The installation command failed." : text]) }
        return text
    }
    func payloadNode() -> String { resources.appendingPathComponent("payload/assets/node/node").path }
    func integrationScript() -> String {
        removing ? URL(fileURLWithPath: root).appendingPathComponent("installer/mac-installer.mjs").path : resources.appendingPathComponent("mac-installer.mjs").path
    }
    func node() -> String { removing ? URL(fileURLWithPath: root).appendingPathComponent("node/node").path : payloadNode() }

    func applicationDidFinishLaunching(_ notification: Notification) {
        do {
            if removing {
                let data = try Data(contentsOf: resources.appendingPathComponent("installation.json"))
                root = (try JSONSerialization.jsonObject(with: data) as! [String:String])["root"]!
            } else {
                let output = try execute(payloadNode(), [resources.appendingPathComponent("mac-installer.mjs").path, "info"])
                let info = try JSONSerialization.jsonObject(with: Data(output.utf8)) as! [String:Any]
                root = argument("--destination") ?? info["root"] as! String
            }
            buildWindow()
            if args.contains("--automated") && ProcessInfo.processInfo.environment["GITHUB_ACTIONS"] == "true" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { self.performInstall() }
            }
        } catch { fatalAlert(error.localizedDescription) }
    }
    func label(_ text: String, _ frame: NSRect, size: CGFloat = 17) -> NSTextField {
        let field = NSTextField(wrappingLabelWithString: text)
        field.frame = frame
        field.font = NSFont(name: font.fontName, size: size)
        field.textColor = .labelColor
        window.contentView!.addSubview(field)
        return field
    }
    func button(_ title: String, _ frame: NSRect, _ action: Selector) -> NSButton {
        let result = NSButton(title: title, target: self, action: action)
        result.frame = frame
        result.font = font
        result.bezelStyle = .rounded
        window.contentView!.addSubview(result)
        return result
    }
    func buildWindow() {
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 760, height: 580), styleMask: [.titled, .closable, .miniaturizable], backing: .buffered, defer: false)
        window.title = removing ? "Uninstall Codex Sidebar Sort" : "Install Codex Sidebar Sort"
        window.center()
        _ = label("Codex Sidebar Sort", NSRect(x: 28, y: 514, width: 700, height: 40), size: 30)
        _ = label(removing ? "Remove the companion and its startup service. Your Codex projects and chats stay in Codex." : "Install the bundled runtime, automatic startup service and local MCP connection.", NSRect(x: 28, y: 454, width: 700, height: 50))
        _ = label("Installation folder", NSRect(x: 28, y: 420, width: 650, height: 25))
        destination = NSTextField(string: root)
        destination.frame = NSRect(x: 28, y: 382, width: 585, height: 30)
        destination.font = font
        destination.isEditable = !removing
        window.contentView!.addSubview(destination)
        choose = button("Choose...", NSRect(x: 625, y: 380, width: 108, height: 34), #selector(chooseFolder))
        choose.isEnabled = !removing
        _ = label("Codex application", NSRect(x: 28, y: 340, width: 650, height: 26))
        appPath = NSTextField(string: argument("--app") ?? detectedApp())
        appPath.frame = NSRect(x: 28, y: 302, width: 585, height: 30)
        appPath.font = font
        appPath.isEditable = !removing
        window.contentView!.addSubview(appPath)
        let appButton = button("Choose...", NSRect(x: 625, y: 300, width: 108, height: 34), #selector(chooseApp))
        appButton.isEnabled = !removing
        let scroll = NSScrollView(frame: NSRect(x: 28, y: 104, width: 704, height: 174))
        scroll.hasVerticalScroller = true
        scroll.borderType = .bezelBorder
        details = NSTextView(frame: scroll.bounds)
        details.isEditable = false
        details.font = font
        details.textColor = .labelColor
        details.string = removing ? "Select Uninstall to remove this installation. Close Codex before removing the companion." : "Codex Desktop must already be installed. No Node.js, Python or terminal setup is required.\n\nSave work before restarting Codex. A supported sidebar interface is required for sorting."
        scroll.documentView = details
        window.contentView!.addSubview(scroll)
        restart = button("Restart Codex", NSRect(x: 28, y: 35, width: 180, height: 42), #selector(restartCodex))
        restart.isHidden = true
        install = button(removing ? "Uninstall" : "Install", NSRect(x: 552, y: 35, width: 180, height: 42), #selector(performInstall))
        install.keyEquivalent = "\r"
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    func detectedApp() -> String {
        for base in ["/Applications", NSHomeDirectory() + "/Applications"] {
            for name in ["Codex.app", "ChatGPT.app"] {
                let candidate = base + "/" + name
                if FileManager.default.fileExists(atPath: candidate + "/Contents/Resources/app.asar") { return candidate }
            }
        }
        return ""
    }
    @objc func chooseFolder() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.canCreateDirectories = true
        panel.prompt = "Choose parent folder"
        panel.message = "A dedicated Codex Sidebar Sort folder will be created here."
        if panel.runModal() == .OK { destination.stringValue = panel.url!.appendingPathComponent("Codex Sidebar Sort").path }
    }
    @objc func chooseApp() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedFileTypes = ["app"]
        if panel.runModal() == .OK { appPath.stringValue = panel.url!.path }
    }
    @objc func performInstall() {
        if busy { return }
        if installed { NSApp.terminate(nil); return }
        root = destination.stringValue
        guard root.hasPrefix("/"), root != "/", root != NSHomeDirectory() else { details.string = "Choose a dedicated absolute installation folder."; return }
        busy = true
        install.isEnabled = false
        choose.isEnabled = false
        destination.isEditable = false
        details.string = removing ? "Removing the owned startup service and companion..." : "Installing the bundled runtime and automatic startup service..."
        var arguments = [integrationScript(), removing ? "uninstall" : "install", "--root", root]
        if !removing && !appPath.stringValue.isEmpty { arguments += ["--app", appPath.stringValue] }
        let executable = node()
        DispatchQueue.global().async {
            do {
                let output = try self.execute(executable, arguments)
                DispatchQueue.main.async {
                    self.details.string = output
                    self.busy = false
                    self.installed = true
                    self.install.title = "Finish"
                    self.install.isEnabled = true
                    self.restart.isHidden = self.removing
                    if self.args.contains("--automated") && ProcessInfo.processInfo.environment["GITHUB_ACTIONS"] == "true" {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { NSApp.terminate(nil) }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.details.string = error.localizedDescription
                    self.busy = false
                    self.install.isEnabled = true
                    self.choose.isEnabled = !self.removing
                    self.destination.isEditable = !self.removing
                    if self.args.contains("--automated") { exit(1) }
                }
            }
        }
    }
    @objc func restartCodex() {
        let alert = NSAlert()
        alert.messageText = "Save your work before restarting Codex."
        alert.addButton(withTitle: "Restart Codex")
        alert.addButton(withTitle: "Cancel")
        if alert.runModal() != .alertFirstButtonReturn { return }
        let script = URL(fileURLWithPath: root).appendingPathComponent("installer/mac-installer.mjs").path
        let executable = URL(fileURLWithPath: root).appendingPathComponent("node/node").path
        DispatchQueue.global().async {
            do { let output = try self.execute(executable, [script, "launch", "--root", self.root]); DispatchQueue.main.async { self.details.string = output } }
            catch { DispatchQueue.main.async { self.details.string = error.localizedDescription } }
        }
    }
    func fatalAlert(_ message: String) {
        let alert = NSAlert()
        alert.messageText = "Installer could not start"
        alert.informativeText = message
        alert.runModal()
        NSApp.terminate(nil)
    }
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { !busy }
}
let app = NSApplication.shared
let delegate = InstallerDelegate()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.run()
