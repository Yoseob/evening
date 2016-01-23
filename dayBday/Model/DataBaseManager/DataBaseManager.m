//
//  DataBaseManager.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 29..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "DataBaseManager.h"
#import "DinnerUtility.h"
#import "CheckBoxsDao.h"

@implementation DataBaseManager
{
    DinnerObjDao * dao;
    ThumbnailDao * tDao;
    CheckBoxsDao * cDao;
    NSMutableDictionary * innerdinnerDataArchive;

}
@synthesize thumbNailDataArchive;
@synthesize dinnerDataArchive;
@synthesize dinnerWithViewTable;
@synthesize dinnerViewArchive;


+(id)getDefaultDataBaseManager{
    static DataBaseManager * obj = nil;
    if(obj == nil){
        obj = [[DataBaseManager alloc]init];
    }
    return obj;
}

-(instancetype)init{
    self = [super init];
    if(self){
        dinnerWithViewTable = [NSMutableDictionary new];
        dinnerViewArchive = [NSMutableDictionary new];
        dao = [DinnerObjDao getDefaultDinnerObjDao];
        tDao =[ThumbnailDao getDefaultThumbnailDao];
        cDao = [CheckBoxsDao getDefaultCheckBoxsDao];
        [tDao createDataBase];
        [dao createDataBase];
        [cDao createDataBase];
        
    }
    return  self;
}
-(NSAttributedString *) searchDataWithData:(NSDate *)day{
    NSAttributedString *myAttrString= nil;
    myAttrString = ((DinnerDay *) [innerdinnerDataArchive objectForKey:[DinnerUtility DateToString:day]]).attrText;
    if(myAttrString){
        NSLog(@"searchDataWithData");
        return myAttrString;
    }
    
    
    NSArray * result = [dao selectDayTextDataWith:day];
    if(result.count > 0){
        for(NSData *data in result){
            myAttrString = [NSKeyedUnarchiver unarchiveObjectWithData: data];
        }
    }
    return myAttrString;
}

-(void)getImageInTheAttributeString:(NSAttributedString *)attrStr cacheArr:(NSMutableDictionary *)checkBoxs Day:(NSDate *)day{
    if(attrStr){
        [attrStr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attrStr.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            NSTextAttachment *  textAttachment = value;
            if(textAttachment){
                int loc = (int)range.location;
                NSString  * query =[NSString stringWithFormat: @"SELECT * from checkboxs WHERE ownerDay = \"%@\" AND location = %d" , [DinnerUtility DateToString:day],loc];
                CheckBox * temp = [[CheckBoxsDao getDefaultCheckBoxsDao]selectTargetDataWith:day withQeury:query].lastObject;
                NSString * key = [NSString stringWithFormat:@"%ld",temp.location];
                NSLog(@"%@",temp);
                if(temp)[checkBoxs setObject:temp forKey:key];
            }
        }];
    }
}

-(void)insertTextViewDataWith:(UITextView *)textView cachedCheckBox:(NSDictionary *)checkBoxs data:(NSDate *)date{
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc]initWithAttributedString:textView.attributedText];
    NSData* stringData = [NSKeyedArchiver archivedDataWithRootObject:attrString];

    [dao insertDataWithString:textView.text attribute:stringData targetDate:date];
    [[CheckBoxsDao getDefaultCheckBoxsDao]deleteRowWithData:date];
    
    [attrString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attrString.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        NSTextAttachment *  textAttachment = value;
        if(textAttachment){
            NSString * oldKey = [NSString stringWithFormat:@"%ld",range.location];
            CheckBox * obj = checkBoxs[oldKey];
            if(obj){
                NSLog(@"%ld, %@",obj.location , checkBoxs);
                [[CheckBoxsDao getDefaultCheckBoxsDao]insertDataWithCB:obj];
            }
        }
    }];
    
    
    NSMutableArray * imageArr = [NSMutableArray new];
    if(attrString.length > 0){
        [attrString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attrString.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            NSTextAttachment *  textAttachment = value;
            UIImage * image = nil;
            if(textAttachment){
                if ([textAttachment image]){
                    image = [textAttachment image];
                }else{
                    image = [textAttachment imageForBounds:[textAttachment bounds]
                                              textContainer:nil
                                             characterIndex:range.location];
                }
            
                if(image.size.width > 50){
                    [tDao inserThumbnail:image withDate:date];
                    [imageArr addObject:image];
                    *stop = YES;
                }
            }
        }];
        
        if(imageArr.count == 0){
            [tDao removeThumbnailWith:date];
        }
    }
}

-(void)removeThisDayEvent:(NSDate *)day{
    [self.dinnerViewArchive removeObjectForKey:[DinnerUtility DateToString:day]];
    
    [tDao removeThumbnailWith:day];
    [dao deleteRowWithData:day];
    [cDao deleteRowWithData:day];
    
}

-(void)prepareAllOfDinnerData{
    NSLog(@"prepareAllOfDinnerData");
    dinnerDataArchive = [[NSMutableArray alloc]initWithArray:[dao selectAllDataWith:nil]];
    thumbNailDataArchive = [tDao selectThumbnails];
    for (DinnerDay * dinner in dinnerDataArchive) {
        [innerdinnerDataArchive setObject:dinner forKey:dinner.dayStr];
    }
}
-(NSArray *)getDinnerData{
    return dinnerDataArchive;
}

#pragma makr - Thumbnail
-(Thumbnail *)thumbNailWith:(NSDate *)day{
    NSString * key = [DinnerUtility DateToString:day];
    return [thumbNailDataArchive objectForKey:key];
}

-(NSMutableDictionary *)reloadCachedData{
    [thumbNailDataArchive removeAllObjects];
    thumbNailDataArchive = [tDao selectThumbnails];
    return thumbNailDataArchive;
}
-(BOOL)isDateDinner:(NSString *)dayStr{
    return dinnerWithViewTable[dayStr] != nil;
}



@end
