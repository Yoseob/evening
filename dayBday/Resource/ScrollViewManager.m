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
    NSArray * dinners;
    NSMutableArray * textViews;
    NSMutableDictionary * dataTable;
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
    dinners = dinnerDatas;
    if(dinners.count > 0){

        [self containerViewEstimateScrollView];
    }

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
    
    
    for(DinnerDay * dinner in dinners){

        UITextView * textView = [[UITextView alloc]initWithFrame:container.frame];
        textView.translatesAutoresizingMaskIntoConstraints = NO;
        textView.scrollEnabled = YES;
        textView.pagingEnabled = NO;
        textView.showsHorizontalScrollIndicator = YES;
        textView.editable = NO;
        textView.frame = CGRectMake(x, 0, width, height);
        textView.backgroundColor = [UIColor whiteColor];
        textView.attributedText = [DinnerUtility attributeTextResizeStable:dinner.attrText withContainer:textView];
        [container addSubview:textView];
        [dataTable setObject:textView forKey:dinner.dayStr];
        
        x = CGRectGetMaxX(textView.frame);
        [textViews addObject:textView];
    }
    
    
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

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    int index =scrollView.contentOffset.x/scrollView.frame.size.width;
    DinnerDay * d = dinners[index];
    [viewController changetScollerSelectedDay:[DinnerUtility StringToDate:d.dayStr]];
    NSLog(@"%d , %@",index,[DinnerUtility StringToDate:d.dayStr]);
}
@end
