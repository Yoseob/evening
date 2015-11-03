//
//  DayBDayViewController.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 2..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "DayBDayViewController.h"
#import "MBProgressHUD.h"
#import "BottomContainerView.h"

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
    UITextView * innerTextView;
    NSDate * today;
    BottomContainerView * bottomBar;
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
    CGFloat newHeight = 300.0f;
    NSLog(@"transitionCalendarMode");
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = 75.0f;
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


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(innerTextView == nil){
        innerTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.currentDayScollView.frame.size.height)];
        innerTextView.delegate = self;
        innerTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        innerTextView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:innerTextView];
   
    }
    return cell;
}
#pragma mark -
#pragma UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView{
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
}


#pragma mark - 
#pragma UITableViewDelegate


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
    [self setUpContentView];
    [self setUpTableView];
    
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self pushTodayButton:nil];
    });
}

- (void)setUpMenuView {
    self.calendarMenuView = [[JTCalendarMenuView alloc] initWithFrame:CGRectZero];
    self.calendarMenuView.translatesAutoresizingMaskIntoConstraints = NO;
    self.calendarMenuView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.calendarMenuView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.calendarMenuView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.calendarMenuView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.calendarMenuView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.calendarMenuView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:0.0f
                                                           constant:25.0f]];
}

- (void)setUpContentView {
    self.calendarContentView = [[JTCalendarContentView alloc] initWithFrame:CGRectZero];
    self.calendarContentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.calendarContentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.calendarContentView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.calendarContentView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.calendarMenuView
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
                                                                             constant:300.0f];
    [self.view addConstraint:self.calendarContentViewHeightConstraint];
}

- (void)setUpTableView {
    self.currentDayScollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.currentDayScollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.currentDayScollView.scrollEnabled = YES;
    self.currentDayScollView.pagingEnabled = NO;
    self.currentDayScollView.showsHorizontalScrollIndicator = YES;
    self.currentDayScollView.delegate = self;
    self.currentDayScollView.backgroundColor = [UIColor redColor];
    self.currentDayScollView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);
    [self.view addSubview:self.currentDayScollView];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.currentDayScollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.calendarContentView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f
                                                           constant:5.0f]];
    
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

    CGFloat contentHeight = 0.f;
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    contentHeight += headerView.frame.size.height;
    [self.currentDayScollView addSubview:headerView];
    
    innerTextView = [[UITextView alloc]initWithFrame:CGRectZero];
    innerTextView.backgroundColor = [UIColor yellowColor];
    [self.currentDayScollView addSubview:innerTextView];
   

}

- (void)setUpBarButtonItems {
    UIBarButtonItem *todayButton = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStylePlain target:self action:@selector(pushTodayButton:)];
    UIBarButtonItem *changeModeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(pushChangeModeButton:)];
    
    [self.navigationItem setRightBarButtonItems:@[todayButton, changeModeButton]];
}


-(void)setUpBottomBarContainer{
    
    CGFloat barHeight =self.navigationController.navigationBar.frame.size.height;
    CGFloat stateHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    bottomBar = [[BottomContainerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - barHeight - (barHeight + stateHeight),
                                                                                      self.view.frame.size.width,
                                                                                      barHeight)];

    bottomBar.backgroundColor = [UIColor brownColor];
    [self.view addSubview:bottomBar];

}


-(void)addUpDownGesture{
    UISwipeGestureRecognizer * updownGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(pushChangeModeButton:)];
    updownGesture.direction = UISwipeGestureRecognizerDirectionUp  | UISwipeGestureRecognizerDirectionDown;
    if(self.calendarContentView != nil){
        [self.calendarContentView addGestureRecognizer:updownGesture];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBarHidden = YES
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpBottomBarContainer];
    [self setUpCalendar];
    [self setUpBarButtonItems];
    [self addUpDownGesture];
    
    [self.view bringSubviewToFront:bottomBar];
    [self registerForKeyboardNotifications];
    //savedDates = [@{} mutableCopy];
    
    
}

- (void)viewDidLayoutSubviews {
    [self.calendar repositionViews];

    innerTextView.frame =CGRectMake(0, 30 , self.view.frame.size.width, self.view.frame.size.height - self.calendarContentView.frame.size.height);
    CGFloat headerInsetHeight = 20.f;
    self.currentDayScollView.contentSize =CGSizeMake(self.view.frame.size.width,
                                                     innerTextView.frame.size.height  + innerTextView.frame.origin.y - bottomBar.frame.size.height - headerInsetHeight);
}


- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{


    NSDateComponents *currentDateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    
    for (NSNumber *number in [[savedDates objectForKey:[NSNumber numberWithInteger:currentDateComponents.year]]
                              objectForKey:[NSNumber numberWithInteger:currentDateComponents.month]]) {
        if ([number integerValue] == currentDateComponents.day) {
            return YES;
        }
    }

    return NO;
    
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date {
    today = date;
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);

        NSLog(@"keyboardWillBeHidden");
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSLog(@"keyboardWillBeHidden");
}
@end
