//
//  SearchAndLoadViewController.swift
//  dayBday
//
//  Created by LeeYoseob on 2016. 2. 7..
//  Copyright © 2016년 LeeYoseob. All rights reserved.
//

import UIKit

let SEARCH_BAR_HEIGHT: CGFloat = 30
let PLACE_HOLDER: String = " Search.."


class SearchAndLoadViewController: UIViewController {

    var tableView: UITableView!
    var textfield: UITextField!

    var bottomContaint: NSLayoutConstraint!
    var dbManager: DataBaseManager!
    var headerStrings = [String]()
    var tableDatas = [AnyObject]()
    
    var currentDate: NSDate!
    var dateComponents: NSDateComponents!
    
    var preIndex: Int = 0
    var nextIndex: Int = 0
    
    var isReload: Bool = false

    override func loadView() {
        super.loadView()
        
        let gradientViewforColor = OLNGradientView(frame:CGRectMake(0, 0, view.frame.size.width, self.view.frame.size.height/2))
        gradientViewforColor.topColor = UIColor.redColor()
        gradientViewforColor.bottomColor = UIColor.yellowColor()

        let bounceColor = UIColor(patternImage: colorFromView(gradientViewforColor))

        let testView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 44))
        testView.backgroundColor = UIColor.yellowColor()
        
        view.addSubview(testView)
        
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()//UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0)
        
        tableView = UITableView(frame: CGRectMake(0, 44, view.frame.size.width, view.frame.size.height - 44), style: .Plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        tableView.separatorColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 231/255.0, alpha: 1.0)
        tableView.backgroundColor = UIColor.whiteColor()//UIColor(red: 250/255.0, green: 250/255.0, blue: 251/255.0, alpha: 1.0)
        
        view.addSubview(tableView)
        
    
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self?.tableView.dg_stopLoading()
            })
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(bounceColor)//UIColor(red: 38/255.0, green: 38/255.0, blue: 38/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }

    deinit {
        tableView.dg_removePullToRefresh()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        self.setUpNavibar()
        self.registerForKeyboardNotifications()
        self.setUpTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func colorFromView(targetView: UIView) -> UIImage{
        UIGraphicsBeginImageContext(targetView.frame.size)
        targetView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    internal func setDataBasemanager(day: String){
        dbManager = DataBaseManager.getDefaultDataBaseManager() as! DataBaseManager!
        var date: String! = nil
        currentDate = NSDate()
        dateComponents = NSDateComponents()
        
        date = "\(currentDate)"
        print(date)
        let index = date.startIndex.advancedBy(0)..<date.endIndex.advancedBy(-18)
        date = date[index]
        headerStrings.append(date)
        self.reloadTableView()

    }
    
    func reloadTableView(){
        tableDatas.removeAll()
        var result = [DinnerDay]()
        for day in headerStrings {
            result =  (dbManager.feedListUptodateCount(31, endDateStr: day) as! [DinnerDay])
            print("\(result.count) , \(day)")
            if result.count > 0 {
                tableDatas.append(result)
            }
        }
        tableView.reloadData()
    }
    
    func setUpTableView(){
        
        self.view.addConstraint(NSLayoutConstraint.init(item: tableView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
        
        self.view.addConstraint(NSLayoutConstraint.init(item: tableView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0))
        
        self.view.addConstraint(NSLayoutConstraint.init(item: tableView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0))
        
        bottomContaint = NSLayoutConstraint.init(item: tableView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0)
        
        self.view.addConstraint(bottomContaint)

    }
    
    func setUpNavibar(){
        
        let settingButton: UIButton = UIButton(type: .Custom)
        settingButton.setImage(UIImage(named: "navi_back"), forState:.Normal)
        settingButton.frame = CGRectMake(0, 0, 30, 30)
        settingButton.addTarget(self, action: "backViewController", forControlEvents: .TouchUpInside)
        
        let barbuttonItem: UIBarButtonItem = UIBarButtonItem(customView: settingButton)
        let naviLefipadding: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target:nil, action: "")
        
        naviLefipadding.width = -10
        self.navigationItem.setLeftBarButtonItems([naviLefipadding,barbuttonItem], animated: true)
        
        textfield = UITextField(frame: CGRectMake(0, 0,self.view.frame.size.width, SEARCH_BAR_HEIGHT))
        textfield.backgroundColor = UIColor.clearColor()
        textfield.layer.cornerRadius = 2.0
        textfield.clearButtonMode = .Always
        textfield.textColor = UIColor.grayColor()
        textfield.text = PLACE_HOLDER
        textfield.delegate = self
        self.navigationItem.titleView = textfield
        
    }
    func registerForKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden", name: UIKeyboardWillHideNotification, object: nil)
    }
    func registerForTextFieldNotification(){
        textfield.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged)
    }

    func textFieldDidChange(){
    
    }
    
    func keyboardWasShown(aNotification: NSNotification){
        let info = (aNotification.userInfo ?? [:]) as NSDictionary
        let kbSize: CGSize = (info.objectForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue.size)!
        bottomContaint.constant = -kbSize.height;
        if #available(iOS 9.0, *) {
            self.viewIfLoaded
        } else {
            // Fallback on earlier versions
        }
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(aNotification: NSNotification){
        let info = (aNotification.userInfo ?? [:]) as NSDictionary
        let kbSize: CGSize = (info.objectForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue.size)!
        bottomContaint.constant = kbSize.height;
        if #available(iOS 9.0, *) {
            self.viewIfLoaded
        } else {
            // Fallback on earlier versions
        }
    }
    
    func backViewController(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: - UITableView Data Source

extension SearchAndLoadViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableDatas.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentArray = tableDatas[section]
        return currentArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "FeedCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if cell == nil {
            let nibArr =  NSBundle.mainBundle().loadNibNamed("FeedCell", owner: self, options: nil)
            cell = nibArr.first as! FeedCell
//            cell!.contentView.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 251/255.0, alpha: 1.0)
        }
        let currentArray = tableDatas[indexPath.section]
        var dinner = currentArray.objectAtIndex(indexPath.row)
        
        if let cell = cell {
            (cell as! FeedCell).bindDiiner(dinner as! DinnerDay)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 87
    }
    
}
// MARK: -
// MARK: UITextField Delegate
extension SearchAndLoadViewController: UITextFieldDelegate{
    
}


// MARK: -
// MARK: UIScrollViewDelegate
extension SearchAndLoadViewController: UIScrollViewDelegate{
    
}
// MARK: -
// MARK: UITableView Delegate

extension SearchAndLoadViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
