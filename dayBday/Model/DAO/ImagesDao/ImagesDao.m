//
//  ImagesDao.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 22..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "ImagesDao.h"

@implementation ImagesDao

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


+(id)getDefaultImagesDao{
    static ImagesDao * dao = nil;
    if(!dao){
        dao = [[ImagesDao alloc]init];
    }
    return dao;
}

-(void)createDataBase{
    NSString * createImageTablequery = @"CREATE TABLE IF NOT EXISTS data (id INTEGER PRIMARY KEY AUTOINCREMENT, obj BLOB , ownerDay TEXT ,FOREIGN KEY (ownerDay) REFERENCES dinner (dayStr) )";
//    NSString * createImageTablequery = @"CREATE TABLE IF NOT EXISTS images (id INTEGER PRIMARY KEY AUTOINCREMENT, image BLOB, imageName TEXT,location INTEGER ,ownerDay TEXT ,FOREIGN KEY (ownerDay) REFERENCES dinner (dayStr) )";
    
    [connection createTable:[connection getdbPath] andCreateQuery:createImageTablequery];
    
}

-(BOOL)insertDataWithString:(NSData *)dt targetDate:(NSDate *)target{
    NSString * insertQuery = [self prepareInsertDinnerTableQueryWithData:dt];
    [connection insert:[connection getdbPath]andWithInsert:^int(sqlite3 *sqlDb, char *err, sqlite3_stmt* stmt) {
        NSString * dateStr =[DinnerUtility DateToString:target];
        int ret = 0;
        
        
        if( sqlite3_prepare_v2(sqlDb, [insertQuery UTF8String], -1, &stmt, NULL)==SQLITE_OK){
            
            sqlite3_bind_blob(stmt, 1, [dt bytes], [dt length], SQLITE_TRANSIENT);
            sqlite3_bind_text(stmt, 2, [dateStr UTF8String], -1, SQLITE_TRANSIENT);
            
            if (sqlite3_step(stmt) == SQLITE_DONE) {}
            ret =  sqlite3_finalize(stmt);
        }else{
            NSLog(@"fuck");
        }

        return  ret;
    }];
    

    return false;
}

-(void)updateRowWithDate:(NSDate*)targetDate andUpdateDate:(NSString *)text{
    
}

-(NSArray *)selectTargetDataWith:(NSDate *)target{
    NSString  * query =[NSString stringWithFormat: @"SELECT * from data WHERE ownerDay = \"%@\"" , [DinnerUtility DateToString:target]];
    NSMutableArray * result = [NSMutableArray new];

    [connection getRecords:[connection getdbPath] where:query callbackBlock:^(sqlite3_stmt *stmt) {
        
        
        //         checkBox BLOB, location INTEGER, status INTEGER ,ownerDay TEXT
        int length = sqlite3_column_bytes(stmt, 1);
        NSData * data = [NSData dataWithBytes:sqlite3_column_blob(stmt, 1) length:length];

        [result addObject:data];
    }];

    return result;
}

-(NSString *)prepareInsertDinnerTableQueryWithText:(NSString *)text withDate:(NSDate *)date{
    return nil;
}
-(void)deleteRowWithData:(NSDate*)targetDate{
    
}

-(NSString *)prepareInsertDinnerTableQueryWithData:(NSData *)data{

    NSString * returnString = [NSString stringWithFormat:@"INSERT INTO data (obj,ownerDay) VALUES (?,?)"];
    
    NSLog(@"return String : %@" , returnString);
    
    return returnString;
    
}



@end
