//
//  MainViewBuilder.m
//  dayBday
//
//  Created by LeeYoseob on 2016. 1. 8..
//  Copyright © 2016년 LeeYoseob. All rights reserved.
//

#import "MainViewBuilder.h"
#import "BottomContainerView.h"
#import "JTCalendarContentView.h"

@implementation MainViewBuilder
{
    BottomContainerView * bottomBar;
    JTCalendarMonthWeekDaysView * weekdaysView;
    ContainerScollView * containerScrollView;
}
@synthesize target;
-(instancetype)initWithTarget:(DayBDayViewController*)targetVC{
    self = [super init];
    if (self) {
        target = targetVC;
    }
    return self;
}


-(void)createNaviBarWithSelecters:(SEL *)selecters{
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"search_btn"] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(0, 0, 30, 30);
    [searchBtn addTarget:target action:selecters[0] forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * searchButton = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    
    UIButton * settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setImage:[UIImage imageNamed:@"setting_btn"] forState:UIControlStateNormal];
    settingButton.frame = CGRectMake(0, 0, 30, 30);
    [settingButton addTarget:target action:selecters[1] forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * settingBarBtn = [[UIBarButtonItem alloc]initWithCustomView:settingButton];
    
    [target.navigationItem setRightBarButtonItems:@[settingBarBtn, searchButton]];

}
-(void)createButtomBar:(BottomContainerView *)barView withSelecters:(SEL *)selecters{
    bottomBar = barView;

    bottomBar.backgroundColor = [UIColor colorWithRed:242/255.f green:242/255.f blue:242/255.f alpha:1.f];
    [target.view addSubview:bottomBar];
    
    
    
    CGFloat buttonSize = bottomBar.frame.size.height - 10;
    
    UIButton * addTask_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addTask_btn setImage:[UIImage imageNamed:@"addTask_btn"] forState:UIControlStateNormal];
    addTask_btn.frame = CGRectMake(bottomBar.frame.size.width/2 - (buttonSize/2), bottomBar.frame.size.height/2 - buttonSize/2, buttonSize , buttonSize);
    [addTask_btn addTarget:target action:selecters[0] forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:addTask_btn];
    
    UIButton * removeTask_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [removeTask_Btn setImage:[UIImage imageNamed:@"removeTask_Btn"] forState:UIControlStateNormal];
    removeTask_Btn.frame = CGRectMake(addTask_btn.frame.origin.x-80, bottomBar.frame.size.height/2 - buttonSize/2, buttonSize , buttonSize);
    [removeTask_Btn addTarget:target action:selecters[1] forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:removeTask_Btn];
    
    UIButton * everNote_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [everNote_btn setImage:[UIImage imageNamed:@"everNote_btn"] forState:UIControlStateNormal];
    everNote_btn.frame = CGRectMake(addTask_btn.frame.origin.x+80, bottomBar.frame.size.height/2 - buttonSize/2, buttonSize , buttonSize);
    [everNote_btn addTarget:target action:selecters[0] forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:everNote_btn];

}
-(void)buildMainContainerTextView:(UITextView *)textview{
    
    target.currentDayTextView.attributedText = textview.attributedText;
    target.currentDayTextView.translatesAutoresizingMaskIntoConstraints = NO;
    target.currentDayTextView.scrollEnabled = YES;
    target.currentDayTextView.pagingEnabled = NO;
    target.currentDayTextView.showsHorizontalScrollIndicator = YES;
    target.currentDayTextView.delegate = target;
    target.currentDayTextView.backgroundColor = [UIColor whiteColor];
    target.currentDayTextView.editable = NO;
    
////    [target.view addSubview:target.currentDayTextView];
//    [target.view addConstraint:[NSLayoutConstraint constraintWithItem:target.currentDayTextView
//                                                          attribute:NSLayoutAttributeTop
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:target.calendarContentView
//                                                          attribute:NSLayoutAttributeBottom
//                                                         multiplier:1.0f
//                                                           constant:0.0f]];
//    
//    [target.view addConstraint:[NSLayoutConstraint constraintWithItem:target.currentDayTextView
//                                                          attribute:NSLayoutAttributeLeft
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:target.view
//                                                          attribute:NSLayoutAttributeLeft
//                                                         multiplier:1.0f
//                                                           constant:0.0f]];
//    
//    [target.view addConstraint:[NSLayoutConstraint constraintWithItem:target.currentDayTextView
//                                                          attribute:NSLayoutAttributeWidth
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:target.view
//                                                          attribute:NSLayoutAttributeWidth
//                                                         multiplier:1.0f
//                                                           constant:0.0f]];
//    
//    [target.view addConstraint:[NSLayoutConstraint constraintWithItem:target.currentDayTextView
//                                                          attribute:NSLayoutAttributeBottom
//                                                          relatedBy:NSLayoutRelationEqual
//                                                             toItem:bottomBar
//                                                          attribute:NSLayoutAttributeTop
//                                                         multiplier:1.0f
//                                                           constant:0.0f]];
}

-(void)buildContainerScrollerView:(UIScrollView *)scrollview{
    [target.view addSubview:scrollview];
    containerScrollView = scrollview;
    
    [target.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollview
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:target.calendarContentView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [target.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollview
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:target.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [target.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollview
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:target.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [target.view addConstraint:[NSLayoutConstraint constraintWithItem:scrollview
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:bottomBar
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
}

-(void)buildWeekDaysView:(JTCalendarMonthWeekDaysView *)view withToItem:(UIView *)toItem{
    weekdaysView = view;
    [target.view addSubview:weekdaysView];
    weekdaysView.backgroundColor = [UIColor clearColor];
    weekdaysView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [target.view addConstraint:[NSLayoutConstraint constraintWithItem:weekdaysView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:toItem
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:10.0f]];
    [target.view addConstraint:[NSLayoutConstraint constraintWithItem:weekdaysView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:target.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:10.0f]];
    
    [target.view addConstraint:[NSLayoutConstraint constraintWithItem:weekdaysView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:target.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0f
                                                           constant:-10.0f]];
    
    [target.view addConstraint:[NSLayoutConstraint constraintWithItem:weekdaysView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:target.calendarContentView
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.0f
                                                           constant:20.f]];

}

-(void)buildGradientView:(UIView *)view{
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [target.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:target.view
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0f
                                                             constant:0.0f]];
    
    [target.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:target.view
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0f
                                                             constant:0.0f]];
    
    [target.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:target.view
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1.0f
                                                             constant:0.0f]];
    
    [target.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:containerScrollView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0f
                                                             constant:0.f]];
}

@end
