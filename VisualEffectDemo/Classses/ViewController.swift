//
//  ViewController.swift
//  VisualEffectDemo
//
//  Created by Nirzar Gandhi on 06/03/24.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var barContainer: UIView!
    @IBOutlet weak var barStackView: UIStackView!
    @IBOutlet weak var barView1: UIView!
    @IBOutlet weak var barView2: UIView!
    @IBOutlet weak var barView3: UIView!
    @IBOutlet weak var barView1Width: NSLayoutConstraint!
    @IBOutlet weak var barView2Width: NSLayoutConstraint!
    @IBOutlet weak var barView3Width: NSLayoutConstraint!
    
    
    // MARK: -
    // MARK: - View init Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setControlsProperty()
        
        self.barView1Width.constant = 0
        self.barView1.updateConstraints()
        
        self.barView2Width.constant = 0
        self.barView2.updateConstraints()
        
        self.barView3Width.constant = 0
        self.barView3.updateConstraints()
        
        
        //self.addDynamicBarViews()
        //self.setBarData()
    }
    
    fileprivate func setControlsProperty() {
        
        self.view.backgroundColor = .black
        
        // Bar Container
        self.barContainer.backgroundColor = .gray
        self.barContainer.layer.cornerRadius = 5.0
        self.barContainer.clipsToBounds = true
        
        // Bar View 1
        self.barView1.backgroundColor = UIColor(hex: "#016d77")
        self.barView1.isHidden = true
        
        // Bar View 2
        self.barView2.backgroundColor = UIColor(hex: "#FFD068")
        self.barView2.isHidden = true
        
        // Bar View 3
        self.barView3.backgroundColor = UIColor(hex: "#FF4155")
        self.barView3.isHidden = true
    }
}


// MARK: - Call Back
extension ViewController {
    
    fileprivate func addDynamicBarViews() {
        
        // Bar View
        for view in self.barContainer.subviews {
            view.removeFromSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [self] in
            
            var progress = 0
            var previousXPosition : CGFloat = 0
            var width : CGFloat = 0
            
            for i in 0..<3 {
                
                progress = (i == 0) ? 25 : (i == 1) ? 0 : 35
                
                previousXPosition = (i == 0) ? 0 : (previousXPosition + width)
                width = CGFloat(progress)/100 * self.barContainer.frame.width
                
                let barSubView = UIView(frame: CGRect(x: previousXPosition, y: 0, width: width, height: self.barContainer.frame.height))
                barSubView.tag = i
                
                if i == 0 {
                    barSubView.backgroundColor = UIColor(hex: "#FFB001")
                }
                
                if i == 1 {
                    barSubView.backgroundColor = UIColor(hex: "#FFD068")
                }
                
                if i == 2 {
                    barSubView.backgroundColor = UIColor(hex: "#FFEFCD")
                }
                
                self.barContainer.addSubview(barSubView)
            }
        }
    }
    
    fileprivate func setBarData(newUserCout: Int, digitalIdCount: Int, renewalCount: Int, total: Double) {
        
        self.barView1.isHidden = false
        self.barView2.isHidden = false
        self.barView3.isHidden = false
        
        let viewWidth : CGFloat = self.barContainer.frame.width
        let minWidth: CGFloat = 6
        
        var w1 = 0.0
        var w2 = 0.0
        var w3 = 0.0
        
        if newUserCout > 0 {
            let per1 = CGFloat(newUserCout) * 100 / total
            w1 = per1 * viewWidth / 100
            w1 = w1 < minWidth ? minWidth : w1
        }
        
        if digitalIdCount > 0 {
            let per2 = CGFloat(digitalIdCount) * 100 / total
            w2 = per2 * viewWidth / 100
            w2 = w2 < minWidth ? minWidth : w2
        }
        
        if renewalCount > 0 {
            let per3 = CGFloat(renewalCount) * 100 / total
            w3 = per3 * viewWidth / 100
            w3 = w3 < minWidth ? minWidth : w3
        }
        
        let allViewWidth = w1 + w2 + w3
        
        if allViewWidth > viewWidth {
            
            let diff = allViewWidth - viewWidth
            let limit = 100.0
            
            print("\(w1), \(w2), \(w3)")
            
            if w1 > 0 && w2 > 0 && w1 >= limit && w2 >= limit {
                w1 -= diff / 2
                w2 -= diff / 2
            } else if w2 > 0 && w3 > 0 && w2 >= limit && w3 >= limit {
                w2 -= diff / 2
                w3 -= diff / 2
            } else if w3 > 0 && w1 > 0 && w3 >= limit && w1 >= limit {
                w3 -= diff / 2
                w1 -= diff / 2
            } else if w1 > 0 && w1 >= limit {
                w1 -= diff
            } else if w2 > 0 && w2 >= limit {
                w2 -= diff
            } else if w3 > 0 && w3 >= limit {
                w3 -= diff
            }
        }
        
        print("\(w1), \(w2), \(w3)")
        
        self.barView1Width.constant = w1
        self.barView1.updateConstraints()
        
        self.barView2Width.constant = w2
        self.barView2.updateConstraints()
        
        self.barView3Width.constant = w3
        self.barView3.updateConstraints()
        
        UIView.animate(withDuration: 1.2, delay: 0, options: .curveEaseInOut, animations: {
            self.barContainer.layoutIfNeeded()
        }, completion: nil)
    }
}


// MARK: - UIButton Touch & Action
extension ViewController {
    
    @IBAction func resetBtnTouch(_ sender: UIButton) {
        
        self.barView1Width.constant = 0
        self.barView1.updateConstraints()
        
        self.barView2Width.constant = 0
        self.barView2.updateConstraints()
        
        self.barView3Width.constant = 0
        self.barView3.updateConstraints()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            self.setBarData(newUserCout: 1, digitalIdCount: 330, renewalCount: 169, total: 500.0)
        }
    }
}


// MARK: - UIColor
extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        
        var hexString = ""
        
        if hex.hasPrefix("#") {
            let nsHex = hex as NSString
            hexString = nsHex.substring(from: 1)
        } else {
            hexString = hex
        }
        
        let scanner = Scanner(string: hexString)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hexString.count) {
            case 3:
                red = CGFloat((hexValue & 0xF00) >> 8) / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
                blue = CGFloat(hexValue & 0x00F) / 15.0
            case 6:
                red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                blue = CGFloat(hexValue & 0x0000FF) / 255.0
            default:
                debugPrint("Invalid HEX string, number of characters after '#' should be either 3, 6", terminator: "")
            }
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
