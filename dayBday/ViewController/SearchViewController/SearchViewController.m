//
//  SearchViewController.m
//  dayBday
//
//  Created by LeeYoseob on 2016. 1. 27..
//  Copyright © 2016년 LeeYoseob. All rights reserved.
//

#import "SearchViewController.h"
#import "DinnerUtility.h"

#define SEARCH_BAR_HEIGHT 30
#define PLACE_HOLDER @" Search.."



@implementation SearchViewController
{
    UITextField * textfield;
    NSLayoutConstraint * bottomContaint;
    DataBaseManager * dbManager;
    
    NSMutableArray * headerStrings;
    NSMutableArray * tableDatas ;
    
    NSDate * currentDate;
    NSDateComponents *dateComponents;
    
    int preIndex , nextIndex;
    //scroll loader
    UILabel * topLoader, * bottomLoader;
    
    BOOL isReload;
    
}
@synthesize searchTableView;

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        headerStrings = [NSMutableArray new];
        tableDatas = [NSMutableArray new];
        preIndex = -1;
        nextIndex = 1;
        isReload = false;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    
}
-(void)viewDidLoad{

    [super viewDidLoad];
    [self setupAndInit];
    [self registerForKeyboardNotifications];
    [self registerForTextFieldNotification];
    [self setupTableView];
    [self setupNavibar];

    
}

#pragma mark - SetupView
-(void)setupAndInit{
    CGFloat topLoaderWidth = 100.f;
    topLoader = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - topLoaderWidth/2, -30, topLoaderWidth, 30)];{
        topLoader.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        topLoader.textAlignment = NSTextAlignmentCenter;
        topLoader.backgroundColor = [UIColor redColor];
        topLoader.text = @"TOP";
        
//        UIView *searchBackgroundView = [[UIView alloc]initWithFrame:self.view.frame];
//        [searchTableView setBackgroundView:searchBackgroundView];
//        [searchTableView.backgroundView addSubview:topLoader];
//        [self.view addSubview:topLoader];
    }
    
}

-(void)topLoaderMover:(CGFloat)offset{
    
     CGFloat maximumOffset = searchTableView.contentSize.height - searchTableView.frame.size.height;
    
    if(offset < 0){
        CGFloat ty = (30.f)+(offset * -1);
//        NSLog(@"%lf , %lf",offset , ty);
        topLoader.frame = CGRectMake(topLoader.frame.origin.x, ty, topLoader.frame.size.width, 30);
    }
    if(offset < -50 && !isReload){

        [self reloadData:nextIndex++];

        CGFloat contentOffSet = searchTableView.contentOffset.y;
        UIEdgeInsets inset = searchTableView.contentInset;
        [searchTableView setContentOffset:CGPointMake(0,offset) animated:NO];
        offset *= -1;
        searchTableView.contentInset = UIEdgeInsetsMake(offset, inset.left, inset.bottom, inset.right);

        [UIView animateWithDuration:3.f animations:^{

        } completion:^(BOOL finished) {
        }];
        isReload = true;


    }
    
    if(maximumOffset+30 <= offset){
        [self reloadData:preIndex--];
    }
}

-(void)setDataBaseManager:(NSString *)day{
    dbManager = [DataBaseManager getDefaultDataBaseManager];
    NSString *date = nil;
    currentDate = [NSDate date];
    dateComponents = [NSDateComponents new];
    
    {
        date = [NSString stringWithFormat:@"%@",currentDate];
        date = [date substringWithRange:NSMakeRange(0, 7)];
        [headerStrings addObject:date];
        
    }
    [self reloadTableView];
}

-(void)reloadData:(int)index{
    NSString *date = nil;
    {
        
        dateComponents.month = index;
        NSDate *currentDateMinus1Month = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
        date = [NSString stringWithFormat:@"%@",currentDateMinus1Month];
        date = [date substringWithRange:NSMakeRange(0, 7)];
        if(index > 0){
            [headerStrings insertObject:date atIndex:0];
        }else{
            [headerStrings addObject:date];
        }
    }
}

-(void)reloadTableView{
    
    [tableDatas removeAllObjects];
    NSArray * result = nil;
    for(NSString * day in headerStrings){
        result = [dbManager feedListUptodateCount:31 endDateStr:day];
        if(result.count > 0){
            [tableDatas addObject:result];
        }
    }
    [searchTableView reloadData];
}

-(void)setupTableView{
    
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    searchTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:searchTableView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0f
                                                             constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:searchTableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:searchTableView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    bottomContaint = [NSLayoutConstraint constraintWithItem:searchTableView
                                                  attribute:NSLayoutAttributeBottom
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self.view
                                                  attribute:NSLayoutAttributeBottom
                                                 multiplier:1.0f
                                                   constant:0.0f];
    [self.view addConstraint:bottomContaint];
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

-(void)registerForTextFieldNotification{
    [textfield addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
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



-(void)setupNavibar{
    UIButton * settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    settingButton.frame = CGRectMake(0, 0, 30, 30);
    [settingButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * settingBarBtn = [[UIBarButtonItem alloc]initWithCustomView:settingButton];
    UIBarButtonItem *navLeftPadding = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [navLeftPadding setWidth:-10.0f];    // 왼쪽 Bar 버튼 공백 제거
    [self.navigationItem setLeftBarButtonItems:@[navLeftPadding,settingBarBtn]];
    
    {
        textfield = [[UITextField alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, SEARCH_BAR_HEIGHT)];
        textfield.backgroundColor = [UIColor clearColor];
        textfield.layer.cornerRadius = 2.f;
        textfield.clearButtonMode = UITextFieldViewModeAlways;
        textfield.textColor = [UIColor grayColor];
        textfield.text = PLACE_HOLDER;
        textfield.delegate = self;
        self.navigationItem.titleView = textfield;
    }
    
}

-(void)popViewController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSMutableArray * current = tableDatas[section];
    return current.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"FeedCell";
    NSMutableArray * current = tableDatas[indexPath.section];
    
    FeedCell *cell = (FeedCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil){

        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"FeedCell" owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
    }
    DinnerDay * temp = [current objectAtIndex:indexPath.row];
    temp.thumbnail = [dbManager thumbNailWithString:temp.dayStr];
    [cell bindDiiner:temp];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return tableDatas.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    headerLabel.backgroundColor = [DinnerUtility mainbackgroundColor];
    headerLabel.textColor = [UIColor lightGrayColor];

    headerLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    headerLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:11];
    NSArray * temp = tableDatas[section];
    DinnerDay * firstDinner = temp.firstObject;
    headerLabel.text = [NSString stringWithFormat:@"     %@",[firstDinner.dayStr substringWithRange:NSMakeRange(0, 7)]];
    return headerLabel;
}
#pragma mark - UITableViewDelegate

#pragma mark - UIScrollViewDelegate


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self topLoaderMover:scrollView.contentOffset.y];
     CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    NSLog(@"%lf , %lf",scrollView.contentOffset.y , maximumOffset);
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidChange:(UITextField *)textField{
    NSLog(@"text : %@", textField.text);

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textfield.text = @"";
    return YES;
}


-(BOOL)textFieldShouldClear:(UITextField *)textField{
    [textfield resignFirstResponder];
    return YES;
}


@end
