//
//  ContainerScollView.h
//  dayBday
//
//  Created by LeeYoseob on 2015. 12. 4..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContainerScollView : UIScrollView
@property (nonatomic ,strong) UITextView * curruentTextView;

-(id)initWithCurrentScrollView:(UIScrollView *)sc;

@end
