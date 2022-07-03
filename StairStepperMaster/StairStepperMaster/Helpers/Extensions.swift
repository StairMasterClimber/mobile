//
//  Extensions.swift
//  BeAware
//
//  Created by Saamer Mansoor on 2/3/22.
//
import AVFoundation
import SwiftUI

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

//@available(iOS 15.0, *)
extension View {
    /// Sets the text color for a navigation bar title.
    /// - Parameter color: Color the title should be
    ///
    /// Supports both regular and large titles.
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        
        // Set appearance for both normal and large sizes.
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: uiColor, .font:UIFont(name: "Avenir-Black", size: 24)!]
        appearance.largeTitleTextAttributes = [.foregroundColor: uiColor, .font:UIFont(name: "Avenir-Black", size: 30)! ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        //        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor, .font:UIFont(name: "Avenir-Black", size: 24)!]
        //        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor, .font:UIFont(name: "Avenir-Black", size: 30)! ]
        
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        
        UITabBar.appearance().standardAppearance = tabAppearance
        
        //            UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        return self
    }
}

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}
extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let screenSize = UIScreen.main.bounds.size
}

extension UINavigationController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        //.inline
        let standard = navigationBar.standardAppearance
        standard.backgroundColor = .clear
        standard.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 20)!]
        //This one is for standard and compact
        standard.setBackIndicatorImage(UIImage(systemName: "checkmark"), transitionMaskImage: UIImage(systemName: "chevron.left"))
        
        //Landscape
        let compact = navigationBar.compactAppearance
        compact?.backgroundColor = .clear
        compact?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        //.large
        let scrollEdge = navigationBar.standardAppearance
        //This image overrides standard and compact
        scrollEdge.setBackIndicatorImage(UIImage(systemName: "chevron.left"), transitionMaskImage: UIImage(systemName: "chevron.left"))
        
        scrollEdge.backgroundColor = .clear
        
        scrollEdge.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 30)!]
        
        scrollEdge.backButtonAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.clear]
        
        navigationBar.standardAppearance = standard
        navigationBar.compactAppearance = compact
        navigationBar.scrollEdgeAppearance = scrollEdge
        
        //This color the Back Button Image
        navigationBar.tintColor = .white
        
    }
}

public extension UIDevice {
    
    static let iPadDevice: Bool = {
        print (UIDevice.modelName)
        if UIDevice.modelName.contains("iPad")
        {
            return true
        }
        return false
    }()
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return ""
    }()
    
}

extension Sequence {
    func asyncForEach(
        _ operation: (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }
}
