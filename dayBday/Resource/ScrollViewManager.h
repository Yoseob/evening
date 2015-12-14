//
//  ScrollViewManager.h
//  dayBday
//
//  Created by LeeYoseob on 2015. 12. 4..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayBDayViewController.h"
#import "ContainerScollView.h"
#import "DinnerDay.h"
@interface ScrollViewManager : NSObject
@property (strong ,nonatomic)DayBDayViewController * viewController;
@property (strong,nonatomic)ContainerScollView * container;


-(id)initWithViewController:(DayBDayViewController *)vc;




//prepare leftView

-(void)prepareWithLeftDay:(DinnerDay *)day;

//prepare rightView

-(void)prepareWithRightDay:(DinnerDay *)day;

@end
