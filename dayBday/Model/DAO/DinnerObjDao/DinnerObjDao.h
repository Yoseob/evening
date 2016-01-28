//
//  DinnerObjDao.h
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 25..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "DataBaseAccessObject.h"
#import "DinnerDay.h"
@interface DinnerObjDao : DataBaseAccessObject
+(id)getDefaultDinnerObjDao;

-(NSArray *)selectDataWithQuery:(NSString *)query;

-(BOOL)insertDataWithString:(NSString *)text attribute :(NSData*)textData targetDate:(NSDate *)target;

@end
