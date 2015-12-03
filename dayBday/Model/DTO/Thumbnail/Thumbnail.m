//
//  Thumbnail.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 12. 3..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "Thumbnail.h"

@implementation Thumbnail

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
+(id)initWithInterval:(int)interval imageDate:(NSData*)data dayStr:(NSString *)str{
    Thumbnail * t = [Thumbnail new];
    t.image = [UIImage imageWithData:data scale:0.5f];
    t.date = [NSDate dateWithTimeIntervalSince1970:interval];
    t.dayStr = str;
    return t;
}
@end
