//
//  SearchViewController.h
//  dayBday
//
//  Created by LeeYoseob on 2016. 1. 27..
//  Copyright © 2016년 LeeYoseob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedCell.h"
#import "DataBaseManager.h"
@interface SearchViewController : UIViewController <UITableViewDataSource,UITableViewDelegate , UITextFieldDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *searchTableView;


-(void)setDataBaseManager:(NSString *)day;


@end
