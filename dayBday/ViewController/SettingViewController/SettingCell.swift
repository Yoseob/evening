//
//  SettingCell.swift
//  dayBday
//
//  Created by LeeYoseob on 2016. 2. 19..
//  Copyright © 2016년 LeeYoseob. All rights reserved.
//

import UIKit


public protocol SettingCellDelegate{
    func changeSwitchState(element: Element ,state: Bool)
    func selectedCell(element: Element)
}


class SettingCell: UITableViewCell {

    @IBOutlet weak var ableSwitch: UISwitch!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var allowButton: UIButton!
    
    var element: Element?{
        didSet{
            
            guard element != nil else{
                allowButton.hidden = true
                noticeLabel.hidden = true
                nameLabel.text = ""
                ableSwitch.hidden = true
                return
            }
            
            let cell = self
            
            if element!.allow && element!.checkBox == false{
                cell.allowButton.hidden = false
                
            }
            cell.nameLabel.text = element!.name.rawValue
            if element!.label {
                cell.noticeLabel.hidden = false
                cell.noticeLabel.text = "some things"
                cell.ableSwitch.hidden = true
            }else if element!.checkBox && element!.allow == false{
                cell.ableSwitch.hidden = false
                cell.noticeLabel.hidden = true
                cell.allowButton.hidden = true
                
            }
        }
    }
    
    
    internal var switchDelegate: SettingCellDelegate?
    
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
        self.ableSwitch.addTarget(self, action: #selector(SettingCell.switchState(_:)), forControlEvents: .ValueChanged)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            switchDelegate!.selectedCell(self.element!)
        }
    }
    
    @objc private func switchState(sender: UISwitch){
        switchDelegate!.changeSwitchState(self.element!, state: sender.on)
    
    }
}


