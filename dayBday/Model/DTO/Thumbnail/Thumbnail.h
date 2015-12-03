//
//  Thumbnail.h
//  dayBday
//
//  Created by LeeYoseob on 2015. 12. 3..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "TransferAble.h"
#import <UIKit/UIKit.h>
@interface Thumbnail : TransferAble
@property(nonatomic,strong) UIImage * image;
@property(nonatomic,copy) NSString * dayStr;
+(id)initWithInterval:(int)interval imageDate:(NSData*)data dayStr:(NSString *)str;
@end
