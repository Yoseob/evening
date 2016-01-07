//
//  DinnerUtility.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 21..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "DinnerUtility.h"

@implementation DinnerUtility

+(DinnerUtility *) defualtDinnerUtility{
    static DinnerUtility * dinner = nil;
    if(!dinner){
        dinner = [[DinnerUtility alloc]init];
    }
    
    return dinner;
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
            
            if(image.size.width > 50){
                NSTextAttachment *newAttrText = [NSTextAttachment new];
                CGFloat oldWidth = image.size.width;
                NSLog(@"oldWidth %lf", oldWidth);
                CGFloat  scaleFactor = oldWidth / (scview.frame.size.width - 10);
                newAttrText.image = [UIImage imageWithData:UIImagePNGRepresentation(image) scale:scaleFactor];
                
                
                [newattributedText replaceCharactersInRange:range withAttributedString:[NSAttributedString attributedStringWithAttachment:newAttrText]];
            }
        }
        
    }];
    
    return  newattributedText;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}



@end
