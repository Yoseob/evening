
//
//  DinnerObjDao.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 25..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "DinnerObjDao.h"

@implementation DinnerObjDao

+(id)getDefaultDinnerObjDao{
    static DinnerObjDao * obj = nil;
    if(obj == nil){
        obj = [[DinnerObjDao alloc]init];
    }
    
    return obj;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)createDataBase{
    [connection createTable:[connection getdbPath] andCreateQuery:@"CREATE TABLE IF NOT EXISTS dinnerobj ( id INTEGER PRIMARY KEY AUTOINCREMENT, dayStr TEXT, dayText TEXT, dayTextData BLOB )"];
}

-(BOOL)insertDataWithString:(NSString *)text attribute:(NSData*)textData targetDate:(NSDate *)target{
    NSUInteger having = [[self selectTargetDataWith:target]count];
    NSLog(@"insert state");
    if(having){
        NSLog(@"having state");
        [self updateRowWithDate:target andUpdateDate:text attrData:textData];
    }else{
        NSLog(@"new state");
        [self deleteRowWithData:target];
        NSString * insertQuery = [self prepareInsertDinnerTableQueryWithText:text attributeData:textData withDate:target];
        [connection insert:[connection getdbPath]andWithInsert:^int(sqlite3 *sqlDb, char *err ,sqlite3_stmt* stmt) {
            NSString * dateStr =[DinnerUtility DateToString:target];
            int ret = 0;
        
            if( sqlite3_prepare_v2(sqlDb, [insertQuery UTF8String], -1, &stmt, NULL)==SQLITE_OK){
                sqlite3_bind_text(stmt, 1, [dateStr UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(stmt, 2, [text UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_blob(stmt, 3, [textData bytes], (int)[textData length], SQLITE_TRANSIENT);
                
                if (sqlite3_step(stmt) == SQLITE_DONE) {}
                ret =  sqlite3_finalize(stmt);
            }else{
            }
            return  ret;
        }];
        
        
    }
    return NO;
}

-(void)updateRowWithDate:(NSDate*)targetDate andUpdateDate:(NSString *)text attrData:(NSData *)data{
    
    NSString * updateQuery = [NSString stringWithFormat:@"UPDATE dinnerobj SET dayText = ? , dayTextData = ? WHERE dayStr = \"%@\"",[DinnerUtility DateToString:targetDate]];

    [connection update:[connection getdbPath] updateStmt:^int(sqlite3 *sqlDb, char *err, sqlite3_stmt *stmt) {
        int ret = 0;
    
        if( sqlite3_prepare_v2(sqlDb, [updateQuery UTF8String], -1, &stmt, NULL)==SQLITE_OK){
            sqlite3_bind_text(stmt, 1, [text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_blob(stmt, 2, [data bytes], (int)[data length], SQLITE_TRANSIENT);
            if (sqlite3_step(stmt) == SQLITE_DONE) {}
            ret =  sqlite3_finalize(stmt);
        }else{

        }
        return  ret;
    }];
}


#pragma mark - select
-(NSArray *)selectDataWithQuery:(NSString *)query{
    return [self selectImpl:query];
}
-(NSArray *)selectDayWith:(NSDate *)target{
    NSString  * query =[NSString stringWithFormat: @"SELECT * from dinnerobj WHERE dayStr = \"%@\" ORDER BY dayStr ASC" , [DinnerUtility DateToString:target]];
    return [self selectImpl:query];
}

-(NSArray *)selectAllDataWith:(NSDate *)target{
    NSString * query =[NSString stringWithFormat: @"SELECT * from dinnerobj ORDER BY dayStr ASC"];
    return [self selectImpl:query];
}



-(NSMutableArray *)selectImpl:(NSString*)query{
    NSMutableArray * result = [NSMutableArray new];
    [self selectQueryImpliment:query withCompliteCallback:^(sqlite3_stmt *stmt) {
        DinnerDay * dinner = [[DinnerDay alloc]init];
        dinner.index = sqlite3_column_int(stmt, 0);
        dinner.dayStr =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
        dinner.orignText =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
        int length = sqlite3_column_bytes(stmt, 3);
        NSData * data = [NSData dataWithBytes:sqlite3_column_blob(stmt, 3) length:length];
        [dinner setAttrData:data];
        [result addObject:dinner];
    }];
    return result;
}

-(void)selectQueryImpliment:(NSString *) query withCompliteCallback:(Callback)callback{
    [connection getRecords:[connection getdbPath] where:query callbackBlock:callback];
}

-(NSString *)prepareInsertDinnerTableQueryWithText:(NSString *)text attributeData:(NSData * )data withDate:(NSDate *)date{
    NSString * returnString = [NSString stringWithFormat:@"INSERT INTO dinnerobj (dayStr,dayText,dayTextData) VALUES (?,?,?)"];
    NSLog(@"return STring : %@" , returnString);
    
    return returnString;
}

-(void)deleteRowWithData:(NSDate *)targetDate{
    NSString *removeKeyword =[NSString stringWithFormat:@"DELETE FROM dinnerobj WHERE dayStr = ?"];
    [connection deleteRow:[connection getdbPath] withQuery:removeKeyword withCallback:^int(sqlite3 *sqlDb, char *err, sqlite3_stmt *stmt) {
        int ret = 0;
        if( sqlite3_prepare_v2(sqlDb, [removeKeyword UTF8String], -1, &stmt, NULL)==SQLITE_OK){
            sqlite3_bind_text(stmt, 1, [[DinnerUtility DateToString:targetDate] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(stmt);
            ret = sqlite3_finalize(stmt);
        }else{
            
        }
        return  ret;
    }];
}


@end
