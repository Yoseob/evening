//
//  DinnerDay.h
//  dayBday
//
//  Created by LeeYoseob on 2015. 12. 3..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DinnerDay : NSObject

@property(assign,nonatomic)NSInteger index;
@property(copy,nonatomic)NSString * dayStr;
@property(copy,nonatomic)NSString * orignText;
@property(strong,nonatomic)NSData * attrData;
@property(strong,nonatomic)NSAttributedString * attrText;
@property(strong,nonatomic)DinnerDay * left,*right;


@end
