//
//  JTCalendarDataCache.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarDataCache.h"
#import "DataBaseManager.h"
#import "DinnerUtility.h"
#import "JTCalendar.h"

@interface JTCalendarDataCache(){
    NSMutableDictionary *events,*views;
    NSDateFormatter *dateFormatter;
};

@end

@implementation JTCalendarDataCache

- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    views = [[DataBaseManager getDefaultDataBaseManager]calendarDayViewArchive];
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    return self;
}

- (void)reloadData{
    DataBaseManager * manager = [DataBaseManager getDefaultDataBaseManager];
    [manager reloadCachedData];
    [manager prepareAllOfDinnerData];

}

- (id)haveEvent:(NSDate *)date
{
    DataBaseManager * manager = [DataBaseManager getDefaultDataBaseManager];
    return [manager thumbNailWith:date];
}
-(void)removeViews{
    [views removeAllObjects];
}

-(void)addDayView:(JTCalendarDayView *)view{
    NSString * key = [DinnerUtility DateToString:view.date];
    [views setObject:view forKey:key];
}

-(JTCalendarDayView *)getDayViewWtihIndex:(NSString*)date{
    
    
    return views[date];
}


@end