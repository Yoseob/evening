//
//  ContainerScollView.h
//  dayBday
//
//  Created by LeeYoseob on 2015. 12. 4..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContainerScollView : UIView
@property (nonatomic ,strong) UITextView * textView;

-(id)initWithFrame:(CGRect)frame;
-(void)addTextView:(UITextView *)_textView;
- (void) moveViewPosition:(CGPoint)point;
- (void) moveViewPositionToInitial;
@end
