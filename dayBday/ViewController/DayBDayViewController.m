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
#import "MainViewBuilder.h"
#import "SearchViewController.h"

//will remove after DAO test
#import "DinnerUtility.h"
#import "CheckBoxsDao.h"
#import "CheckBox.h"
#import "DataBaseManager.h"
#import "ScrollViewManager.h"


#import "dayBday-Swift.h"
#define CALENDAR_ORIGIN_HEIGHT 40.f
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
    
    MainViewBuilder * viewBuilder;
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
    UIView * naviFrameView;
    
    OLNGradientView * gradientView;
    UIView * gradientContainerView;
    
    DinnerAppearance * appearance;
    
    UIScrollView * containerScollView;
    ScrollViewManager * sManager;

    BOOL isScroll;
    CGFloat moved;
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupAndInit];
    [self setUpCalendar];
    [self setUpBottomBarContainer];
    [self setupContainerScollView];
    [self setUpBarButtonItems];
    [self addUpDownGesture];
    
    [self setupGradientView:[NSDate new]];
    
    [viewBuilder buildGradientView:gradientContainerView];
    
}

- (void)viewDidLayoutSubviews {
    [self.calendar repositionViews];
    [sManager changeContainerViewSize:containerScollView.frame.size.height];
}

-(void)viewDidAppear:(BOOL)animated{
}

#pragma mark -
#pragma mark IBActions
- (void)pushTodayButton:(id)sender {
    NSDate *currentDate = [NSDate date];
    [self.calendar setCurrentDateSelected:currentDate];
    [self.calendar setCurrentDate:currentDate];
    [self.calendar selectedDayViewWithIndex:[DinnerUtility DateToString:currentDate]];
    [self calendarDidDateSelected:self.calendar date:currentDate];;
}

- (void)pushChangeModeButton:(id)sender {
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    [self transitionCalendarMode];

}

-(void)showSearchViewController{
    SearchAndLoadViewController * vc = [[SearchAndLoadViewController alloc]init];
    vc.view.backgroundColor = [UIColor whiteColor];
    [vc setDataBasemanager:@""];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)transitionCalendarMode {
    CGFloat newHeight = 240.f;
    CGFloat textViewHeight =containerScollView.frame.size.height;
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = CALENDAR_ORIGIN_HEIGHT;
    }
    [sManager changeContainerViewSize:textViewHeight];
    [UIView animateWithDuration:.4
                     animations:^{
                         self.calendarContentViewHeightConstraint.constant = newHeight;
                         [self.view layoutIfNeeded];
                     }];
    
    [UIView animateWithDuration:.15
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
    NSLog(@"oldKey = %@ %ld, %@",oldKey ,tempCheckBox.location , tempCheckBox);
    if(tempCheckBox){
        if(tempCheckBox){
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithAttributedString:self.currentDayTextView.attributedText];
            NSTextAttachment * newAttrText;
            {

                newAttrText = [NSTextAttachment new];
                tempCheckBox.status = (tempCheckBox.status == 0 ? 1 : 0);
                newAttrText.image = checkBoxImages[tempCheckBox.status];
                newAttrText.image = [UIImage imageWithCGImage:newAttrText.image.CGImage scale:2.f orientation:UIImageOrientationUp];
                {
                    [attributedText replaceCharactersInRange:characterRange withAttributedString:[NSAttributedString attributedStringWithAttachment:newAttrText]];
                    [attributedText addAttribute:(__bridge NSString *)kCTSuperscriptAttributeName value:@(-1) range:characterRange];
                    
                }
                {
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    paragraphStyle.lineSpacing = 5;
                    NSDictionary *dict = @{NSParagraphStyleAttributeName : paragraphStyle };
                    [attributedText addAttributes:dict range:characterRange];
                    
                }


            }
            
            if(tempCheckBox){
                NSString * newKey = [NSString stringWithFormat:@"%ld",characterRange.location];
                [checkBoxs removeObjectForKey:oldKey];
                tempCheckBox.date = today;
                [checkBoxs setObject:tempCheckBox forKey:newKey];
                NSLog(@"%@,  %d",tempCheckBox.date , tempCheckBox.status);
                
                int loc = (int)characterRange.location;
                //꼭...집어 넣자... 이게모니...휴...
                NSString  * query =[NSString stringWithFormat: @"SELECT * from checkboxs WHERE ownerDay = \"%@\" AND location = %d" , [DinnerUtility DateToString:today],loc];
                CheckBox * temp = [[CheckBoxsDao getDefaultCheckBoxsDao]selectTargetDataWith:today withQeury:query].lastObject;
                NSLog(@"1=== %d",temp.status);

                
                [[CheckBoxsDao getDefaultCheckBoxsDao]deleteRowWithCB:tempCheckBox];
                [[CheckBoxsDao getDefaultCheckBoxsDao]insertDataWithCB:tempCheckBox];
                
                temp = [[CheckBoxsDao getDefaultCheckBoxsDao]selectTargetDataWith:today withQeury:query].lastObject;
                NSLog(@"2=== %d",temp.status);
            }
            [self setCurrentDayAttrbutedString:attributedText];
        }else{
            [images setObject:textAttachment forKey:oldKey];
        }
    }else{
        NSLog(@"gestureRecognizer : %@" , tempCheckBox);
    }
}

#pragma mark Subview setup

- (void)setUpCalendar {
    self.calendar = [JTCalendar getDefaultJTCalendar];
    self.calendar.calendarAppearance.menuMonthTextFont = [UIFont systemFontOfSize:13.0f];
    self.calendar.calendarAppearance.menuMonthTextColor = [UIColor whiteColor];
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
    self.calendar.delegate = self;
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
    
    [viewBuilder buildWeekDaysView:weekdaysView withToItem:naviFrameView];
    [JTCalendarMonthWeekDaysView beforeReloadAppearance];
    [weekdaysView reloadAppearance];
    
}


- (void)setUpContentView {
    self.calendarContentView = [[JTCalendarContentView alloc] initWithFrame:CGRectZero];
    self.calendarContentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.calendarContentView.backgroundColor = [UIColor clearColor];
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
                                                           constant:10.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.calendarContentView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0f
                                                           constant:-10.0f]];
    
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
    containerScollView.translatesAutoresizingMaskIntoConstraints = NO;
    containerScollView.scrollEnabled = YES;
    containerScollView.pagingEnabled = NO;
    containerScollView.showsHorizontalScrollIndicator = YES;
    containerScollView.backgroundColor = [UIColor brownColor];
    
    
    [sManager initialScrollViewWith:[NSDate new]];
    [self setUptextViewTapGestureRecognizer];
    [viewBuilder buildContainerScrollerView:containerScollView];
}


- (void)setupTextView:(UITextView *)textview {
    [viewBuilder buildMainContainerTextView:textview];
    [self setCurrentDayAttrbutedString:textview.attributedText];
    [self setUptextViewTapGestureRecognizer];
}


#pragma mark - mainbottomBar Action
-(void)showInputViewController:(id)sender{
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InputViewViewController * modalViewController = [storyBoard instantiateViewControllerWithIdentifier:@"InputViewViewController"];
    modalViewController.delegate = self;
    self.currentDayTextView.editable = YES;
    [self presentViewController:modalViewController animated:YES completion:^{
        textViewTapGestureRecognizer.delegate =  nil;
    }];
    
}

-(void)removeThisEvent:(id)sender{
    [dbManager removeThisDayEvent:today];
    DinnerDay * new = [sManager removeDinnerData:[DinnerUtility DateToString:today]];
    today = [DinnerUtility StringToDate:new.dayStr];
    [self reloadAllofData];

}

#pragma mark 
#pragma InputTextDelegate
-(UITextView *)textViewBinding{
    return self.currentDayTextView;
}

-(CGFloat)controlBarheight{
    return bottomBar.frame.size.height;
}

-(void)resultTextView:(UITextView *)textView{
    [self setupTextView:textView];
    [dbManager insertTextViewDataWith:textView cachedCheckBox:checkBoxs data:today];
    if([dbManager searchDataWithData:today]!=nil && dbManager.dinnerWithViewTable[[DinnerUtility DateToString:today]] == nil){
         [sManager insertNewTextView:today];
    }
    [self reloadAllofData];
}

-(void)reloadAllofData{
    [self.calendar.dataCache reloadData];
    [self.calendarContentView reloadData];
    [self.calendarContentView reloadAppearance];
}

-(void)removeCheckBox:(NSString *)cb{

}
-(NSMutableAttributedString *)insertCheckBtnWithString:(NSAttributedString *)attrText;{
    NSMutableAttributedString * myAttrString = [[NSMutableAttributedString alloc]initWithAttributedString:attrText];
    if(myAttrString){
        [myAttrString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, myAttrString.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            NSTextAttachment *  textAttachment = value;
            if(textAttachment){
                UIImage * image = nil;
                if ([textAttachment image]){
                    image = [textAttachment image];
                }else{
                    image = [textAttachment imageForBounds:[textAttachment bounds]
                                             textContainer:nil
                                            characterIndex:range.location];
                }
                
                CGFloat imageSize = image.size.height;
                NSLog(@"imagesize : %lf",imageSize);
                if(imageSize != 1.f && imageSize < 50.f){
                    
                    int loc = (int)range.location;
                    NSString * key = [NSString stringWithFormat:@"%d",loc];
                    
                    if(!checkBoxs[key]){
                        CheckBox * newCheckBox = [[CheckBox alloc]initWithLoc:loc andStatus:0];
                        newCheckBox.date = today;
                        [checkBoxs setObject:newCheckBox forKey:key];
                        [myAttrString addAttribute:(__bridge NSString *)kCTSuperscriptAttributeName value:@(-1) range:range];
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                        paragraphStyle.lineSpacing = 5;
                        NSDictionary *dict = @{NSParagraphStyleAttributeName : paragraphStyle };
                        [myAttrString addAttributes:dict range:range];
                        
                    }
                }
            }
        }];
    }
    return myAttrString;
}

-(void)insertCheckBtn:(NSTextAttachment *)textAtmt{
}

-(void)setUpTableView{
    
}

#pragma mark
- (void)setUpBarButtonItems {
    //first search , second setting
    SEL naviSelecters[] = { @selector(showSearchViewController),@selector(pushChangeModeButton:)};
    [viewBuilder createNaviBarWithSelecters:naviSelecters];
}

-(void)setUpBottomBarContainer{
    CGFloat barHeight =self.navigationController.navigationBar.frame.size.height;
//    CGFloat stateHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat bottomBarY = self.view.frame.size.height - barHeight;// - (barHeight + stateHeight);
    bottomBar = [[BottomContainerView alloc]initWithFrame:CGRectMake(0,bottomBarY,self.view.frame.size.width,45.f)];
    
    SEL bottomSelecters[] = { @selector(showInputViewController:),@selector(removeThisEvent:),@selector(showInputViewController:)};
    [viewBuilder createButtomBar:bottomBar withSelecters:bottomSelecters];
}


-(void)setUptextViewTapGestureRecognizer{
    textViewTapGestureRecognizer.delegate = self;
    [self.currentDayTextView addGestureRecognizer:textViewTapGestureRecognizer];
}

-(void)addUpDownGesture{
    UISwipeGestureRecognizer * updownGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(pushChangeModeButton:)];
    updownGesture.direction = UISwipeGestureRecognizerDirectionUp  | UISwipeGestureRecognizerDirectionDown;
    if(self.calendarContentView != nil){
        [self.calendarContentView addGestureRecognizer:updownGesture];
    }
}

-(void)setupAndInit{
    
    dbManager = [DataBaseManager getDefaultDataBaseManager];
    
    viewBuilder = [[MainViewBuilder alloc]initWithTarget:self];
    {
        
        naviFrameView = [[UIView alloc]initWithFrame:self.navigationController.navigationBar.frame];
        naviFrameView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:naviFrameView];

        self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
        self.view.backgroundColor = [UIColor whiteColor];
     
        {
            self.currentDayTextView = [[UITextView alloc] initWithFrame:CGRectZero];
            containerScollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
            containerScollView.frame = CGRectZero;
            textViewTapGestureRecognizer = [[HPTextViewTapGestureRecognizer alloc]init];
            textViewTapGestureRecognizer.delegate = self;
        }
        
        {
            sManager = [[ScrollViewManager alloc]initWithViewController:self];
            [sManager setContainer:containerScollView];
        }
    }

    {
        checkBoxs = [NSMutableDictionary new];
        images = [NSMutableDictionary new];
        checkBoxImages = @[[UIImage imageNamed:@"checkbox_todo"] , [UIImage imageNamed:@"checkbox_did"]];
        originTextViewFrame = CGRectZero;
        isScroll = YES;
    }
    
    {
        appearance= [DinnerAppearance defaultAppearance];
        gradientContainerView = [UIView new];
        [self.view addSubview:gradientContainerView];
    }
}

-(void)setupGradientView:(NSDate*)day{
    NSLog(@"day : %@" , day);
    appearance.currentMonth = day;
    gradientView = nil;
    
    gradientView = [[OLNGradientView alloc]initWithFrame:CGRectZero];
    gradientView.topColor = [appearance getTopColor];
    gradientView.bottomColor = [appearance getBottomColor];
    [gradientContainerView addSubview:gradientView];
    [viewBuilder copyConstraint:gradientView andTargetView:gradientContainerView];
}


- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date{
    return [dbManager isDateDinner:[DinnerUtility DateToString:date]];
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date {

    today = date;
    if(![dbManager isDateDinner:[DinnerUtility DateToString:date]]){
        [sManager insertNewTextView:date];
    }else if([dbManager searchDataWithData:date]!=nil && dbManager.dinnerWithViewTable[[DinnerUtility DateToString:date]] == nil){
        [sManager insertNewTextView:date];
    }
    
    [sManager visibleCurrentTextView:date];
    [self changeCurruntScrollView:today];
    [self reloadAllofData];
}

-(void)changeScollerSelectedDay:(NSDate *)day withSelectTextView:(UITextView *)textView{
    today = day;
    [self.calendar setCurrentDate:today];
    [self.calendar setCurrentDateSelected:day];
    [self changeCurruntScrollView:day];
}

-(void)willChangeCurrentDayViewWith:(NSDate *)oldDate andNewData:(NSDate *)newDate{

}

-(void)persentChangeCurrentDay:(float)percent{
    
}

-(void)changeCurruntScrollView:(NSDate *)date{
    [self setUptextViewTapGestureRecognizer];
    NSMutableAttributedString *myAttrString = [[NSMutableAttributedString alloc]initWithAttributedString:self.currentDayTextView.attributedText];
    [checkBoxs removeAllObjects];
    [dbManager getImageInTheAttributeString:myAttrString cacheArr:checkBoxs Day:date];
    /*
    [myAttrString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, myAttrString.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
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
            
            if(image.size.height < 50 && image.size.height != 1.f){
                NSString * key = [NSString stringWithFormat:@"%ld",range.location];
                CheckBox * check = checkBoxs[key];
                NSTextAttachment * newAttrText;
                newAttrText = [NSTextAttachment new];
                newAttrText.image = checkBoxImages[check.status];
                newAttrText.image = [UIImage imageWithCGImage:newAttrText.image.CGImage scale:2.f orientation:UIImageOrientationUp];
                [myAttrString replaceCharactersInRange:range withAttributedString:[NSAttributedString attributedStringWithAttachment:newAttrText]];
                [myAttrString addAttribute:(__bridge NSString *)kCTSuperscriptAttributeName value:@(-1) range:range];
                {
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    paragraphStyle.lineSpacing = 5;
                    NSDictionary *dict = @{NSParagraphStyleAttributeName : paragraphStyle };
                    [myAttrString addAttributes:dict range:range];
                    
                }

                [myAttrString replaceCharactersInRange:range withAttributedString:[NSAttributedString attributedStringWithAttachment:newAttrText]];
            }
        }
    }];
     */
    [self setCurrentDayAttrbutedString:myAttrString];
}

-(void)setCurrentDayAttrbutedString:(NSAttributedString *)attrStr{
    
    self.currentDayTextView.delegate = self;
    [self.currentDayTextView setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:14]];
    self.currentDayTextView.attributedText = attrStr;//[DinnerUtility modifyAttributedString:attrStr];
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%lf",scrollView.contentOffset.x);
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSLog(@"scrollViewWillEndDragging");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
-(void)currentMonth:(NSDate *)currentMonth{
    NSLog(@"%@", currentMonth);

    [self setupGradientView:currentMonth];
}

@end
