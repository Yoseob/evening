//
//  CheckBoxsDao.h
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 22..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "DataBaseAccessObject.h"
#import "CheckBox.h"
@interface CheckBoxsDao : DataBaseAccessObject
+(id)getDefaultCheckBoxsDao;

-(BOOL)insertDataWithCB:(CheckBox * )cb;
-(void)updateRowWithCheckBox:(CheckBox *)cb;

-(NSArray *)selectTargetDataWith:(NSDate *)target withQeury:(NSString *)query;
-(void)deleteRowWithCB:(CheckBox *)cb;
@end
