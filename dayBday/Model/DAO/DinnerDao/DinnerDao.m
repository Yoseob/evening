//
//  DinnerDao.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 21..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "DinnerDao.h"
#import "SqlConnection.h"
#import "DinnerUtility.h"

#define MAIN_TABLE @"dinner"
@implementation DinnerDao
{
 

}

+(id)getDefaultDinnerDao{
    static DinnerDao * dao = nil;
    if(!dao){
        dao = [[DinnerDao alloc]init];
    }
    return dao;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}
-(void)createDataBase{
    
    [connection createTable:[connection getdbPath] andCreateQuery:@"CREATE TABLE IF NOT EXISTS dinner ( dayStr TEXT PRIMARY KEY , dayText TEXT, numberOfImage INTEGER , numberOfCheckBox INTEGER )"];
}

-(BOOL)insertDataWithString:(NSString *)text targetDate:(NSDate *)target{
    NSUInteger having = [[self selectTargetDataWith:target]count];
    if(having){
        [self updateRowWithDate:target andUpdateDate:text];
    }else{
        NSString * insertQuery = [self prepareInsertDinnerTableQueryWithText:text withDate:target];
        [connection insert:[connection getdbPath]andWithInsert:^int(sqlite3 *sqlDb, char *err ,sqlite3_stmt* stmt) {
            return sqlite3_exec(sqlDb, [insertQuery UTF8String] ,NULL,NULL,&err);
        }];

        
    }
    return NO;
}

-(void)updateRowWithDate:(NSDate*)targetDate andUpdateDate:(NSString *)text{
    
    NSString * updateQuery = [NSString stringWithFormat:@"UPDATE dinner SET dayText = \"%@\" , numberOfImage = %d,numberOfCheckBox = %d WHERE dayStr = \"%@\"",text,1,1,[DinnerUtility DateToString:targetDate]];
    [connection update:[connection getdbPath] withName:text andTargetQuery:updateQuery];

}

-(NSArray *)selectTargetDataWith:(NSDate *)target{
    NSString  * query =[NSString stringWithFormat: @"SELECT * from dinner WHERE dayStr = \"%@\"" , [DinnerUtility DateToString:target]];
    NSMutableArray * result = [NSMutableArray new];
    
    [connection getRecords:[connection getdbPath] where:query callbackBlock:^(sqlite3_stmt *stmt) {
        
        NSString * dayStr =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
        NSString * dayText =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
        NSInteger numberOfImage =  sqlite3_column_int(stmt, 2);
        NSInteger numberOfCheckBox =  sqlite3_column_int(stmt, 3);
        NSDictionary *student =[NSDictionary dictionaryWithObjectsAndKeys:dayStr,@"dayStr",
                                dayText,@"dayText",
                                [NSNumber numberWithInteger:numberOfImage], @"numberOfImage",
                                [NSNumber numberWithInteger:numberOfCheckBox], @"numberOfCheckBox", nil];
        
        [result addObject:student];
    }];
    return result;
}

-(NSString *)prepareInsertDinnerTableQueryWithText:(NSString *)text withDate:(NSDate *)date{
    NSString * returnString = [NSString stringWithFormat:@"INSERT INTO dinner (dayStr,dayText,numberOfImage,numberOfCheckBox) VALUES (\"%@\",\"%@\",%d,%d)",[DinnerUtility DateToString:date], text , 10,10];
    
    NSLog(@"return STring : %@" , returnString);
    
    return returnString;

}

-(void)deleteRowWithData:(NSDate *)targetDate{
    
}
@end
