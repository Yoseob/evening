//
//  DataBaseAccessObject.h
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 22..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqlConnection.h"
#import "DinnerUtility.h"

@interface DataBaseAccessObject : NSObject{
       SqlConnection * connection;
}
-(void)createDataBase;
-(BOOL)insertDataWithString:(NSString * )text targetDate:(NSDate *)target;
-(NSArray *)selectTargetDataWith:(NSDate *)target;
-(void)updateRowWithDate:(NSDate*)targetDate andUpdateDate:(NSString *)text;
-(void)deleteRowWithData:(NSDate*)targetDate;
-(NSString *)prepareInsertDinnerTableQueryWithText:(NSString *)text withDate:(NSDate *)date;

@end
