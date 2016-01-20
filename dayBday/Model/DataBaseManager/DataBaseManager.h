//
//  DataBaseManager.h
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 29..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DinnerObjDao.h"
#import "CheckBox.h"
#import "CheckBoxsDao.h"
#import "ThumbnailDao.h"
@interface DataBaseManager : NSObject
@property (nonatomic,strong)NSMutableDictionary * thumbNailDataArchive ;
@property (nonatomic,strong)NSMutableArray *dinnerDataArchive;
@property (nonatomic,strong)NSMutableDictionary * dinnerWithViewTable ,*dinnerViewArchive;

//dinner
+(id)getDefaultDataBaseManager;
-(NSAttributedString *) searchDataWithData:(NSDate *)day;
-(void)getImageInTheAttributeString:(NSAttributedString*)attrStr cacheArr:(NSMutableDictionary *)checkBoxs Day:(NSDate * )day;
-(void)insertTextViewDataWith:(UITextView *)textView cachedCheckBox:(NSDictionary *)checkBoxs data:(NSDate *)date;
-(void)prepareAllOfDinnerData;
-(NSArray *)getDinnerData;
//thumb
-(Thumbnail *)thumbNailWith:(NSDate *)day;
-(NSMutableDictionary *)reloadCachedData;

//remove
-(void)removeThisDayEvent:(NSDate *)day;



-(BOOL)isDateDinner:(NSString*)dayStr;
@end
