//
//  JTCalendar.h
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import <UIKit/UIKit.h>

#import "JTCalendarViewDataSource.h"
#import "JTCalendarAppearance.h"

#import "JTCalendarMenuView.h"
#import "JTCalendarContentView.h"
#import "JTCalendarDayView.h"
#import "JTCalendarDataCache.h"
@interface JTCalendar : NSObject<UIScrollViewDelegate>

@property (weak, nonatomic) JTCalendarMenuView *menuMonthsView;
@property (weak, nonatomic) JTCalendarContentView *contentView;

@property (weak, nonatomic) id<JTCalendarDataSource> dataSource;
@property (weak, nonatomic) id<CalenderDelegate> delegate;

@property (strong, nonatomic) NSDate *currentDate;
@property (strong, nonatomic) NSDate *currentDateSelected;

@property (strong, nonatomic, readonly) JTCalendarDataCache *dataCache;
@property (strong, nonatomic, readonly) JTCalendarAppearance *calendarAppearance;
+(id)getDefaultJTCalendar;
- (void)reloadData;
- (void)reloadAppearance;

- (void)loadPreviousMonth DEPRECATED_MSG_ATTRIBUTE("Use loadPreviousPage instead");
- (void)loadNextMonth DEPRECATED_MSG_ATTRIBUTE("Use loadNextPage instead");

- (void)loadPreviousPage;
- (void)loadNextPage;
- (void)selectedDayView:(id)view;
-(void)selectedDayViewWithIndex:(NSString *)dayStr;
- (void)repositionViews;


-(void)currentDayViewWithDayString:(NSString *)dayStr;
-(void)nextDayViewDayWithDayString:(NSString *)dayStr;
-(void)changingPercent:(float)alhpa;

@end
