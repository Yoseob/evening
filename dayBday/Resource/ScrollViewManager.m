//
//  ScrollViewManager.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 12. 4..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "ScrollViewManager.h"

@implementation ScrollViewManager
@synthesize viewController;
@synthesize container;
-(id)initWithViewController:(DayBDayViewController *)vc{
    self = [super init];
    if(self){
        self.viewController = vc;
    }
    return  self;
}
@end
