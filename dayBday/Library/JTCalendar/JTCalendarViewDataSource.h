//
//  JTCalendarDataSource.h
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import <Foundation/Foundation.h>

@class JTCalendar;

@protocol JTCalendarDataSource <NSObject>

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date;
- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date;

//-(void)calendardid
@optional
- (void)calendarDidLoadPreviousPage;
- (void)calendarDidLoadNextPage;

@end
