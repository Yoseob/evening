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
    
    override init() {

        topColor = [
            UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
            ,UIColor(red: 255/255.0, green: 204/255.0, blue: 135/255.0, alpha: 1.0)
            ,UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
            ,UIColor(red: 250/255.0, green: 173/255.0, blue: 153/255.0, alpha: 1.0)
            
            ,UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
            ,UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
            ,UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
            ,UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
            ,UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
            ,UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
            ,UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
            ,UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
        ]
        bottomColor =
        [
            UIColor(red: 213/255.0, green: 175/255.0, blue: 224/255.0, alpha: 1.0)
            ,UIColor(red: 122/255.0, green: 192/255.0, blue: 207/255.0, alpha: 1.0)
            ,UIColor(red: 108/255.0, green: 183/255.0, blue: 152/255.0, alpha: 1.0)
            
            ,UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
            ,UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
            ,UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
            ,UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
            ,UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
            ,UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
            ,UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
            ,UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
            ,UIColor(red: 143/255.0, green: 198/255.0, blue: 250/255.0, alpha: 1.0)
        ]
    }
    
    internal func getBottomColor() -> UIColor{
        return mainColor().bottom
    }
    
    internal func getTopColor() -> UIColor{
        return mainColor().top
    }
    
    internal func mainColor() -> (top: UIColor, bottom: UIColor) {
        let calender = NSCalendar.currentCalendar()
        let dateComponent = calender.components(NSCalendarUnit.Month, fromDate: NSDate())
        let currentMonth = dateComponent.month;
        return (topColor[currentMonth],bottomColor[currentMonth])
    }
    
}
