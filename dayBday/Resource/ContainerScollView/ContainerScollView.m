//
//  ContainerScollView.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 12. 4..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "ContainerScollView.h"

@implementation ContainerScollView
@synthesize currentScollView;
-(id)initWithCurrentScrollView:(UIScrollView *)sc{
    self = [super init];
    if(self){
        currentScollView = sc;
    }
    
    return self;
}



@end
