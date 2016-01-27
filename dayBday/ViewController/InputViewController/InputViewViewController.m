//
//  InputViewViewController.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 5..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "InputViewViewController.h"

#define  PHOTO 1
#define VIEW_MARGIN 10

typedef enum : NSUInteger {
    seperaterLine,
    checkBox,
    justImage,
} AttrImageType;

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
    
    CGRect originRect;
    
    BOOL endCheckBox;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self registerForKeyboardNotifications];
        endCheckBox = NO;
    }
    return self;
}

-(void)setUpBottonBarView{
    CGFloat height =[self.delegate controlBarheight];
    controllBar.backgroundColor = [DinnerUtility mainbackgroundColor];
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

}

-(void)setUpTextView{
    
    inputTextView = [[UITextView alloc]initWithFrame:CGRectZero];
    inputTextView.translatesAutoresizingMaskIntoConstraints = NO;
    inputTextView.backgroundColor = [UIColor whiteColor];
    inputTextView.delegate = self;
    inputTextView.allowsEditingTextAttributes = YES;
    inputTextView.attributedText = [self.delegate textViewBinding].attributedText;
    
    [inputTextView setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:14]];
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
    [self addTextAttachmentWithImage:image textScale:0.f withType:justImage];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - buttom actions 
-(void)addimage:(id)sender{
    UIImagePickerController * imagePickerViewController= [[UIImagePickerController alloc]init];
    imagePickerViewController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerViewController.allowsEditing = NO;
    imagePickerViewController.delegate = self;
    imagePickerViewController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:imagePickerViewController animated:YES completion:nil];
}
-(void)addTmsp:(id)sender{

}

-(void)addCheckBox:(id)sender{
    [self insertCheckBoxButton];
}

-(void)addNewLine:(id)sender{
    UIImageView * lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(VIEW_MARGIN, 0, inputTextView.frame.size.width - (VIEW_MARGIN), 1)];
    lineImage.backgroundColor = [DinnerUtility mainbackgroundColor];
    [self addTextAttachmentWithImage:[self getImageFromView:lineImage] textScale:0.f withType:seperaterLine];
}

-(void)addJustAndFinish:(id)sender{
    if([inputTextView isFirstResponder]){
        inputTextView.editable = false;
        [inputTextView resignFirstResponder];
    }
    [self.delegate resultTextView:inputTextView];
    [self dismissViewControllerAnimated:YES completion:^{
        //비동기 디비 insert
    }];
}

-(void)insertCheckBoxButton{
    UIImage *image = [UIImage imageNamed:@"checkbox_todo"];
    endCheckBox = true;
    [self addTextAttachmentWithImage:image textScale:2.f withType:checkBox];
    inputTextView.attributedText = [self.delegate insertCheckBtnWithString:inputTextView.attributedText];
}

-(void)addTextAttachmentWithImage:(UIImage *)image  textScale:(CGFloat)scaleFactor withType:(AttrImageType)type{
    
    UITextView *textView = inputTextView;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:textView.attributedText];
    if(!attributedString){
        attributedString = [[NSMutableAttributedString alloc] initWithString:textView.text];
    }
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    if(scaleFactor == 0.f){
        CGFloat oldWidth = image.size.width;
        scaleFactor = oldWidth / (textView.frame.size.width - VIEW_MARGIN);
    }
    
    
    if(seperaterLine == type){
        textAttachment.image = image;
        
    }else{
        NSData *data = UIImageJPEGRepresentation(image, 0.4);
        textAttachment.image = [UIImage imageWithData:data scale:scaleFactor];
    }
    
    //[UIImage imageWithCGImage:textAttachment.image.CGImage scale:scaleFactor orientation:UIImageOrientationUp|];
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    NSAttributedString * space = [[NSAttributedString alloc]initWithString:@" "];
    //@todo change insert where currunt cursor position
    [attributedString appendAttributedString:attrStringWithImage];
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;
        NSDictionary *dict = @{NSParagraphStyleAttributeName : paragraphStyle };
        [attributedString addAttributes:dict range:NSMakeRange(attributedString.length-1, 1)];
    }
    
    [attributedString appendAttributedString:space];
    textView.attributedText = attributedString;
    [inputTextView setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:14]];
}

-(void)customBottomBar:(UIView *)barView{
    CGFloat bar_Height = controllBar.frame.size.height;
    CGFloat leftMagin = 5.f;
    CGFloat tempX = 0.f;

    SEL selecters[] = { @selector(addimage:),@selector(addTmsp:),@selector(addCheckBox:),@selector(addNewLine:),@selector(addJustAndFinish:)};
    
    for(int i = 0 ; i < 5; i ++){
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.userInteractionEnabled = YES;
        NSString * imageName = [NSString stringWithFormat:@"input_%d",i];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button addTarget:self action:selecters[i] forControlEvents:UIControlEventTouchUpInside];
        button.frame =CGRectMake(leftMagin + tempX, leftMagin, bar_Height- (leftMagin * 2), bar_Height - (leftMagin*2));
        tempX = CGRectGetMaxX(button.frame);

        [subBtns addObject:button];
        [controllBar addSubview:button];
    }
}
-(UIImage *)getImageFromView:(UIView *)view{
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    bottomContaint.constant= -kbSize.height;
    [self viewIfLoaded];

}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    NSLog(@"keyboardWillBeHidden");
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    bottomContaint.constant= kbSize.height;
    [self viewIfLoaded];
}

#pragma mark - UITextViewDelegate 

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"] && endCheckBox){
        NSMutableAttributedString * temp = [[NSMutableAttributedString alloc]initWithAttributedString:inputTextView.attributedText];
        [temp appendAttributedString:[[NSAttributedString alloc]initWithString:@"\n"]];
        inputTextView.attributedText = temp;
        [self insertCheckBoxButton];
        textView.attributedText  = inputTextView.attributedText;
        return NO;
    }
    if(textView.attributedText.length > 1){
        NSDictionary * first =  [textView.attributedText attributesAtIndex:range.location-1 effectiveRange:&range];
        if (endCheckBox && first) {
            NSDictionary * dic =  [textView.attributedText attributesAtIndex:range.location effectiveRange:&range];
            if(dic[@"NSAttachment"]){
                endCheckBox = !endCheckBox;
            }
        }
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
}

// use selction
- (void)textViewDidChangeSelection:(UITextView *)textView{
    //    textView.attributedText = [DinnerUtility modifyAttributedString:textView.attributedText];
//    NSLog(@"textViewDidChangeSelection :  %@ " , textView.text);
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange{
    NSLog(@"shouldInteractWithTextAttachment");
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    subBtns = [[NSMutableArray alloc]init];
    [self setUpBottonBarView];
    [self setUpTextView];
    [inputTextView becomeFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated{
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


@end
