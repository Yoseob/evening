//
//  CheckBox.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 25..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "CheckBox.h"

@implementation CheckBox
@synthesize location ,status;
-(id)initWithLoc:(NSInteger)loc andStatus:(int)stat{
    self = [super init];
    if(self){
        self.location = loc ;
        self.status = stat;
    }
    return  self;
}


@end
