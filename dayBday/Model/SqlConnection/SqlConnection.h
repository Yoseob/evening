//
//  SqlConnection.h
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 21..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@class DinnerDay;

static NSString *dbName = @"v5.4.1.db.dinner.sqlite";
typedef void(^Callback)(sqlite3_stmt * stmt);
typedef void(^DinnerCallback)(DinnerDay * dinner , NSString* originQuery);
@interface SqlConnection : NSObject
@property (copy, nonatomic) NSString *givenFilename;
@property (copy, nonatomic) NSString *dbPath;


-(NSString *)getdbPath;
+(NSString *)staticDbPath;
-(id)initWithDataBaseFilename:(NSString*)databaseFilename;
-(int) createTable:(NSString*) filePath andCreateQuery:(NSString *)queryString;
-(int)insert:(NSString *)filePath andWithInsert:(int(^)(sqlite3 * sqlDb , char * err , sqlite3_stmt* stmt))block;
-(int)update:(NSString *)filePath withName:(NSString *)text andTargetQuery:(NSString *)query;
-(int)update:(NSString *)filePath updateStmt:(int(^)(sqlite3 * sqlDb , char * err , sqlite3_stmt* stmt))block;
-(int) deleteRow:(NSString*) filePath withQuery:(NSString*) query withCallback:(int(^)(sqlite3 * sqlDb , char * err , sqlite3_stmt* stmt))block;
-(int) deleteRow:(NSString*) filePath withQuery:(NSString*) query;
-(NSArray *) getRecords:(NSString*) filePath where:(NSString *)query callbackBlock:(void(^)(sqlite3_stmt * stmt))block;
@end
