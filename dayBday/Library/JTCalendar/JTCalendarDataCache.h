//
//  JTCalendarDataCache.h
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import <UIKit/UIKit.h>

@class JTCalendar;
@class JTCalendarDayView;

@interface JTCalendarDataCache : NSObject

@property (weak, nonatomic) JTCalendar *calendarManager;

- (void)reloadData;
- (id)haveEvent:(NSDate *)date;

-(void)removeViews;
-(void)addDayView:(JTCalendarDayView *)view;
-(JTCalendarDayView *)getDayViewWtihIndex:(NSString*)date;
@end
