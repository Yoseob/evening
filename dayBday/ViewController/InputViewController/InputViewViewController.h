//
//  InputViewViewController.h
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 5..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DinnerUtility.h"
#import <CoreText/CoreText.h>
@protocol InputViewDelegate <NSObject>

-(UITextView *) textViewBinding;
-(void)resultTextView:(UITextView *)textView;
-(CGFloat)controlBarheight;

-(void)insertCheckBtn:(NSTextAttachment *)textAtmt;
//-(void)insertCheckBtnWithString:(NSAttributedString *)attrText;
-(NSMutableAttributedString *)insertCheckBtnWithString:(NSAttributedString *)attrText;
@end
@interface InputViewViewController : UIViewController <UIImagePickerControllerDelegate , UITextViewDelegate>

@property (nonatomic , weak) id<InputViewDelegate> delegate;
@end


