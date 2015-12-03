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

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}



@end
