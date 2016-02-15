//
//  Thumbnail.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 12. 3..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "ThumbnailDao.h"

@implementation ThumbnailDao
+(id)getDefaultThumbnailDao{
    static ThumbnailDao * obj = nil;
    if(obj == nil){
        obj = [[ThumbnailDao alloc]init];
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

    [connection createTable:[connection getdbPath] andCreateQuery:@"CREATE TABLE IF NOT EXISTS thumbnail (dayText TEXT  PRIMARY KEY , day INTEGER , thumbimage BLOB)"];
}


-(void)inserThumbnail:(UIImage *)image withDate:(NSDate*)date{
    UIImage * resizedImage = [DinnerUtility imageWithImage:image scaledToSize:CGSizeMake(40, 40)];
    NSData *data = UIImageJPEGRepresentation(resizedImage, 0.4);
    NSString * dateStr =[DinnerUtility DateToString:date];
    if([self selectThumbnailWithDate:date].dayStr ==dateStr){
        [self updateThumbnailWith:date withThumbnail:data];
        return;
    }
    
    NSString * returnString = [NSString stringWithFormat:@"INSERT INTO thumbnail (day,dayText,thumbimage) VALUES (?,?,?)"];

    NSLog(@"%@",connection);
    [connection insert:[connection getdbPath]andWithInsert:^int(sqlite3 *sqlDb, char *err ,sqlite3_stmt* stmt) {
        int ret = 0;

        ret =sqlite3_prepare_v2(sqlDb, [returnString UTF8String], -1, &stmt, NULL);
        if(ret==SQLITE_OK){
            sqlite3_bind_int(stmt, 1, [date timeIntervalSince1970]);
            sqlite3_bind_text(stmt, 2, [dateStr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_blob(stmt, 3, [data bytes], [data length], SQLITE_TRANSIENT);
            if (sqlite3_step(stmt) == SQLITE_DONE) {}
            ret =  sqlite3_finalize(stmt);
        }else{
            NSLog(@"Failed to insert record  rc:%d, msg=%@",ret,[NSString stringWithCString:err encoding:NSUTF8StringEncoding]);
        }
        
        return  ret;
    }];
 
}


-(Thumbnail *)selectThumbnailWithDate:(NSDate *)target{
    
    NSMutableArray * arr;
    NSString  * query =[NSString stringWithFormat: @"SELECT * from thumbnail WHERE dayText = \"%@\"" , [DinnerUtility DateToString:target]];
    arr =[self selectImplimentWithQeury:query withCallback:nil];

    return arr.firstObject;
}
-(NSArray *)selectThumbnailsOfMonthWithDate:(NSDate *)target{
    NSMutableArray * arr;
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
        [dateFormatter setDateFormat:@"yyyy-MM-"];
    }
    NSString * dayText=[dateFormatter stringFromDate:target];

    NSString  * query =[NSString stringWithFormat: @"SELECT * from thumbnail WHERE dayText = \"%@%%\"" , dayText];
    arr = [self selectImplimentWithQeury:query withCallback:nil];
    return  arr;
}
-(NSMutableDictionary *)selectThumbnails{
//dayText TEXT  PRIMARY KEY , day INTEGER , thumbimage BLOB
    NSMutableDictionary * dic = [NSMutableDictionary new];
    NSString  * query =[NSString stringWithFormat: @"SELECT * from thumbnail"];
    [self selectImplimentWithQeury:query withCallback:^(sqlite3_stmt *stmt) {
        NSString * dayText =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
        int day = sqlite3_column_int(stmt,1);
        int length = sqlite3_column_bytes(stmt, 2);
        NSData * data = [NSData dataWithBytes:sqlite3_column_blob(stmt, 2) length:length];
        Thumbnail * thumbnal = [Thumbnail initWithInterval:day imageDate:data dayStr:dayText];
        dic[dayText] =thumbnal;
    }];
    return  dic;
}

-(id)selectImplimentWithQeury:(NSString *)query withCallback:(Callback)callback{
    NSMutableArray * arr = [NSMutableArray new];
    if(callback == nil){
        callback =^(sqlite3_stmt *stmt) {
            
            int day = sqlite3_column_int(stmt,1);
            NSString * dayText =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            int length = sqlite3_column_bytes(stmt, 3);
            NSData * data = [NSData dataWithBytes:sqlite3_column_blob(stmt, 3) length:length];
            Thumbnail * thumbnal = [Thumbnail initWithInterval:day imageDate:data dayStr:dayText];
            NSLog(@"%lf",thumbnal.image.size.width);
            
            [arr addObject:thumbnal];
        };
    }
    [connection getRecords:[connection getdbPath] where:query callbackBlock:callback];
    return arr;
}

-(void)removeThumbnailWith:(NSDate *)date{
    NSString *removeKeyword =[NSString stringWithFormat:@"DELETE FROM thumbnail WHERE dayText = ?"];
    [connection deleteRow:[connection getdbPath] withQuery:nil withCallback:^int(sqlite3 *sqlDb, char *err, sqlite3_stmt *stmt) {
        int ret = 0;
        if( sqlite3_prepare_v2(sqlDb, [removeKeyword UTF8String], -1, &stmt, NULL)==SQLITE_OK){
            sqlite3_bind_text(stmt, 1, [[DinnerUtility DateToString:date] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(stmt);
            ret = sqlite3_finalize(stmt);
        }else{
            
        }
        
        return  ret;

    }];

    
}
-(void)updateThumbnailWith:(NSDate *)date withThumbnail:(NSData*)data{
    NSString * updateQuery = [NSString stringWithFormat:@"UPDATE thumbnail SET thumbimage = ? WHERE dayText = \"%@\"",[DinnerUtility DateToString:date]];

    [connection update:[connection getdbPath] updateStmt:^int(sqlite3 *sqlDb, char *err, sqlite3_stmt *stmt) {
        int ret = 0;
        if( sqlite3_prepare_v2(sqlDb, [updateQuery UTF8String], -1, &stmt, NULL)==SQLITE_OK){
            sqlite3_bind_blob(stmt, 0, [data bytes], [data length], SQLITE_TRANSIENT);
            if (sqlite3_step(stmt) == SQLITE_DONE) {}
            ret =  sqlite3_finalize(stmt);
        }else{
            
        }
        
        return  ret;
    }];

}

@end
