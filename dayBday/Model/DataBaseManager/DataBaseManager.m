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
    return [self searchAtList:[DinnerUtility DateToString:day]];
}

-(void)achiveDinnerAtInnderDictionany:(DinnerDay*)dinner{
    [innerdinnerDataArchive setObject:dinner forKey:dinner.dayStr];

    [self insertAtAfterSourceDinner:dinner];

}

-(NSMutableAttributedString *)getImageInTheAttributeString:(NSAttributedString *)attrStr cacheArr:(NSMutableDictionary *)checkBoxs Day:(NSDate *)day{
    NSMutableAttributedString * myAttrString = [[NSMutableAttributedString alloc]initWithAttributedString:attrStr];
    if(myAttrString){
        [myAttrString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, myAttrString.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            NSTextAttachment *  textAttachment = value;
            if(textAttachment){
                int loc = (int)range.location;
                NSString  * query =[NSString stringWithFormat: @"SELECT * from checkboxs WHERE ownerDay = \"%@\" AND location = %d" , [DinnerUtility DateToString:day],loc];
                CheckBox * temp = [[CheckBoxsDao getDefaultCheckBoxsDao]selectTargetDataWith:day withQeury:query].lastObject;
                NSString * key = [NSString stringWithFormat:@"%ld",temp.location];
                
                if(temp){
                    NSString * imageName = temp.status == 0? @"checkbox_todo" : @"checkbox_did";
                    NSTextAttachment * newAttrText;
                    newAttrText = [NSTextAttachment new];
                    newAttrText.image = [UIImage imageNamed:imageName];
                    newAttrText.image = [UIImage imageWithCGImage:newAttrText.image.CGImage scale:2.f orientation:UIImageOrientationUp];
                    [myAttrString replaceCharactersInRange:range withAttributedString:[NSAttributedString attributedStringWithAttachment:newAttrText]];
                    [myAttrString addAttribute:(__bridge NSString *)kCTSuperscriptAttributeName value:@(-1) range:range];
                    {
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                        paragraphStyle.lineSpacing = 5;
                        NSDictionary *dict = @{NSParagraphStyleAttributeName : paragraphStyle };
                        [myAttrString addAttributes:dict range:range];
                        
                    }
                    [checkBoxs setObject:temp forKey:key];
                }
            }
        }];
    }
    return myAttrString;
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
            
                if(image.size.height > 50){
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
    return  dinner;
}

-(DinnerDay *)removeThisDayEvent:(NSDate *)day{
    
    [tDao removeThumbnailWith:day];
    [dao deleteRowWithData:day];
    [cDao deleteRowWithData:day];
    
    NSString * targetKey = [DinnerUtility DateToString:day];
    [calendarDayViewArchive removeObjectForKey:targetKey];
    [thumbNailDataArchive removeObjectForKey:targetKey];
    [innerdinnerDataArchive removeObjectForKey:targetKey];
    
    DinnerDay * newCnt = nil;
    
    for(DinnerDay * dinner in dinnerDataArchive){
        if([targetKey isEqualToString:dinner.dayStr]){
            newCnt = dinner.right;
            [self removeAtList:dinner];
            [dinnerDataArchive removeObject:dinner];
            return newCnt;
        }
    }


    return newCnt;
}

-(void)prepareAllOfDinnerData{
    NSLog(@"prepareAllOfDinnerData");
    dinnerDataArchive = [[NSMutableArray alloc]initWithArray:[dao selectAllDataWith:nil]];
    [self setheader:nil];
    DinnerDay * temp = nil;
    int length = (int)dinnerDataArchive.count ;
    for(int i = 0; i < length; i ++){
        temp = dinnerDataArchive[i];
        [self addHeadertDinnerAtList:temp];
        [innerdinnerDataArchive setObject:temp forKey:temp.dayStr];
        [self addTailDiinerAtList:dinnerDataArchive[length - i -1]];
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
    return (innerdinnerDataArchive[dayStr] != nil); //원래는 모든 텍스트가 한번에 했으니깐 있겟징
}


#pragma mark - make linkedList

-(DinnerDay *)searchAtList:(NSString *)date{
    DinnerDay * temp = headerDinner;
    while (temp) {
        if([temp.dayStr isEqualToString:date]){
            return temp;
        }
        temp = temp.right;
    }
    return  nil;
}

-(DinnerDay *)removeAtList:(DinnerDay *)dinner{
    DinnerDay * left = dinner.left;
    dinner =  dinner.right;
    left.right = dinner;
    dinner.left = left;
    return  dinner;
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
        if((fivot-cusor) < 0){
            [self linkSrc:temp endDesc:src];
            break;
        }
        temp = temp.right;
    }
}


//old 앞에 new를 삽입
-(void)linkSrc:(DinnerDay *)old endDesc:(DinnerDay *)new{
    DinnerDay * pre = old.left;
    pre.right = new;
    new.left = pre;
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
    headerDinner = [DinnerDay new];
    tailDinner = [DinnerDay new];
    
    headerDinner.left = nil;
    headerDinner.right = tailDinner;
    
    tailDinner.right = nil;
    tailDinner.left = headerDinner;
    
    hCursor = headerDinner;
    tCursor = tailDinner;
}




@end
