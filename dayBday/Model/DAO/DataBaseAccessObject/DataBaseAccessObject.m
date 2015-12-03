//
//  DataBaseAccessObject.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 22..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "DataBaseAccessObject.h"

@implementation DataBaseAccessObject
{

}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self->connection = [[SqlConnection alloc]init];
    }
    return self;
}
-(void)createDataBase{
}

-(BOOL)insertDataWithString:(NSString *)text targetDate:(NSDate *)target{
    return false;
}

-(void)updateRowWithDate:(NSDate*)targetDate andUpdateDate:(NSString *)text{
    
}

-(NSArray *)selectTargetDataWith:(NSDate *)target{
    return nil;
}

-(NSString *)prepareInsertDinnerTableQueryWithText:(NSString *)text withDate:(NSDate *)date{
    return nil;
}
-(void)deleteRowWithData:(NSDate*)targetDate{
    
}
@end
