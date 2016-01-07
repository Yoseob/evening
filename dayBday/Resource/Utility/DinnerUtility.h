//
//  DinnerUtility.h
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 21..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DinnerUtility : NSObject

+(DinnerUtility *) defualtDinnerUtility;

+(int)DateToInterval:(NSDate *)date;

+(NSString *)DateToString:(NSDate *)date;

+(UIColor *)DinnerNaviBarColor;

+(UIColor *)CalendarBackgroundColor;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size;

+(NSDate*)StringToDate:(NSString*)day;

+(NSMutableAttributedString *)attributeTextResizeStable:(NSAttributedString *)attributedText withContainer:(UIScrollView *)scview;
@end
