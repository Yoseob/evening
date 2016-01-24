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
    
    DinnerDay * headerDinner;
    DinnerDay * tailDinner;
    DinnerDay * hCursor , * tCursor;
    DinnerObjDao * dao;
    ThumbnailDao * tDao;
    CheckBoxsDao * cDao;
    NSMutableDictionary * innerdinnerDataArchive;

}
@synthesize thumbNailDataArchive; //썸네일 보관
@synthesize dinnerDataArchive; // 디너 정보들 보관
@synthesize dinnerWithViewTable; // textView / container 보관
@synthesize calendarDayViewArchive; // 켈린더 뷰들 보관


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
        calendarDayViewArchive = [NSMutableDictionary new];
        innerdinnerDataArchive = [NSMutableDictionary new];
        dao = [DinnerObjDao getDefaultDinnerObjDao];
        tDao =[ThumbnailDao getDefaultThumbnailDao];
        cDao = [CheckBoxsDao getDefaultCheckBoxsDao];
        [tDao createDataBase];
        [dao createDataBase];
        [cDao createDataBase];
        
    }
    return  self;
}

-(DinnerDay *) searchDataWithData:(NSDate *)day{
    
    return [self serchAtList:[DinnerUtility DateToString:day]];
    
    
    DinnerDay * retDinner= ([innerdinnerDataArchive objectForKey:[DinnerUtility DateToString:day]]);
    if(!retDinner){
        NSArray * result = [dao selectDayWith:day];
        retDinner = result.firstObject;
    }
    return retDinner;
}

-(void)achiveDinnerAtInnderDictionany:(DinnerDay*)dinner{
    [innerdinnerDataArchive setObject:dinner forKey:dinner.dayStr];
    [self insertAtAfterSourceDinner:dinner];
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

-(DinnerDay *)insertTextViewDataWith:(UITextView *)textView cachedCheckBox:(NSDictionary *)checkBoxs data:(NSDate *)date{
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc]initWithAttributedString:textView.attributedText];
    NSData* stringData = [NSKeyedArchiver archivedDataWithRootObject:attrString];
    
    DinnerDay * dinner = [DinnerDay new];
    dinner.attrData = stringData;
    dinner.attrText = attrString;
    dinner.dayStr = [DinnerUtility DateToString:date];
    [innerdinnerDataArchive setObject:dinner forKey:dinner.dayStr];
    [self insertAtAfterSourceDinner:dinner];
    
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
                    Thumbnail * thumb = [[Thumbnail alloc]init];
                    thumb.image = image;
                    [thumbNailDataArchive setObject:thumb forKey:[DinnerUtility DateToString:date]];
                    [imageArr addObject:image];
                    *stop = YES;
                }
            }
        }];
        
        if(imageArr.count == 0){
            [tDao removeThumbnailWith:date];
        }
    }
    
    return dinner;
}

-(void)removeThisDayEvent:(NSDate *)day{
    [self.calendarDayViewArchive removeObjectForKey:[DinnerUtility DateToString:day]];
    
    //remove all memory;
    
    [tDao removeThumbnailWith:day];
    [dao deleteRowWithData:day];
    [cDao deleteRowWithData:day];
    
}

-(void)prepareAllOfDinnerData{
    NSLog(@"prepareAllOfDinnerData");
    dinnerDataArchive = [[NSMutableArray alloc]initWithArray:[dao selectAllDataWith:nil]];
    [self setheader:dinnerDataArchive.firstObject];
    [self setTail:dinnerDataArchive.lastObject];
    
    DinnerDay * temp = nil;
    int length = (int)dinnerDataArchive.count -1;
    for(int i = 1; i < length; i ++){
        temp = dinnerDataArchive[i];
        [self addHeadertDinnerAtList:temp];
        [innerdinnerDataArchive setObject:temp forKey:temp.dayStr];
        [self addTailDiinerAtList:dinnerDataArchive[length - i]];
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


#pragma mark - make linkedList

-(DinnerDay *)serchAtList:(NSString *)date{
    DinnerDay * temp = headerDinner;
    while (temp) {
        if([temp.dayStr isEqualToString:date]){
            return temp;
        }
        temp = temp.right;
    }
    
    return  nil;
}

-(int)intFromDateString:(NSString *)str{
    NSDate * dt = [DinnerUtility StringToDate:str];
    return [dt timeIntervalSince1970];
}

-(void)insertAtAfterSourceDinner:(DinnerDay *)src{

    int fivot = [self intFromDateString:src.dayStr];
    int cusor = 0;
    DinnerDay * temp = headerDinner;
    while (temp) {
        cusor = [self intFromDateString:temp.dayStr];
        if(cusor >= fivot){
            [self linkSrc:temp endDesc:src];
        }
        temp = temp.right;
    }
}

-(void)linkSrc:(DinnerDay *)old endDesc:(DinnerDay *)new{
    new.left = old.left;
    new.right = old;
    old.left = new;
}

-(void)addHeadertDinnerAtList:(DinnerDay *)dinner{
    dinner.right = hCursor.right;
    hCursor.right = dinner;
    hCursor = dinner;
}

-(void)addTailDiinerAtList:(DinnerDay *)dinner{
    dinner.left = tCursor.left;
    tCursor.left = dinner;
    tCursor = dinner;
}
-(void)setheader:(DinnerDay *)header{
    headerDinner = header;
    
    headerDinner.left = nil;
    headerDinner.right = dinnerDataArchive.lastObject;
    
    hCursor = headerDinner;
}
-(void)setTail:(DinnerDay *)tail{
    tailDinner = tail;
    
    tailDinner.right = nil;
    tailDinner.left = headerDinner;
    
    tCursor = tailDinner;
    
}



@end
