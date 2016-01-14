//
//  SqlConnection.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 21..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "SqlConnection.h"

@implementation SqlConnection
@synthesize dbPath=_dbPath;

-(id)initWithDataBaseFilename:(NSString*)databaseFilename
{
    self = [super init];
    if(self){
        self.givenFilename = databaseFilename;
    }
    return self;
}

-(NSString *)getdbPath

{
    NSString * docsPath= NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
 
    return  _dbPath =[docsPath stringByAppendingPathComponent:@"v5.4.db.dinner.sqlite"];
}

-(int) createTable:(NSString*) filePath andCreateQuery:(NSString *)queryString
{
    sqlite3* db = NULL;
    int rc=0;
    
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {

        const char * query = [queryString UTF8String];
        char * errMsg;
        rc = sqlite3_exec(db, query,NULL,NULL,&errMsg);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s",rc,errMsg);
        }else if(SQLITE_OK == rc){
            NSLog(@"to create table rc:%d",rc);
        }
        
        sqlite3_close(db);
    }
    
    return rc;
    
}

-(int)insert:(NSString *)filePath andWithInsert:(int(^)(sqlite3 * sqlDb , char * err , sqlite3_stmt* stmt))block
{
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSLog(@"begin");
        char * errMsg;
        rc=block(db,errMsg,stmt);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    return rc;
}


-(NSArray *) getRecords:(NSString*) filePath where:(NSString *)query callbackBlock:(Callback)block
{
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                block(stmt);
            }

            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return nil;
    
}

-(int)update:(NSString *)filePath updateStmt:(int(^)(sqlite3 * sqlDb , char * err , sqlite3_stmt* stmt))block{
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSLog(@"update");
        char * errMsg;
        rc=block(db,errMsg,stmt);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to update record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    return rc;
}
-(int)update:(NSString *)filePath withName:(NSString *)text andTargetQuery:(NSString *)query{
    
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to update record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    
    return  rc;
}


-(int) deleteRow:(NSString*) filePath withQuery:(NSString*) query withCallback:(int(^)(sqlite3 * sqlDb , char * err , sqlite3_stmt* stmt))block{
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSLog(@"delete");
        char * errMsg;
        rc=block(db,errMsg,stmt);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to update record  rc:%d, msg=%s",rc,errMsg);
        }else{

        }
        sqlite3_close(db);
    }
    return rc;
}

-(int) deleteRow:(NSString*) filePath withQuery:(NSString*) query
{
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to delete record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    
    return  rc;
}
@end
