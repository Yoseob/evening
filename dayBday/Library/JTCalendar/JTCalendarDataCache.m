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
    NSMutableDictionary *events;
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
    
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    return self;
}

- (void)reloadData
{

    DataBaseManager * manager = [DataBaseManager getDefaultDataBaseManager];
    [manager reloadCachedData];
    [manager prepareAllOfDinnerData];

}

- (id)haveEvent:(NSDate *)date
{
    DataBaseManager * manager = [DataBaseManager getDefaultDataBaseManager];
    return [manager thumbNailWith:date];

}

@end