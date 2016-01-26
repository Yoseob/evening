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
    NSMutableArray * loadedDinners;
    NSMutableArray * textViews;
    NSMutableDictionary * dataTable; //textView 를 저장함.
    CGPoint todayPos;
    DinnerDay * nextDinner;
    NSDateFormatter * formatter;

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
        currentIndex = 0;
        dataTable = [[DataBaseManager getDefaultDataBaseManager]dinnerWithViewTable];
        loadedDinners = [NSMutableArray new];
        formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return  self;
}

//prepare leftView

-(void)prepareWithLeftDay:(DinnerDay *)day{
    [self prepareImpliment:day];
}

//prepare rightView
-(void)prepareWithRightDay:(DinnerDay *)day{
    [self prepareImpliment:day];
}

-(void)prepareImpliment:(DinnerDay*)day{
    if(day){
        if(dataTable[day.dayStr]  && day) {
            return;
        }
        NSDate * date = [DinnerUtility StringToDate:day.dayStr];
        [self insertWithDinner:day withDate:date];
    }
}

-(void)initialScrollViewWith:(NSDate *)today{
    DinnerDay * init = [[DataBaseManager getDefaultDataBaseManager]searchDataWithData:today];
    if(!init){
        init = [DinnerDay new];
    }
    [self insertWithDinner:init withDate:today];
    
    [self prepareWithLeftDay:init.left];
    [self prepareWithRightDay:init.right];
}



-(void)DinnerDataBind:(NSArray * )dinnerDatas{
    [self reloadData];
    [self reloadView];
}

//origin
-(void)containerViewEstimateScrollView{
    container.delegate = self;
//    [self imlpcontainerViewEstimateScrollView];
    [self reloadView];
}

-(void)insertDinnerAtArc:(DinnerDay *)newDinner withDate:(NSDate *)date{
    
    if (dataTable[newDinner.dayStr]) {
        return;
    }
    NSString * dateString = [formatter stringFromDate:date];
    NSDate * today = [formatter dateFromString:dateString];

    NSMutableArray * arc = [[DataBaseManager getDefaultDataBaseManager]dinnerDataArchive];

    DinnerDay * dinner;
    int index = 0;
    int haveToday = false;
    while ( arc.count > 0 && (dinner = arc[index++])) {
        NSDate * date = [formatter dateFromString:dinner.dayStr];
        float timeCondition = [date timeIntervalSinceDate:today];
        if(timeCondition > 0 ){
            index--;
            break;
        }
        if( index == arc.count) break;
    }
    
    if(!newDinner.attrText){
        newDinner.dayStr= dateString;
        newDinner.attrText = [[NSAttributedString alloc]initWithString:dateString];
    }
    
    if(!haveToday){
        if(index == arc.count){
            [arc addObject:newDinner];
        }else{
            [arc insertObject:newDinner atIndex:index];
        }
        index++;
    }
}


-(CGFloat)makeContextWithDinnerData:(DinnerDay *)dinner textViewFrame:(CGRect)frame{
    return [self makeContextWithDinnerData2:dinner textViewFrame:frame];
}

-(CGFloat)makeContextWithDinnerData2:(DinnerDay *)dinner textViewFrame:(CGRect)frame{
    
    ContainerScollView * containerScrollerView = nil;
    containerScrollerView  = dataTable[dinner.dayStr];
    DataBaseManager * dbManager = [DataBaseManager getDefaultDataBaseManager];
    NSAttributedString * attrString = [dbManager getImageInTheAttributeString:dinner.attrText cacheArr: nil Day:[DinnerUtility StringToDate:dinner.dayStr]];

    
    if(!containerScrollerView){
        containerScrollerView = [[ContainerScollView alloc]initWithFrame:frame];
        UITextView * textView = [[UITextView alloc]initWithFrame:frame];
        textView.translatesAutoresizingMaskIntoConstraints = NO;
        textView.scrollEnabled = YES;
        textView.pagingEnabled = NO;
        textView.showsHorizontalScrollIndicator = YES;
        textView.editable = NO;
        textView.backgroundColor = [UIColor whiteColor];
        textView.attributedText = [DinnerUtility attributeTextResizeStable:attrString withContainer:textView];
        [textView setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:14]];
        
        [containerScrollerView addTextView:textView];
        [dataTable setObject:containerScrollerView forKey:dinner.dayStr];
    }else{
        containerScrollerView.frame = frame;
    }
    
    [container addSubview:containerScrollerView];
    return CGRectGetMaxX(containerScrollerView.frame);
}
//이때 바꿔도 될듯. 버튼들을..
-(void)changeContainerViewSize:(CGFloat)height{
    for(ContainerScollView *view in dataTable.allValues){
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, height);
        view.textView.frame = CGRectMake(0, 0, view.frame.size.width, height);
    }

}

-(void)visibleCurrentTextView:(NSDate*) selectedDay withGesture:(HPTextViewTapGestureRecognizer *)ges{
    NSString * key = [DinnerUtility DateToString:selectedDay];
    
    ContainerScollView * view = dataTable[key];
    UITextView * selectedView = view.textView;
    [viewController setCurrentDayTextView:selectedView];
    [selectedView addGestureRecognizer:ges];
    [self impliVisible:view.frame.origin];
}

-(void)visibleCurrentTextView:(NSDate*) selectedDay {
    NSString * key = [DinnerUtility DateToString:selectedDay];
    ContainerScollView * view = dataTable[key];
    UITextView * selectedView = view.textView;
    [viewController setCurrentDayTextView:selectedView];
    [self impliVisible:view.frame.origin];
}

-(void)visibleToday{
    [container setContentOffset:todayPos];
}

-(void)impliVisible:(CGPoint)point{
    [container setContentOffset:point animated:NO];

}

-(DinnerDay *)dinnerDayWithIndex:(int)idx{
    DinnerDay * d = loadedDinners[idx];
    return dataTable[d.dayStr];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    float index = scrollView.contentOffset.x/scrollView.frame.size.width;
    currentIndex = index;
    NSLog(@"scrollViewWillBeginDragging : %lf %ld",scrollView.contentOffset.x/scrollView.frame.size.width,loadedDinners.count);
    DinnerDay * d = loadedDinners[currentIndex];
    [viewController.calendar currentDayViewWithDayString:d.dayStr];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = currentIndex;
    float fIndex = scrollView.contentOffset.x/scrollView.frame.size.width - currentIndex;
    if(!nextDinner){
        if(fIndex > 0.f && loadedDinners.count-1 > index){
            nextDinner = loadedDinners[index+1];
        }else if(fIndex < 0.f && index > 0){
            nextDinner = loadedDinners[index-1];
        }else{}
        [viewController.calendar nextDayViewDayWithDayString:nextDinner.dayStr];
    }else{
        fIndex = fabsf(fIndex);
        [viewController.calendar changingPercent:fIndex];
    }
    NSUInteger currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;

    [self posterImagePosition:currentPage point:scrollView.contentOffset];
    [self posterImagePosition:currentPage+1 point:scrollView.contentOffset];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndDecelerating");
    int index = scrollView.contentOffset.x/scrollView.frame.size.width;
    {
        DinnerDay * d = loadedDinners[index];
        ContainerScollView * view =dataTable[d.dayStr];
        {
            viewController.currentDayTextView = view.textView;
            [viewController changeScollerSelectedDay:[DinnerUtility StringToDate:d.dayStr] withSelectTextView:dataTable[d.dayStr]];
            [viewController.calendar selectedDayViewWithIndex:d.dayStr];
            nextDinner = nil; //never remove
        }
        [self prepareWithLeftDay:d.left];
        [self prepareWithRightDay:d.right];
        [self visibleCurrentTextView:[DinnerUtility StringToDate:d.dayStr]];
    }
}


- (void)posterImagePosition:(NSInteger)posterIndex point:(CGPoint)point
{
    if (posterIndex < 0 || posterIndex >= loadedDinners.count) {
        return; //페이지 수를 벗어난 것이면, 무시한다.
    }
    DinnerDay * d = loadedDinners[posterIndex];
    ContainerScollView *posterView = (ContainerScollView *)dataTable[d.dayStr];
    if (posterView == nil) return;
    [posterView moveViewPosition:point]; //각 포스터 뷰에서 내부 뷰를 이동시킨다.
}

-(void)insertNewTextView:(NSDate *)date{
    DinnerDay * init = [[DataBaseManager getDefaultDataBaseManager]searchDataWithData:date];
    if(!init){
        init = [DinnerDay new];
        init.left = init;
        init.right = init;
    }

    [self insertWithDinner:init withDate:date];
    [self prepareWithLeftDay:init.left];
    [self prepareWithRightDay:init.right];

}

-(void)insertWithDinner:(DinnerDay *)newDinner withDate:(NSDate *)date{
    
    if(!date && (!newDinner.left || !newDinner.right)) {
        return;
    }
    
    if (newDinner.left == newDinner) {
        newDinner.left = nil;
        newDinner.right = nil;
    }
    
    NSString * dateString = [formatter stringFromDate:date];
    NSDate * today = [formatter dateFromString:dateString];

    DinnerDay * dinner;
    int index = 0;
    int haveToday = false;
    while ( loadedDinners.count > 0 && (dinner = loadedDinners[index++])) {
        NSDate * date = [formatter dateFromString:dinner.dayStr];
        float timeCondition = [date timeIntervalSinceDate:today];
        if(timeCondition > 0 ){
            index--;
            break;
        }
        if( index == loadedDinners.count) break;
    }
    
    if(!newDinner.attrText){
        newDinner.dayStr= dateString;
        newDinner.attrText = [[NSAttributedString alloc]initWithString:dateString];
        [[DataBaseManager getDefaultDataBaseManager]achiveDinnerAtInnderDictionany:newDinner];
    }
    
    if(!haveToday){
        if(index == loadedDinners.count){
            [loadedDinners addObject:newDinner];
        }else{
            [loadedDinners insertObject:newDinner atIndex:index];
        }

    }
    [self insertDinnerAtArc:newDinner withDate:date];
    [self reloadView];



}

-(BOOL)ExistDinner:(NSDate *)date{
    NSString * key = [DinnerUtility DateToString:date];
    return dataTable[key];
}

-(void)removeDinnerData:(NSString *)dayStr{
    
    [dataTable removeObjectForKey:dayStr];
    for(DinnerDay * dinner in loadedDinners){
        if([dayStr isEqualToString:dinner.dayStr]){
            [loadedDinners removeObject:dinner];
            [self reloadView];
            return;
        }
    }
}

-(void)shiftTextViewRightWithId:(NSString *)textviewID{
    
}
-(void)reloadView{
    container.delegate = self;
//    container.contentOffset = CGPointMake(container.contentOffset.x, 0); // Prevent bug when contentOffset.y is negative
    CGFloat x = 0.f;
    CGFloat width = viewController.view.frame.size.width;
    CGFloat height = container.frame.size.height;
    
    container.contentSize = CGSizeMake(loadedDinners.count * viewController.view.frame.size.width,
                                       container.contentSize.height);
    container.pagingEnabled = YES;
    todayPos = CGPointZero;
    //create before today
    for(DinnerDay * dinner in loadedDinners){
        x = [self makeContextWithDinnerData:dinner textViewFrame:CGRectMake(x, 0, width, height)];
    }
}

-(void)reloadData{
//    loadedDinners = [[DataBaseManager getDefaultDataBaseManager]dinnerDataArchive];
}

@end
