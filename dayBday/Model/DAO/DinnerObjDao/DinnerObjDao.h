//
//  DinnerObjDao.h
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 25..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "DataBaseAccessObject.h"

@interface DinnerObjDao : DataBaseAccessObject
+(id)getDefaultDinnerObjDao;
-(NSArray *)selectDayTextDataWith:(NSDate *)target;
-(BOOL)insertDataWithString:(NSString *)text attribute :(NSData*)textData targetDate:(NSDate *)target;
@end
