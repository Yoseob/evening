//
//  DinnerUtility.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 21..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "DinnerUtility.h"
#import "CheckBox.h"

@implementation DinnerUtility
+(DinnerUtility *) defualtDinnerUtility{
    static DinnerUtility * dinner = nil;
    if(!dinner){
        dinner = [[DinnerUtility alloc]init];

    }
    
    return dinner;
}

+(UIColor *)mainbackgroundColor{
    return  [UIColor colorWithRed:242/255.f green:242/255.f blue:242/255.f alpha:1.f];;
}

+(int)DateToInterval:(NSDate *)date{
    return [date timeIntervalSince1970];
}

+(NSString *)DateToString:(NSDate *)date{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return [dateFormatter stringFromDate:date];
}
+(NSDate*)StringToDate:(NSString*)day{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    return [formatter dateFromString:day];

}
+(UIColor *)DinnerNaviBarColor{
    return [UIColor colorWithRed:38/255.f green:38/255.f blue:38/255.f alpha:1.f];
}

+(UIColor *)CalendarBackgroundColor{
    return [UIColor colorWithRed:242/255.f green:242/255.f blue:242/255.f alpha:1.f];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/*
 NSMutableAttributedString *myAttrString = [[NSMutableAttributedString alloc]initWithAttributedString:self.currentDayTextView.attributedText];
 [checkBoxs removeAllObjects];
 [dbManager getImageInTheAttributeString:myAttrString cacheArr:checkBoxs Day:date];
 
 [myAttrString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, myAttrString.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
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
 
 if(image.size.width < 50){
 NSString * key = [NSString stringWithFormat:@"%ld",range.location];
 CheckBox * check = checkBoxs[key];
 NSTextAttachment * newAttrText;
 newAttrText = [NSTextAttachment new];
 newAttrText.image = checkBoxImages[check.status];
 newAttrText.image = [UIImage imageWithCGImage:newAttrText.image.CGImage scale:2.f orientation:UIImageOrientationUp];
 [myAttrString replaceCharactersInRange:range withAttributedString:[NSAttributedString attributedStringWithAttachment:newAttrText]];
 [myAttrString addAttribute:(__bridge NSString *)kCTSuperscriptAttributeName value:@(-1) range:range];
 }
 }
 }];

 
 */

+(NSMutableAttributedString *)attributeTextResizeStable:(NSAttributedString *)attributedText withContainer:(UIScrollView *)scview{
    
    NSMutableAttributedString * newattributedText = [[NSMutableAttributedString alloc]initWithAttributedString:attributedText];
    [newattributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, newattributedText.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
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
                NSTextAttachment *newAttrText = [NSTextAttachment new];
                CGFloat oldWidth = image.size.width;
                CGFloat  scaleFactor = oldWidth / (scview.frame.size.width - 10);
                newAttrText.image = [UIImage imageWithData:UIImagePNGRepresentation(image) scale:scaleFactor];
                [newattributedText replaceCharactersInRange:range withAttributedString:[NSAttributedString attributedStringWithAttachment:newAttrText]];
            }else if (image.size.height == 2.0f){
                NSTextAttachment *newAttrText = [NSTextAttachment new];
                
                UIImageView * lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, image.size.width/2 , 1)];
                lineImage.backgroundColor = [DinnerUtility mainbackgroundColor];
                
                UIGraphicsBeginImageContextWithOptions(lineImage.bounds.size, lineImage.opaque, 0.0);
                [lineImage.layer renderInContext:UIGraphicsGetCurrentContext()];
                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();

                newAttrText.image = image;
                [newattributedText replaceCharactersInRange:range withAttributedString:[NSAttributedString attributedStringWithAttachment:newAttrText]];

            }
        }
        
    }];
    
    return  newattributedText;
}
+(NSMutableAttributedString *)attributeTextResizeStable:(NSAttributedString *)attributedText withContainer:(UIScrollView *)scview andCheckBox:(NSDictionary *)checkBoxs{
    
    NSArray * checkBoxImages = @[[UIImage imageNamed:@"checkbox_todo"] , [UIImage imageNamed:@"checkbox_did"]];
    
    NSMutableAttributedString * myAttrString = [[NSMutableAttributedString alloc]initWithAttributedString:attributedText];
    
    [myAttrString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, myAttrString.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
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
            
            if(image.size.width < 50){
                NSString * key = [NSString stringWithFormat:@"%ld",range.location];
                CheckBox * check = checkBoxs[key];
                NSTextAttachment * newAttrText;
                newAttrText = [NSTextAttachment new];
                newAttrText.image = checkBoxImages[check.status];
                newAttrText.image = [UIImage imageWithCGImage:newAttrText.image.CGImage scale:2.f orientation:UIImageOrientationUp];
                [myAttrString replaceCharactersInRange:range withAttributedString:[NSAttributedString attributedStringWithAttachment:newAttrText]];
                [myAttrString addAttribute:(__bridge NSString *)kCTSuperscriptAttributeName value:@(-1) range:range];
            }else{
                NSTextAttachment *newAttrText = [NSTextAttachment new];
                CGFloat oldWidth = image.size.width;
                CGFloat  scaleFactor = oldWidth / (scview.frame.size.width - 10);
                newAttrText.image = [UIImage imageWithData:UIImagePNGRepresentation(image) scale:scaleFactor];
                
                
                [myAttrString replaceCharactersInRange:range withAttributedString:[NSAttributedString attributedStringWithAttachment:newAttrText]];
            }
        }
    }];
    return myAttrString;
    
    
}


+(NSAttributedString *)modifyAttributedString:(NSAttributedString *)originString{
    NSMutableAttributedString * attriString = [[NSMutableAttributedString alloc]initWithAttributedString:originString];
    [attriString enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, attriString.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop){
        
        NSDictionary * attDic = [attriString attributesAtIndex:range.location effectiveRange:&range];
        //If attrDic has NSOriginalFont, it is text
        if(attDic[@"NSFont"]){
            if (value) {
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = 2;
                NSDictionary *dict = @{NSParagraphStyleAttributeName : paragraphStyle };
                [attriString addAttributes:dict range:range];
//                
//                UIFont *oldFont = (UIFont *)value;
//                UIFont *newFont = [oldFont fontWithSize:oldFont.pointSize];
//                [attriString removeAttribute:NSFontAttributeName range:range];
//                [attriString addAttribute:NSFontAttributeName value:newFont range:range];
                
//                [attriString addAttribute:(__bridge NSString *)kCTSuperscriptAttributeName value:@(1) range:range];
            }
        }
    }];
    
    return attriString;

}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}



@end
