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
@property (strong,nonatomic)UIScrollView * container;


-(id)initWithViewController:(DayBDayViewController *)vc;

-(void)initialScrollViewWith:(NSDate *)today;
-(void)DinnerDataBind:(NSArray * )dinnerDatas;

-(void)changeContainerViewSize:(CGFloat)height;

-(void)visibleCurrentTextView:(NSDate*) selectedDay;
-(void)visibleCurrentTextView:(NSDate*) selectedDay withGesture:(HPTextViewTapGestureRecognizer *)ges;
-(void)visibleToday;
-(void)reloadView;

-(void)insertNewTextView:(NSDate *)date;
-(DinnerDay *)removeDinnerData:(NSString *)dayStr;


-(BOOL)ExistDinner:(NSDate *)date;
@end
