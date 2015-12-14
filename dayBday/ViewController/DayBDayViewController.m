//
//  DayBDayViewController.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 2..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "DayBDayViewController.h"
#import "JTCalendarMonthWeekDaysView.h"
#import "MBProgressHUD.h"
#import "BottomContainerView.h"
#import "DinnerUtility.h"

//will remove after DAO test

#import "CheckBoxsDao.h"
#import "CheckBox.h"

#import "DataBaseManager.h"
#import "ContainerScollView.h"
@interface DayBDayViewController () < UIScrollViewDelegate,  UITextViewDelegate>

@property (strong, nonatomic, readwrite) NSLayoutConstraint *calendarContentViewHeightConstraint;

- (void)pushTodayButton:(id)sender;
- (void)pushChangeModeButton:(id)sender;
- (void)transitionCalendarMode;

- (void)setUpCalendar;
- (void)setUpMenuView;
- (void)setUpContentView;
- (void)setUpTableView;

- (void)setUpBarButtonItems;

@end

@implementation DayBDayViewController{
    HPTextViewTapGestureRecognizer *textViewTapGestureRecognizer;
    BottomContainerView * bottomBar;
    JTCalendarMonthWeekDaysView * weekdaysView;
    DataBaseManager * dbManager;
    
    NSDate * today;
    NSLayoutConstraint *keyboardContraint;
    CGRect originTextViewFrame;
    NSMutableDictionary * checkBoxs , *images;
    NSArray * checkBoxImages;
    
    UIView * keyBoardController;
    ContainerScollView * containerScollView;

}

#pragma mark -
#pragma mark IBActions

- (void)pushTodayButton:(id)sender {
    NSDate *currentDate = [NSDate date];
    
    [self.calendar setCurrentDateSelected:currentDate];
    [self.calendar setCurrentDate:currentDate];
    [self calendarDidDateSelected:self.calendar date:currentDate];;
}

- (void)pushChangeModeButton:(id)sender {
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    [self transitionCalendarMode];

}

- (void)transitionCalendarMode {
    CGFloat newHeight = 240.f;
    NSLog(@"transitionCalendarMode");
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = 40.0f;
    }
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.calendarContentViewHeightConstraint.constant = newHeight;
                         [self.view layoutIfNeeded];
                     }];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.calendarContentView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.calendar reloadAppearance];
                         
                         [UIView animateWithDuration:.25
                                          animations:^{
                                              self.calendarContentView.layer.opacity = 1;
                                          }];
                     }];
    
    
    
}

-(void)gestureRecognizerNotthing{
    NSLog(@"gestureRecognizerNotthing");
    [self showInputViewController:nil];
}

-(void)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer handleTapOnAttributeString:(NSAttributedString *)attrString inRange:(NSRange)characterRange  {
    NSLog(@"%@",attrString);
}

-(void)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer handleTapOnTextAttachment:(NSTextAttachment*)textAttachment inRange:(NSRange)characterRange
{
    NSString * oldKey = [NSString stringWithFormat:@"%ld",characterRange.location];

    CheckBox * tempCheckBox = checkBoxs[oldKey];
    
    NSLog(@"oldKey = %@ %ld ",oldKey ,tempCheckBox.location );
    if(tempCheckBox){
        if(tempCheckBox){
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithAttributedString:self.currentDayScollView.attributedText];
            NSTextAttachment * newAttrText;
            {
                newAttrText = [NSTextAttachment new];
                newAttrText.image = checkBoxImages[tempCheckBox.status];
                newAttrText.image = [UIImage imageWithCGImage:newAttrText.image.CGImage scale:2.f orientation:UIImageOrientationUp];
                [attributedText replaceCharactersInRange:characterRange withAttributedString:[NSAttributedString attributedStringWithAttachment:newAttrText]];
            }
            
            if(tempCheckBox){
                NSString * newKey = [NSString stringWithFormat:@"%ld",characterRange.location];
                [checkBoxs removeObjectForKey:oldKey];
                tempCheckBox.status = (tempCheckBox.status == 0 ? 1 : 0);
                tempCheckBox.date = today;
                [checkBoxs setObject:tempCheckBox forKey:newKey];
                NSLog(@"%@,  %d",tempCheckBox.date , tempCheckBox.status);
                
                [[CheckBoxsDao getDefaultCheckBoxsDao]deleteRowWithCB:tempCheckBox];
                [[CheckBoxsDao getDefaultCheckBoxsDao]insertDataWithCB:tempCheckBox];
            }
            
            self.currentDayScollView.attributedText = attributedText;
            
        }else{
            [images setObject:textAttachment forKey:oldKey];
        }

    }else{
        NSLog(@"gestureRecognizer : %@" , tempCheckBox);
    }
}


#pragma mark -
#pragma mark UITableViewDataSource

#pragma mark -
#pragma UITextViewDelegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"textViewShouldBeginEditing");
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
}


#pragma mark -
#pragma mark Subview setup

- (void)setUpCalendar {
    
    self.calendar = [JTCalendar new];
    self.calendar.calendarAppearance.menuMonthTextFont = [UIFont systemFontOfSize:13.0f];
    self.calendar.calendarAppearance.menuMonthTextColor = [UIColor grayColor];
    self.calendar.calendarAppearance.monthBlock = ^NSString *(NSDate *date, JTCalendar *jt_calendar){
        NSCalendar *calendar = jt_calendar.calendarAppearance.calendar;
        NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
        NSInteger currentMonthIndex = comps.month;
        
        static NSDateFormatter *dateFormatter;
        if(!dateFormatter){
            dateFormatter = [NSDateFormatter new];
            dateFormatter.timeZone = jt_calendar.calendarAppearance.calendar.timeZone;
        }
        
        while(currentMonthIndex <= 0){
            currentMonthIndex += 12;
        }
        NSString *monthText = [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];
        
        return [NSString stringWithFormat:@"%ld %@", comps.year, monthText];
    };
    
    [self setUpMenuView];
    [self setUpweekdaysView];
    [self setUpContentView];

    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self pushTodayButton:nil];
    });
}

- (void)setUpMenuView {
    self.calendarMenuView = [[JTCalendarMenuView alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    self.calendarMenuView.backgroundColor  = [UIColor clearColor];
    self.calendarMenuView.scrollEnabled = NO;

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushTodayButton:)];
    [self.calendarMenuView addGestureRecognizer:tap];
    UIBarButtonItem * barbuttonItem = [[UIBarButtonItem alloc]initWithCustomView:self.calendarMenuView];

    [self.navigationItem setLeftBarButtonItem:barbuttonItem];
    
}
-(void)setUpweekdaysView{
    
    weekdaysView = [JTCalendarMonthWeekDaysView new];
   [weekdaysView setCalendarManager:self.calendar];
    [self.view addSubview:weekdaysView];
    weekdaysView.backgroundColor = [UIColor redColor];
    weekdaysView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:weekdaysView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:weekdaysView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:weekdaysView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:weekdaysView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.calendarContentView
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:0.0f
                                                         constant:20.f]];
    [JTCalendarMonthWeekDaysView beforeReloadAppearance];
    [weekdaysView reloadAppearance];

}
- (void)setUpContentView {
    self.calendarContentView = [[JTCalendarContentView alloc] initWithFrame:CGRectZero];
    self.calendarContentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.calendarContentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.calendarContentView];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.calendarContentView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:weekdaysView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.calendarContentView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.calendarContentView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    self.calendarContentViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.calendarContentView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.view
                                                                            attribute:NSLayoutAttributeHeight
                                                                           multiplier:0.0f
                                                                             constant:240.0f];
    [self.view addConstraint:self.calendarContentViewHeightConstraint];
}

-(void)setupContainerScollView{
    
}

- (void)setupTextView:(UITextView *)textview {
    self.currentDayScollView = textview;
    self.currentDayScollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.currentDayScollView.scrollEnabled = YES;
    self.currentDayScollView.pagingEnabled = NO;
    self.currentDayScollView.showsHorizontalScrollIndicator = YES;
    self.currentDayScollView.delegate = self;
    self.currentDayScollView.backgroundColor = [UIColor whiteColor];
    self.currentDayScollView.font = [UIFont systemFontOfSize:15];
    self.currentDayScollView.editable = NO;
    [self.view addSubview:self.currentDayScollView];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.currentDayScollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.calendarContentView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.currentDayScollView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.currentDayScollView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.currentDayScollView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:bottomBar
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:0.0f]];


    
    [self setUptextViewTapGestureRecognizer];
    
    
}


#pragma mark - mainbottomBar Action
-(void)showInputViewController:(id)sender{
    
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    InputViewViewController * modalViewController = [storyBoard instantiateViewControllerWithIdentifier:@"InputViewViewController"];
    modalViewController.delegate = self;
    self.currentDayScollView.editable = YES;
    [self presentViewController:modalViewController animated:YES completion:^{
        textViewTapGestureRecognizer.delegate =  nil;

    }];
    
}

-(void)removeThisEvent:(id)sender{
    [dbManager removeThisDayEvent:today];
    [self reloadAllofData];
    self.currentDayScollView.text = @"";
}


#pragma mark 
#pragma InputTextDelegate
-(UITextView *)textViewBinding{
    return self.currentDayScollView;
}
-(CGFloat)controlBarheight{
    return bottomBar.frame.size.height;
}
-(void)resultTextView:(UITextView *)textView{
    if(CGRectEqualToRect(originTextViewFrame, CGRectZero)){
        originTextViewFrame = self.currentDayScollView.frame;
    }
    [self setupTextView:textView];
    [dbManager insertTextViewDataWith:textView cachedCheckBox:checkBoxs data:today];
    [self reloadAllofData];
}

-(void)reloadAllofData{
    [self.calendar.dataCache reloadData];
    [self.calendarContentView reloadData];
    [self.calendarContentView reloadAppearance];

}


-(void)removeCheckBox:(NSString *)cb{
    
}
-(void)insertCheckBtn:(NSTextAttachment *)textAtmt{
    
    NSAttributedString *myAttrString = self.currentDayScollView.attributedText;

    if(myAttrString){
        [myAttrString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, myAttrString.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            NSTextAttachment *  textAttachment = value;
            if(textAttachment){
                int loc = (int)range.location;
                NSString * key = [NSString stringWithFormat:@"%d",loc];
                if(!checkBoxs[key]){
                    CheckBox * newCheckBox = [[CheckBox alloc]initWithLoc:loc andStatus:0];
                    newCheckBox.date = today;
                    [checkBoxs setObject:newCheckBox forKey:key];
                }
            }
        }];
    }
}

#pragma mark

- (void)setUpBarButtonItems {
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"search_btn"] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(0, 0, 30, 30);
    [searchBtn addTarget:self action:@selector(pushChangeModeButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * searchButton = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];

    UIButton * settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setImage:[UIImage imageNamed:@"setting_btn"] forState:UIControlStateNormal];
    settingButton.frame = CGRectMake(0, 0, 30, 30);
    [settingButton addTarget:self action:@selector(pushChangeModeButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * settingBarBtn = [[UIBarButtonItem alloc]initWithCustomView:settingButton];
    
    [self.navigationItem setRightBarButtonItems:@[settingBarBtn, searchButton]];
}



-(void)setUpBottomBarContainer{
    
    CGFloat barHeight =self.navigationController.navigationBar.frame.size.height;
    CGFloat stateHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    bottomBar = [[BottomContainerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - barHeight - (barHeight + stateHeight),
                                                                                      self.view.frame.size.width,
                                                                                      45.f)];

    bottomBar.backgroundColor = [UIColor colorWithRed:242/255.f green:242/255.f blue:242/255.f alpha:1.f];
    [self.view addSubview:bottomBar];
    
    CGFloat buttonSize = bottomBar.frame.size.height - 10;

    UIButton * addTask_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addTask_btn setImage:[UIImage imageNamed:@"addTask_btn"] forState:UIControlStateNormal];
    addTask_btn.frame = CGRectMake(bottomBar.frame.size.width/2 - (buttonSize/2), bottomBar.frame.size.height/2 - buttonSize/2, buttonSize , buttonSize);
    [addTask_btn addTarget:self action:@selector(showInputViewController:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:addTask_btn];
    
    UIButton * removeTask_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [removeTask_Btn setImage:[UIImage imageNamed:@"removeTask_Btn"] forState:UIControlStateNormal];
    removeTask_Btn.frame = CGRectMake(addTask_btn.frame.origin.x-80, bottomBar.frame.size.height/2 - buttonSize/2, buttonSize , buttonSize);
    [removeTask_Btn addTarget:self action:@selector(removeThisEvent:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:removeTask_Btn];

    UIButton * everNote_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [everNote_btn setImage:[UIImage imageNamed:@"everNote_btn"] forState:UIControlStateNormal];
    everNote_btn.frame = CGRectMake(addTask_btn.frame.origin.x+80, bottomBar.frame.size.height/2 - buttonSize/2, buttonSize , buttonSize);
    [everNote_btn addTarget:self action:@selector(showInputViewController:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:everNote_btn];

}


-(void)setUptextViewTapGestureRecognizer{
    [self.currentDayScollView addGestureRecognizer:textViewTapGestureRecognizer];
}

-(void)addUpDownGesture{
    UISwipeGestureRecognizer * updownGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(pushChangeModeButton:)];
    updownGesture.direction = UISwipeGestureRecognizerDirectionUp  | UISwipeGestureRecognizerDirectionDown;
    if(self.calendarContentView != nil){
        [self.calendarContentView addGestureRecognizer:updownGesture];
    }
}


-(void)setupAndInit{
    dbManager = [[DataBaseManager alloc]init];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:38/255.f green:38/255.f blue:38/255.f alpha:1.f];
    self.currentDayScollView = [[UITextView alloc] initWithFrame:CGRectZero];
    originTextViewFrame = CGRectZero;
    containerScollView = [[ContainerScollView alloc]initWithCurrentScrollView:self.currentDayScollView];
    textViewTapGestureRecognizer = [[HPTextViewTapGestureRecognizer alloc]init];
    checkBoxs = [NSMutableDictionary new];
    images = [NSMutableDictionary new];
    checkBoxImages =@[[UIImage imageNamed:@"af"] , [UIImage imageNamed:@"be"]];

}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupAndInit];
    [self setUpBottomBarContainer];
    [self setUpCalendar];
    [self setupTextView:self.currentDayScollView];
    [self setUpBarButtonItems];
    [self addUpDownGesture];
    [self.view bringSubviewToFront:bottomBar];
    NSLog(@"printDinnerData");
    [dbManager prepareAllOfDinnerData];
    [dbManager printDinnerData];
}

- (void)viewDidLayoutSubviews {
    [self.calendar repositionViews];
    NSLog(@"viewDidLayoutSubviews");
}

-(void)viewDidAppear:(BOOL)animated{
    if(textViewTapGestureRecognizer){
        textViewTapGestureRecognizer.delegate = self;
        self.currentDayScollView.editable = NO;
    }
}

- (id)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date{
    return  nil;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date {
    today = date;
    
    NSAttributedString *myAttrString= [dbManager searchDataWithData:today];
    if(myAttrString.length > 0){
        self.currentDayScollView.attributedText = [self attributeTextResizeStable:myAttrString];
    }else{
        self.currentDayScollView.text = @"";
    }
    
    
    [checkBoxs removeAllObjects];
    [dbManager getImageInTheAttributeString:myAttrString cacheArr:checkBoxs Day:date];
    
    //TextView reLoad
 }

-(NSMutableAttributedString *)attributeTextResizeStable:(NSAttributedString *)attributedText{
    NSMutableAttributedString * newattributedText = [[NSMutableAttributedString alloc]initWithAttributedString:attributedText];
    [newattributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, newattributedText.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        NSTextAttachment *  textAttachment = value;
        UIImage * image = nil;
        if(textAttachment){
            if ([textAttachment image]){
                image = [textAttachment image];
            }else{
                image = [textAttachment imageForBounds:[textAttachment bounds]
                                         textContainer:nil
                                        characterIndex:range.location];
            }
            
            if(image.size.width > 50){
                NSTextAttachment *newAttrText = [NSTextAttachment new];
                CGFloat oldWidth = image.size.width;
                NSLog(@"oldWidth %lf", oldWidth);
                CGFloat  scaleFactor = oldWidth / (self.currentDayScollView.frame.size.width - 10);
                newAttrText.image = [UIImage imageWithData:UIImagePNGRepresentation(image) scale:scaleFactor];

                
                [newattributedText replaceCharactersInRange:range withAttributedString:[NSAttributedString attributedStringWithAttachment:newAttrText]];
            }
        }
    
    }];

    return  newattributedText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
