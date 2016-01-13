//
//  ScrollViewManager.m
//  dayBday
//
//  Created by LeeYoseob on 2015. 12. 4..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "ScrollViewManager.h"
#import "DinnerUtility.h"

@implementation ScrollViewManager{
    NSMutableArray * dinners;
    NSMutableArray * textViews;
    NSMutableDictionary * dataTable;
    CGPoint todayPos;
}
@synthesize viewController;
@synthesize container;


- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

-(id)initWithViewController:(DayBDayViewController *)vc{
    self = [super init];
    if(self){
        self.viewController = vc;
        textViews = [NSMutableArray new];
        dataTable = [NSMutableDictionary new];
    }
    return  self;
}

//prepare leftView

-(void)prepareWithLeftDay:(DinnerDay *)day{
    
}

//prepare rightView

-(void)prepareWithRightDay:(DinnerDay *)day{
    
}

-(void)DinnerDataBind:(NSArray * )dinnerDatas{
    dinners = [[NSMutableArray alloc]initWithArray:dinnerDatas];
    [self containerViewEstimateScrollView];
}

-(void)containerViewEstimateScrollView{
    container.delegate = self;
    container.contentOffset = CGPointMake(container.contentOffset.x, 0); // Prevent bug when contentOffset.y is negative
    CGFloat x = 0.f;
    CGFloat width = viewController.view.frame.size.width;
    CGFloat height = container.frame.size.height;
    
    container.contentSize = CGSizeMake(dinners.count * viewController.view.frame.size.width,
                                       container.contentSize.height);
    container.pagingEnabled = YES;
    
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * todayString = [formatter stringFromDate:[NSDate new]];
    NSDate * today = [formatter dateFromString:todayString];

    todayPos = CGPointZero;
    
    //create before today
    DinnerDay * dinner;
    int index = 0;
    int haveToday = false;
    while ((dinner = dinners[index++])) {
        NSDate * date = [formatter dateFromString:dinner.dayStr];
        float timeCondition = [date timeIntervalSinceDate:today];
        if (timeCondition == 0) {
            haveToday = true;
            todayPos = CGPointMake(x, 0);
        }else if(timeCondition > 0 ){
            index--;
            break;
        }
        x = [self makeContextWithDinnerData:dinner textViewFrame:CGRectMake(x, 0, width, height)];
        
        if( index == dinners.count){
            break;
        }
    }
    
    if(!haveToday){
        DinnerDay * todayDinner = [[DinnerDay alloc]init];
        todayDinner.dayStr= todayString;
        todayDinner.orignText = @"";
        todayPos = CGPointMake(x, 0);
        if(index == dinners.count){
            [dinners addObject:todayDinner];
        }else{
             [dinners insertObject:todayDinner atIndex:index];
        }

        x = [self makeContextWithDinnerData:todayDinner textViewFrame:CGRectMake(x, 0, width, height)];
        container.contentSize = CGSizeMake((dinners.count) * viewController.view.frame.size.width,
                                           container.contentSize.height);
        
        index++;
    }
    
    while (index < dinners.count && (dinner = dinners[index++])){
        x = [self makeContextWithDinnerData:dinner textViewFrame:CGRectMake(x, 0, width, height)];
    }
    
}


-(CGFloat)makeContextWithDinnerData:(DinnerDay *)dinner textViewFrame:(CGRect)frame{
    HPTextViewTapGestureRecognizer *textViewTapGestureRecognizer;
    UITextView * textView = [[UITextView alloc]initWithFrame:container.frame];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    textView.scrollEnabled = YES;
    textView.pagingEnabled = NO;
    textView.showsHorizontalScrollIndicator = YES;
    textView.editable = NO;
    textView.frame = frame;
    textView.backgroundColor = [UIColor whiteColor];
    textView.attributedText = [DinnerUtility attributeTextResizeStable:dinner.attrText withContainer:textView];
    [container addSubview:textView];
    [dataTable setObject:textView forKey:dinner.dayStr];
    [textViews addObject:textView];
    return CGRectGetMaxX(textView.frame);
}

-(void)changeContainerViewSize:(CGFloat)height{
    for(UIView * view in textViews){
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, height);
    }
}


-(void)visibleCurrentTextView:(NSDate*) selectedDay {
    NSString * key = [DinnerUtility DateToString:selectedDay];
    NSLog(@"%@ , %@" , dataTable[key] , key);
    UITextView * selectedView = dataTable[key];
    viewController.currentDayScollView = selectedView;
    [container setContentOffset:selectedView.frame.origin animated:YES];
}

-(void)visibleToday{
    [container setContentOffset:todayPos];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    int index =targetContentOffset->x/scrollView.frame.size.width;
    NSLog(@"%f %f",targetContentOffset->x , targetContentOffset->y);

    DinnerDay * d = dinners[index];
    [viewController changetScollerSelectedDay:[DinnerUtility StringToDate:d.dayStr]];
}

@end
