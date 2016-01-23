//
//  ContainerScollView.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 12. 4..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "ContainerScollView.h"

@implementation ContainerScollView
@synthesize textView;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.masksToBounds = YES;
    }
    return self;
}

-(void)addTextView:(UITextView *)_textView{
    textView = _textView ;
    [self addSubview:_textView];
}

-(void)moveViewPosition:(CGPoint)point{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat x = point.x - self.frame.origin.x;
    
    if (x > -width && x < width) {
        //현재 위치와 비교한 값의 절반을 x좌표로 한다.
        textView.frame = CGRectMake(x/2, point.y, width, height);
    }
}
- (void) moveViewPositionToInitial{
    //(0,0)으로 원위치 시킴.
    [self moveViewPosition:CGPointMake(0, 0)];
}
@end
