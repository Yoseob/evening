//
//  DinnerAppearance.swift
//  dayBday
//
//  Created by LeeYoseob on 2016. 2. 12..
//  Copyright © 2016년 LeeYoseob. All rights reserved.
//

import UIKit

class DinnerAppearance: NSObject {

    static let defaultAppearance = DinnerAppearance()
    var bottomColor: [UIColor]
    var topColor: [UIColor]
    
    var cntMonth: Int = 0
    
    var currentMonth: NSDate {
        get{
            return NSDate()
        }
        set{
            let calender = NSCalendar.currentCalendar()
            let dateComponent = calender.components(NSCalendarUnit.Month, fromDate: newValue)
            cntMonth = dateComponent.month;
            print("currentMonth \(cntMonth)")
            cntMonth -= 1

        }
    }
    
    
    
    override init() {

        topColor = [
            UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
            ,UIColor(red: 255/255.0, green: 204/255.0, blue: 135/255.0, alpha: 1.0)
            ,UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
            ,UIColor(red: 239/255.0, green: 211/255.0, blue: 187/255.0, alpha: 1.0)
            ,UIColor(red: 252/255.0, green: 129/255.0, blue: 147/255.0, alpha: 1.0)
            ,UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
            ,UIColor(red: 139/255.0, green: 220/255.0, blue: 201/255.0, alpha: 1.0)
            ,UIColor(red: 112/255.0, green: 197/255.0, blue: 80/255.0, alpha: 1.0)
            ,UIColor(red: 249/255.0, green: 209/255.0, blue: 121/255.0, alpha: 1.0)
            ,UIColor(red: 217/255.0, green: 187/255.0, blue: 142/255.0, alpha: 1.0)
            ,UIColor(red: 174/255.0, green: 152/255.0, blue: 189/255.0, alpha: 1.0)
            ,UIColor(red: 235/255.0, green: 194/255.0, blue: 197/255.0, alpha: 1.0)
        ]
        bottomColor =
        [
            UIColor(red: 213/255.0, green: 175/255.0, blue: 224/255.0, alpha: 1.0)
            ,UIColor(red: 122/255.0, green: 192/255.0, blue: 207/255.0, alpha: 1.0)
            ,UIColor(red: 108/255.0, green: 183/255.0, blue: 152/255.0, alpha: 1.0)
            ,UIColor(red: 221/255.0, green: 153/255.0, blue: 176/255.0, alpha: 1.0)
            ,UIColor(red: 141/255.0, green: 198/255.0, blue: 248/255.0, alpha: 1.0)
            ,UIColor(red: 107/255.0, green: 214/255.0, blue: 223/255.0, alpha: 1.0)
            ,UIColor(red: 21/255.0, green: 184/255.0, blue: 201/255.0, alpha: 1.0)
            ,UIColor(red: 249/255.0, green: 212/255.0, blue: 132/255.0, alpha: 1.0)
            ,UIColor(red: 240/255.0, green: 120/255.0, blue: 68/255.0, alpha: 1.0)
            ,UIColor(red: 96/255.0, green: 145/255.0, blue: 152/255.0, alpha: 1.0)
            ,UIColor(red: 99/255.0, green: 146/255.0, blue: 152/255.0, alpha: 1.0)
            ,UIColor(red: 213/255.0, green: 175/255.0, blue: 224/255.0, alpha: 1.0)
        ]
    }
    
    internal func getBottomColor() -> UIColor{
        print(mainColor().bottom)
        return mainColor().bottom
    }
    
    internal func getTopColor() -> UIColor{
        print(mainColor().top)
        return mainColor().top
    }
    
    internal func colorFromView(targetView: UIView) -> UIImage{
        UIGraphicsBeginImageContext(targetView.frame.size)
        targetView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    
    func mainColor() -> (top: UIColor, bottom: UIColor) {
        
        return (topColor[cntMonth],bottomColor[cntMonth])
    }
    
}
