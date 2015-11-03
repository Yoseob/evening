//
//  DayBDayViewController.h
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 2..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JTCalendar.h"
//#import "MXLCalendar.h"

@interface DayBDayViewController : UIViewController <JTCalendarDataSource> {
//    MXLCalendar *currentCalendar;
    
    NSDate *selectedDate;
    NSMutableDictionary *savedDates;
    
    NSMutableArray *currentEvents;
}
@property (strong, nonatomic) JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic) JTCalendarContentView *calendarContentView;

@property (strong, nonatomic) JTCalendar *calendar;

@property (strong, nonatomic, readwrite) UIScrollView *currentDayScollView;

@end
