//
//  ContainerScollView.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 12. 4..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "ContainerScollView.h"

@implementation ContainerScollView
@synthesize curruentTextView;
-(id)initWithCurrentScrollView:(UITextView *)sc{
    self = [super init];
    if(self){
        curruentTextView = sc;
    }
    
    return self;
}
@end
