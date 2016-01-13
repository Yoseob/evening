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
@interface ScrollViewManager : NSObject <UIScrollViewDelegate ,HPTextViewTapGestureRecognizerDelegate>
@property (strong ,nonatomic)DayBDayViewController * viewController;
@property (strong,nonatomic)ContainerScollView * container;


-(id)initWithViewController:(DayBDayViewController *)vc;


-(void)DinnerDataBind:(NSArray * )dinnerDatas;


//prepare leftView

-(void)prepareWithLeftDay:(DinnerDay *)day;

//prepare rightView

-(void)prepareWithRightDay:(DinnerDay *)day;


-(void)changeContainerViewSize:(CGFloat)height;

-(void)visibleCurrentTextView:(NSDate*) selectedDay;
-(void)visibleToday;
-(void)insertNewTextView:(NSDate *)date;

@end
