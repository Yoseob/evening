//
//  CheckBoxsDao.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 22..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "CheckBoxsDao.h"

@implementation CheckBoxsDao


+(id)getDefaultCheckBoxsDao{
    static CheckBoxsDao * dao = nil;
    if(!dao){
        dao = [[CheckBoxsDao alloc]init];
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
    NSString * createCheckBocTablequery = @"CREATE TABLE IF NOT EXISTS checkboxs ( id INTEGER PRIMARY KEY AUTOINCREMENT ,location INTEGER  , status INTEGER ,ownerDay TEXT )";
    [connection createTable:[connection getdbPath] andCreateQuery:createCheckBocTablequery];
}
-(BOOL)insertDataWithCB:(CheckBox * )cb{
    
    NSString * insertQuery = [self prepareInsertDinnerTableQueryWithText:nil withDate:cb.date location:cb.location status:cb.status];
    [connection insert:[connection getdbPath]andWithInsert:^int(sqlite3 *sqlDb, char *err, sqlite3_stmt* stmt) {
        NSString * dateStr =[DinnerUtility DateToString:cb.date];
        int ret = 0;
        
        
        if( sqlite3_prepare_v2(sqlDb, [insertQuery UTF8String], -1, &stmt, NULL)==SQLITE_OK){
            
            sqlite3_bind_int(stmt, 1, (int)cb.location);
            sqlite3_bind_int(stmt, 2, (int)cb.status);
            sqlite3_bind_text(stmt, 3, [dateStr UTF8String], -1, SQLITE_TRANSIENT);
            if (sqlite3_step(stmt) == SQLITE_DONE){}
            
            ret =  sqlite3_finalize(stmt);
        }else{
            NSLog(@"fuck");
        }
        
        return  ret;
    }];
    
    
    return nil;

}



-(NSArray *)selectTargetDataWith:(NSDate *)target withQeury:(NSString *)query{

    NSLog(@"selectTargetDataWith");
    NSMutableArray * result = [NSMutableArray new];
    [connection getRecords:[connection getdbPath] where:query callbackBlock:^(sqlite3_stmt *stmt) {
        int location = sqlite3_column_int(stmt, 1);
        int status =  sqlite3_column_int(stmt, 2);
//        NSString * dayStr =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
        CheckBox * checkBox = [[CheckBox alloc]initWithLoc:location andStatus:status];
        [result addObject:checkBox];
    }];

    return result;
}

-(void)updateRowWithCheckBox:(CheckBox *)cb{
    NSString * updateQuery = [NSString stringWithFormat:@"UPDATE checkboxs SET status = ? WHERE ownerDay = ? AND location = ?"];
    NSLog(@"%@" ,updateQuery);
    [connection update:[connection getdbPath] updateStmt:^int(sqlite3 *sqlDb, char *err, sqlite3_stmt *stmt) {
        int ret = 0;
        if( sqlite3_prepare_v2(sqlDb, [updateQuery UTF8String], -1, &stmt, NULL)==SQLITE_OK){
            sqlite3_bind_int(stmt, 1, (int)cb.location);
            sqlite3_bind_int(stmt, 2, (int)cb.status);
            sqlite3_bind_text(stmt, 3, [[DinnerUtility DateToString:cb.date] UTF8String], -1, SQLITE_TRANSIENT);
            if (sqlite3_step(stmt) == SQLITE_DONE){}
            
            ret =  sqlite3_finalize(stmt);
        }else{
            NSLog(@"fuck");
        }
        
        return  ret;
    }];;
}
-(void)deleteRowWithCB:(CheckBox *)cb{
    NSString * query  = [NSString
                         stringWithFormat:@"DELETE FROM checkboxs where ownerDay =\"%@\" AND location = %ld",[DinnerUtility DateToString:cb.date] , cb.location];
    [connection deleteRow:[connection getdbPath] withQuery:query];
    
}
-(void)deleteRowWithData:(NSDate*)targetDate{
    NSString * query  = [NSString
                         stringWithFormat:@"DELETE FROM checkboxs where ownerDay = ?"];

    [connection deleteRow:[connection getdbPath] withQuery:nil withCallback:^int(sqlite3 *sqlDb, char *err, sqlite3_stmt *stmt) {
        int ret = 0;
        if( sqlite3_prepare_v2(sqlDb, [query UTF8String], -1, &stmt, NULL)==SQLITE_OK){
            sqlite3_bind_text(stmt, 1, [[DinnerUtility DateToString:targetDate] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(stmt);
            ret = sqlite3_finalize(stmt);
        }else{
            
        }
        return  ret;
        
    }];
    

    

}

-(NSString *)prepareInsertDinnerTableQueryWithText:(NSString *)imageDate withDate:(NSDate *)date location:(NSInteger)loc status:(NSInteger)stmt{
    

    NSString * returnString = [NSString stringWithFormat:@"INSERT INTO checkboxs (location,status,ownerDay) VALUES (?,?,?)"];
    
    NSLog(@"return String : %@" , returnString);
    
    return returnString;

}


@end
