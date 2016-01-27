//
//  DinnerDay.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 12. 3..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "DinnerDay.h"
#import "DinnerUtility.h"
//@"CREATE TABLE IF NOT EXISTS dinnerobj ( id INTEGER PRIMARY KEY AUTOINCREMENT, dayStr TEXT,day DATE, dayText TEXT, dayTextData BLOB)"
@implementation DinnerDay
@synthesize attrData;
@synthesize attrText;
@synthesize dayStr;
@synthesize left,right;


-(void)setAttrData:(NSData *)attrData{
    self.attrText = [NSKeyedUnarchiver unarchiveObjectWithData: attrData];
}

-(double)numberFromDateString{
    NSDate * dt = [DinnerUtility StringToDate:dayStr];

    if((left == nil || right == nil) && dayStr.length < 2){
        return -1;
    }
//
    dt = [DinnerUtility StringToDate:dayStr];
    return [dt timeIntervalSince1970];
}



@end

