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
    NSMutableDictionary * textViewTable;
    CGPoint todayPos;
    DinnerDay * nextDinner;
    
    int currentIndex;
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
        textViewTable = [NSMutableDictionary new];
        dataTable = [[DataBaseManager getDefaultDataBaseManager]dinnerWithViewTable];
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
    [self reloadData];
    [self reloadView];
}

//origin
-(void)containerViewEstimateScrollView{
    container.delegate = self;
    [self containerViewEstimateScrollView2];
    [self reloadView];
}

-(void)containerViewEstimateScrollView2{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * todayString = [formatter stringFromDate:[NSDate new]];
    NSDate * today = [formatter dateFromString:todayString];
    
    todayPos = CGPointZero;
    
    //create before today
    DinnerDay * dinner;
    int index = 0;
    int haveToday = false;
    while (dinners.count > 0 && (dinner = dinners[index++]) ) {
        NSDate * date = [formatter dateFromString:dinner.dayStr];
        float timeCondition = [date timeIntervalSinceDate:today];
        if (timeCondition == 0) {
            haveToday = true;
        }else if(timeCondition > 0 ){
            index--;
            break;
        }

        if( index == dinners.count) break;
    }
    
    if(!haveToday){
        DinnerDay * todayDinner = [[DinnerDay alloc]init];
        todayDinner.dayStr= todayString;
        todayDinner.attrText = [[NSAttributedString alloc]initWithString:@"Today"];
        if(index == dinners.count){
            [dinners addObject:todayDinner];
        }else{
            [dinners insertObject:todayDinner atIndex:index];
        }
        index++;
    }
}


-(CGFloat)makeContextWithDinnerData:(DinnerDay *)dinner textViewFrame:(CGRect)frame{
    UITextView * textView = nil;
    textView  = dataTable[dinner.dayStr];
    if(!textView){
        textView = [[UITextView alloc]initWithFrame:container.frame];
        textView.translatesAutoresizingMaskIntoConstraints = NO;
        textView.scrollEnabled = YES;
        textView.pagingEnabled = NO;
        textView.showsHorizontalScrollIndicator = YES;
        textView.editable = NO;
        textView.frame = frame;
        textView.backgroundColor = [UIColor whiteColor];
        textView.attributedText = [DinnerUtility attributeTextResizeStable:dinner.attrText withContainer:textView];
        [dataTable setObject:textView forKey:dinner.dayStr];
    }else{
        textView.frame = frame;
    }
    
    [container addSubview:textView];



    return CGRectGetMaxX(textView.frame);
}

//이때 바꿔도 될듯. 버튼들을..
-(void)changeContainerViewSize:(CGFloat)height{
    for(UITextView *view in dataTable.allValues){
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, height);
    }
}

-(void)visibleCurrentTextView:(NSDate*) selectedDay withGesture:(HPTextViewTapGestureRecognizer *)ges{
    NSString * key = [DinnerUtility DateToString:selectedDay];
    UITextView * selectedView = dataTable[key];
    [selectedView addGestureRecognizer:ges];
    [self impliVisible:selectedView];
}

-(void)visibleCurrentTextView:(NSDate*) selectedDay {
    NSString * key = [DinnerUtility DateToString:selectedDay];
    UITextView * selectedView = dataTable[key];
    [self impliVisible:selectedView];
}

-(void)visibleToday{
    [container setContentOffset:todayPos];
}

-(void)impliVisible:(UITextView *)selectedView{
    [container setContentOffset:selectedView.frame.origin animated:NO];
    [viewController setCurrentDayTextView:selectedView];
}

-(DinnerDay *)dinnerDayWithIndex:(int)idx{
    DinnerDay * d = dinners[idx];
    return dataTable[d.dayStr];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    float index = scrollView.contentOffset.x/scrollView.frame.size.width;
    currentIndex = index;
    NSLog(@"scrollViewWillBeginDragging : %lf %ld",scrollView.contentOffset.x/scrollView.frame.size.width,dinners.count);
    DinnerDay * d = dinners[currentIndex];
    [viewController.calendar currentDayViewWithDayString:d.dayStr];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = currentIndex;
    float fIndex = scrollView.contentOffset.x/scrollView.frame.size.width - currentIndex;
    if(!nextDinner){
        if(fIndex > 0.f && dinners.count-1 > index){
            nextDinner = dinners[index+1];
        }else if(fIndex < 0.f && index > 0){
            nextDinner = dinners[index-1];
        }else{}
        [viewController.calendar nextDayViewDayWithDayString:nextDinner.dayStr];
    }else{
        fIndex = fabsf(fIndex);
        if(fIndex == 1.0f){
//            [viewController changeScollerSelectedDay:[DinnerUtility StringToDate:nextDinner.dayStr] withSelectTextView:dataTable[nextDinner.dayStr]];
        }
        [viewController.calendar changingPercent:fIndex];
    }
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{

    /*
    int index = targetContentOffset->x/scrollView.frame.size.width;
    DinnerDay * d = dinners[index];
    viewController.currentDayTextView = dataTable[d.dayStr];
    [viewController changeScollerSelectedDay:[DinnerUtility StringToDate:d.dayStr] withSelectTextView:dataTable[d.dayStr]];
    [viewController.calendar selectedDayViewWithIndex:d.dayStr];
     */
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewWillEndDragging : %lf",scrollView.contentOffset.x/scrollView.frame.size.width);
    int index = scrollView.contentOffset.x/scrollView.frame.size.width;
    NSLog(@"%d",index);
    DinnerDay * d = dinners[index];
    nextDinner = nil;
    viewController.currentDayTextView = dataTable[d.dayStr];
    [viewController changeScollerSelectedDay:[DinnerUtility StringToDate:d.dayStr] withSelectTextView:dataTable[d.dayStr]];
    [viewController.calendar selectedDayViewWithIndex:d.dayStr];



}

-(void)insertNewTextView:(NSDate *)date{
    NSLog(@"insertNewTextView");
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * dateString = [formatter stringFromDate:date];
    NSDate * today = [formatter dateFromString:dateString];

    DinnerDay * dinner;
    int index = 0;
    int haveToday = false;
    while ( dinners.count > 0 && (dinner = dinners[index++])) {
        NSDate * date = [formatter dateFromString:dinner.dayStr];
        float timeCondition = [date timeIntervalSinceDate:today];
        if(timeCondition > 0 ){
            index--;
            break;
        }
        if( index == dinners.count) break;
    }
    
    if(!haveToday){
        DinnerDay * newDinner = [[DinnerDay alloc]init];
        newDinner.dayStr= dateString;
        newDinner.attrText = [[NSAttributedString alloc]initWithString:dateString];

        if(index == dinners.count){
            [dinners addObject:newDinner];
        }else{
            [dinners insertObject:newDinner atIndex:index];
        }
        index++;
    }
    [self reloadView];
    NSLog(@"insertNewTextView end");
}

-(void)removeDinnerData:(NSString *)dayStr{
    [dataTable removeObjectForKey:dayStr];
    for(DinnerDay * dinner in dinners){
        if([dayStr isEqualToString:dinner.dayStr]){
            [dinners removeObject:dinner];
            [self reloadView];
            return;
        }
    }

}

-(void)shiftTextViewRightWithId:(NSString *)textviewID{
    
}
-(void)reloadView{

    container.delegate = self;
    container.contentOffset = CGPointMake(container.contentOffset.x, 0); // Prevent bug when contentOffset.y is negative
    CGFloat x = 0.f;
    CGFloat width = viewController.view.frame.size.width;
    CGFloat height = container.frame.size.height;
    
    container.contentSize = CGSizeMake(dinners.count * viewController.view.frame.size.width,
                                       container.contentSize.height);
    container.pagingEnabled = YES;
    
    todayPos = CGPointZero;
    
    //create before today
    for(DinnerDay * dinner in dinners){
        x = [self makeContextWithDinnerData:dinner textViewFrame:CGRectMake(x, 0, width, height)];
    }
}

-(void)reloadData{
    
    [[DataBaseManager getDefaultDataBaseManager]prepareAllOfDinnerData];
    dinners = [[DataBaseManager getDefaultDataBaseManager]dinnerDataArchive];
}

@end
