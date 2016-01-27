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
}
@synthesize searchTableView;

-(void)viewDidAppear:(BOOL)animated{
    
}
-(void)viewDidLoad{

    [super viewDidLoad];
    [self setupTableView];
    [self setupNavibar];
}

#pragma mark - SetupView

-(void)setupTableView{
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
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
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"FeedCell";
    
    FeedCell *cell = (FeedCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil){
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"FeedCell" owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    headerLabel.backgroundColor = [DinnerUtility mainbackgroundColor];
    headerLabel.textColor = [UIColor lightGrayColor];

    headerLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    headerLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:11];
    headerLabel.text = [NSString stringWithFormat:@"     %@",[NSDate new]];
    return headerLabel;
}
#pragma mark - UITableViewDelegate

#pragma mark - UITextFieldDelegate



@end
