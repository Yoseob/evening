//
//  SettingInfoViewController.swift
//  dayBday
//
//  Created by LeeYoseob on 2016. 2. 16..
//  Copyright © 2016년 LeeYoseob. All rights reserved.
//

import UIKit

enum ElementName: String{
    case Undefined = "Undefined"
    case ICloud = "ICloud"
    case DropBox = "DropBox"
    case Calender = "Calender"
    case Passcode = "Passcode"
    case ChangePassCode = "Change Passcode"
    case TouchId = "Touch ID"
    case FontSize = "Font size"
    case hourTime = "24-Hour Time"
    case Email = "E-mail the developer"
    case RateThisApp = "Rate this app"
    case Licence = "Licence"
    
    
}

typealias Callback = ()->()
public class Element{
    
    var name: ElementName = .Undefined
    var checkBox = false
    var label = false
    var allow = false
    
    convenience init(name: ElementName, _ hasCheckBox: Bool, _ hasLabel: Bool, _ hasAllow: Bool ){
        self.init()
        self.name = name
        self.checkBox = hasCheckBox
        self.label = hasLabel
        self.allow = hasAllow
    }
    
    init(){
        name = .Undefined
        allow = false
        checkBox = false
    }
    
    
}

func bindCellWithElement(cell: SettingCell, element: Element){
    print(element.name)
    cell.element = element
}

class SettingInfoViewController: UIViewController {

    
    @IBOutlet var settingTable: UITableView!
    
    let apprearance = DinnerAppearance.defaultAppearance
    var settingsList = [[Element]]()
    var sessionHeaders = [String]()
    
    var callbackTable = [ElementName: Callback?]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initAndAlloc()
        // Do any additional setup after loading the view.
    }

    func initAndAlloc(){
        
        self.setSettingElements()
        
        settingTable.delegate = self
        settingTable.dataSource = self


        let gradientViewforColor = OLNGradientView(frame:CGRectMake(0, 0, view.frame.size.width, (self.navigationController?.navigationBar.frame.height)!))
        gradientViewforColor.topColor = apprearance.getTopColor()
        gradientViewforColor.bottomColor = apprearance.getTopColor()
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.setBackgroundImage(apprearance.colorFromView(gradientViewforColor), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.title = "SETTING"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
//        [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
        
        let rightBarbuttonCustomView = UIButton(type: .Custom)
        rightBarbuttonCustomView.frame = CGRectMake(0, 0, 30, 30)
        rightBarbuttonCustomView.addTarget(self, action: #selector(SettingInfoViewController.popViewController(_:)), forControlEvents: .TouchUpInside)
        rightBarbuttonCustomView.setImage(UIImage(named: "btnDone"), forState: .Normal)
        
        let rightBarbuttonItem = UIBarButtonItem(customView: rightBarbuttonCustomView)
        self.navigationItem.rightBarButtonItem = rightBarbuttonItem
        
        
        let backgradientViewforColor = OLNGradientView(frame:CGRectMake(0, 0, view.frame.size.width, (self.navigationController?.navigationBar.frame.height)!))
        backgradientViewforColor.topColor = apprearance.getTopColor()
        backgradientViewforColor.bottomColor = apprearance.getBottomColor()
        
        self.settingTable.backgroundView = backgradientViewforColor

    }
    
    func setSettingElements(){
        
        let firstSection = [Element(name: .ICloud, true, false, false),
                            Element(name: .DropBox, false, false, true)]
        settingsList.append(firstSection)
        sessionHeaders.append("SYNC OPTIONS")
        
        let secondSection = [Element(name: .Calender, false, false, false)]
        settingsList.append(secondSection)
        sessionHeaders.append("WIDGET")
        
        let thirdSection = [Element(name: .Passcode, true, false, false),
                            Element(name: .ChangePassCode, false, false, false),
                            Element(name: .TouchId, false, false, false)]
        
        settingsList.append(thirdSection)
        sessionHeaders.append("PASSCODE / TOUCH ID")
        
        let fourSection = [Element(name: .FontSize, false, true, true),
                           Element(name: .hourTime, true, false, false)]
        settingsList.append(fourSection)
        sessionHeaders.append("WRITE")
        
        let lastSection = [Element(name: .Email, false, false, true),
                           Element(name: .RateThisApp, false, false, true),
                           Element(name: .Licence, false, false, true)]
        settingsList.append(lastSection)
        sessionHeaders.append("SERVICE")
        
        callbackTable[.DropBox] = {
            let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Backup", otherButtonTitles: "Restore","Unlink")
            actionSheet.destructiveButtonIndex = 3
            actionSheet.showInView(self.view)
        }
        
        callbackTable[.ChangePassCode] = {}
        
        callbackTable[.FontSize] = {}
        
        callbackTable[.Email] = {}
        
        callbackTable[.RateThisApp] = {}
        
        callbackTable[.Licence] = {}
        
        
        
    }
    
    func popViewController(sender: UIButton){
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    
    func colorFromView(targetView: UIView) -> UIImage{
        UIGraphicsBeginImageContext(targetView.frame.size)
        targetView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SettingInfoViewController: UITableViewDelegate{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 42
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 37.7
    }
    func tableView(tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.frame = CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)
            headerView.textLabel?.textColor = UIColor.lightGrayColor()
            headerView.textLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 11.0)
            headerView.textLabel?.sizeToFit()

            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10;
            let newAttriString = NSMutableAttributedString(string: (headerView.textLabel?.text)!)
            newAttriString.addAttributes([NSParagraphStyleAttributeName : paragraphStyle], range: NSMakeRange(0, (headerView.textLabel?.text?.characters.count)!))
            newAttriString.addAttribute(kCTSuperscriptAttributeName as String, value: -3, range:  NSMakeRange(0, (headerView.textLabel?.text?.characters.count)!))
            
//            (__bridge NSString *)kCTSuperscriptAttributeName value:@(-1)
            headerView.textLabel?.attributedText = newAttriString

        }
    }
    
}

extension SettingInfoViewController: UIActionSheetDelegate{
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        print(buttonIndex)
    }
}

extension SettingInfoViewController: UITableViewDataSource{

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "SettingCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if cell == nil {
            let nibArr =  NSBundle.mainBundle().loadNibNamed(cellIdentifier, owner: self, options: nil)
            cell = nibArr.first as! SettingCell
        }
        
        if let cell = cell{
            let tempCell = (cell as! SettingCell)
            tempCell.onTintColor = apprearance.getTopColor()
            tempCell.switchDelegate = self
            tempCell.element = nil
            bindCellWithElement(tempCell, element: settingsList[indexPath.section][indexPath.row])
        }
        return cell!
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return sessionHeaders.count
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sessionHeaders[section]
    }
    
    
//    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
//        let rect = CGRectMake(18, 10, self.view.frame.size.width, 30)
//        let headerLabel = UILabel(frame:rect)
//        
//    }

}

extension SettingInfoViewController: SettingCellDelegate{
    func changeSwitchState(element: Element, state: Bool) {
        SyncManager.sharedInstance.changeICloudState(state)
    }
    
    func selectedCell(element: Element) {
        if let callback = callbackTable[element.name]{
            callback!()
        }
    }
}


