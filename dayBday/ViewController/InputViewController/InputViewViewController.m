//
//  InputViewViewController.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 5..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "InputViewViewController.h"

#define  PHOTO 1
@interface InputViewViewController ()

@end




@implementation InputViewViewController
{
    UIView * inputControllerBar;
    CGFloat barHeight;
    UIView * controllBar;
    NSLayoutConstraint * bottomContaint;
    UITextView * inputTextView;
    NSMutableArray * subBtns;

}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self registerForKeyboardNotifications];
    }
    return self;
}

-(void)setUpBottonBarView{
    
    CGFloat height =[self.delegate controlBarheight];

    controllBar  =[[UIView alloc]initWithFrame:CGRectZero];
    controllBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:controllBar];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:controllBar
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.0f
                                                           constant:height]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:controllBar
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:controllBar
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
     bottomContaint = [NSLayoutConstraint constraintWithItem:controllBar
                                                   attribute:NSLayoutAttributeBottom
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.view
                                                   attribute:NSLayoutAttributeBottom
                                                  multiplier:1.0f
                                                    constant:0.0f];
    [self.view addConstraint:bottomContaint];
    controllBar.backgroundColor = [UIColor lightGrayColor];


    
    
}

-(void)setUpTextView{
    inputTextView.translatesAutoresizingMaskIntoConstraints = NO;
    inputTextView.backgroundColor = [UIColor whiteColor];
    inputTextView = [self.delegate textViewBinding];
    [self.view addSubview:inputTextView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:inputTextView
                                                          attribute:NSLayoutAttributeTopMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:30.f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:inputTextView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:inputTextView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:inputTextView
                                                  attribute:NSLayoutAttributeBottom
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:controllBar
                                                  attribute:NSLayoutAttributeTop
                                                 multiplier:1.0f
                                                   constant:0.0f]];

}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated: YES completion: nil];
    UIImage *image = [info valueForKey: UIImagePickerControllerOriginalImage];
    [self addTextAttachmentWithImage:image textScale:0.f];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)buttonSelector:(id)sender{
    
    
    UIImagePickerController * imagePickerViewController= [[UIImagePickerController alloc]init];
    imagePickerViewController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerViewController.allowsEditing = NO;
    imagePickerViewController.delegate = self;
    imagePickerViewController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
    UIButton * btn = (UIButton *)sender;
    switch (btn.tag) {
        case PHOTO:
            [self presentViewController:imagePickerViewController animated:YES completion:nil];
            break;
        case PHOTO+1:
            break;
        case PHOTO+2:
            break;
        case PHOTO+3:
        {
            [self insertCheckBoxButton];
             break;
        }
        case PHOTO+4:
        {
            if([inputTextView isFirstResponder]){
                [inputTextView resignFirstResponder];
            }
            [self.delegate resultTextView:inputTextView];
            [self dismissViewControllerAnimated:YES completion:^{
                //비동기 디비 insert 
            }];
            break;

        }
            
        default:
            break;
    }
}


-(void)insertCheckBoxButton{
    UIImage *image = [UIImage imageNamed:@"be"];
    //    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    NSTextAttachment * attach = [self addTextAttachmentWithImage:image textScale:2.f];

    [self.delegate insertCheckBtn:attach];
}

-(NSTextAttachment *)addTextAttachmentWithImage:(UIImage *)image  textScale:(CGFloat)scaleFactor{
    
    UITextView *textView = inputTextView;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:textView.attributedText];
    if(!attributedString){
        attributedString = [[NSMutableAttributedString alloc] initWithString:textView.text];
    }
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    if(scaleFactor == 0.f){
        CGFloat oldWidth = image.size.width;
        scaleFactor = oldWidth / (textView.frame.size.width - 10);
    }
        NSData *data = UIImageJPEGRepresentation(image, 0.4);
    textAttachment.image = [UIImage imageWithData:data scale:scaleFactor];
    //[UIImage imageWithCGImage:textAttachment.image.CGImage scale:scaleFactor orientation:UIImageOrientationUp|];
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [attributedString appendAttributedString:attrStringWithImage];
    textView.attributedText = attributedString;
    
    return textAttachment;

}

-(void)customBottomBar:(UIView *)barView{
    
    
    CGFloat bar_Height = controllBar.frame.size.height;
    CGFloat leftMagin = 5.f;
    CGFloat tempX = 0.f;
    
    NSLog(@"%f" ,bar_Height);
    
    for(int i = 0 ; i < 5; i ++){
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.userInteractionEnabled = YES;
        button.backgroundColor = [ UIColor blackColor];
        button.tag = i+1;
        [button addTarget:self action:@selector(buttonSelector:) forControlEvents:UIControlEventTouchUpInside];
        button.frame =CGRectMake(leftMagin* (i + 1) + tempX, leftMagin, bar_Height- (leftMagin * 2), bar_Height - (leftMagin*2));
        tempX += (button.frame.size.width);
        [subBtns addObject:button];
        [controllBar addSubview:button];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    subBtns = [[NSMutableArray alloc]init];
    [self setUpBottonBarView];
    [self setUpTextView];
    [inputTextView becomeFirstResponder];
}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"%lf",controllBar.frame.size.height);
    if(subBtns.count == 0){
        [self customBottomBar:nil];
    }


}
-(void)viewDidDisappear:(BOOL)animated{

    if([inputTextView isFirstResponder]){
        [inputTextView resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification object:nil];
    self.delegate = nil;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}




// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    bottomContaint.constant= -kbSize.height;
    [self viewIfLoaded];

}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    NSLog(@"keyboardWillBeHidden");
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    bottomContaint.constant= kbSize.height;
    [self viewIfLoaded];

    
}

@end
