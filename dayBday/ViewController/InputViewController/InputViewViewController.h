//
//  InputViewViewController.h
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 5..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol InputViewDelegate <NSObject>

-(UITextView *) textViewBinding;
-(void)resultTextView:(UITextView *)textView;
-(CGFloat)controlBarheight;

-(void)insertCheckBtn:(NSTextAttachment *)textAtmt;
-(void)insertCheckBtnWithString:(NSAttributedString *)attrText;

@end
@interface InputViewViewController : UIViewController <UIImagePickerControllerDelegate>

@property (nonatomic , weak) id<InputViewDelegate> delegate;
@end


