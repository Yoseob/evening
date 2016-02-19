//
//  SettingCell.swift
//  dayBday
//
//  Created by LeeYoseob on 2016. 2. 19..
//  Copyright © 2016년 LeeYoseob. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var ableSwitch: UISwitch!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noticeLabel: UILabel!
    var onTintColor: UIColor! {
        set{
            self.ableSwitch.onTintColor = newValue
        }
        get{
            return self.ableSwitch.onTintColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ableSwitch.onTintColor = UIColor(red: 140/255, green: 198/255, blue: 247/255, alpha: 1.0)
        self.nameLabel.textColor = UIColor(red: 80/255, green:80/255 , blue: 80/255, alpha: 1.0)
        self.noticeLabel.textColor = UIColor.lightGrayColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
