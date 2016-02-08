//
//  MainViewBuilder.h
//  dayBday
//
//  Created by LeeYoseob on 2016. 1. 8..
//  Copyright © 2016년 LeeYoseob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayBDayViewController.h"
#import "JTCalendarMonthWeekDaysView.h"
@interface MainViewBuilder : NSObject

@property (strong,nonatomic)DayBDayViewController * target;

-(instancetype)initWithTarget:(UIViewController*)target;


-(void)buildMainContainerTextView:(UITextView *)textview;
-(void)buildContainerScrollerView:(UIScrollView*)scrollview;
-(void)buildWeekDaysView:(JTCalendarMonthWeekDaysView *)view withToItem:(UIView *)toItem;
-(void)buildGradientView:(UIView *)view;

-(void)createNaviBarWithSelecters:(SEL *)selecters;
-(void)createButtomBar:(UIView *)bottomBar withSelecters:(SEL *)selecters;
@end
