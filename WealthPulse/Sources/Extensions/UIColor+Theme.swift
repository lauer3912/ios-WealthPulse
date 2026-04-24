import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }

    static var primaryGreen: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(hex: "#30D158") : UIColor(hex: "#34C759")
        }
    }

    static var primaryBlue: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(hex: "#0A84FF") : UIColor(hex: "#007AFF")
        }
    }

    static var incomeGreen: UIColor {
        return UIColor(hex: "#34C759")
    }

    static var expenseRed: UIColor {
        return UIColor(hex: "#FF3B30")
    }

    static var warningOrange: UIColor {
        return UIColor(hex: "#FF9500")
    }

    static var cardBackground: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(hex: "#1C1C1E") : UIColor.white
        }
    }

    static var secondaryBackground: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(hex: "#2C2C2E") : UIColor(hex: "#F2F2F7")
        }
    }

    static var tertiaryBackground: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(hex: "#3A3A3C") : UIColor(hex: "#E5E5EA")
        }
    }

    static var primaryText: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        }
    }

    static var secondaryText: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(hex: "#8E8E93") : UIColor(hex: "#8E8E93")
        }
    }
}
