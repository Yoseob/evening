//
//  DinnerDay.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 12. 3..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "DinnerDay.h"
//@"CREATE TABLE IF NOT EXISTS dinnerobj ( id INTEGER PRIMARY KEY AUTOINCREMENT, dayStr TEXT,day DATE, dayText TEXT, dayTextData BLOB)"
@implementation DinnerDay
@synthesize attrData;
@synthesize attrText;

-(void)setAttrData:(NSData *)attrData{
    self.attrText = [NSKeyedUnarchiver unarchiveObjectWithData: attrData];
}


@end

