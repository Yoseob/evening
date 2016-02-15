//
//  JTCalendar.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendar.h"
#import "DinnerUtility.h"
#define NUMBER_PAGES_LOADED 5 // Must be the same in JTCalendarView, JTCalendarMenuView, JTCalendarContentView

@interface JTCalendar(){
    BOOL cacheLastWeekMode;
    NSUInteger cacheFirstWeekDay;
    JTCalendarDayView * preDayView , *currentDayView , *nextDayView;
    
    
}

@end

@implementation JTCalendar



+(id)getDefaultJTCalendar{
    static JTCalendar * obj = nil;
    if(obj == nil){
        obj = [[JTCalendar alloc]init];
        
    }
    return obj;
}



- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    self->_currentDate = [NSDate date];
    self->_calendarAppearance = [JTCalendarAppearance new];
    self->_dataCache = [JTCalendarDataCache new];
    self.dataCache.calendarManager = self;

    return self;
}

// Bug in iOS
- (void)dealloc
{
    [self->_menuMonthsView setDelegate:nil];
    [self->_contentView setDelegate:nil];
}

- (void)setMenuMonthsView:(JTCalendarMenuView *)menuMonthsView
{
    
    self->_menuMonthsView = menuMonthsView;
    [self->_menuMonthsView setDelegate:self];
    [self->_menuMonthsView setCalendarManager:self];
    cacheLastWeekMode = self.calendarAppearance.isWeekMode;
    cacheFirstWeekDay = self.calendarAppearance.calendar.firstWeekday;
    
    [self.menuMonthsView setCurrentDate:self.currentDate];
    [self.menuMonthsView reloadAppearance];
}

- (void)setContentView:(JTCalendarContentView *)contentView
{
    
    self->_contentView = contentView;
    [self->_contentView setDelegate:self];
    [self->_contentView setCalendarManager:self];
    [self.contentView setCurrentDate:self.currentDate];
    [self.contentView reloadAppearance];
}

- (void)reloadData
{
    // Erase cache
    [self.dataCache reloadData];
    
    [self repositionViews];
    [self.contentView reloadData];
}

- (void)reloadAppearance
{
    [self.menuMonthsView reloadAppearance];
    [self.contentView reloadAppearance];
    
    if(cacheLastWeekMode != self.calendarAppearance.isWeekMode || cacheFirstWeekDay != self.calendarAppearance.calendar.firstWeekday){
        cacheLastWeekMode = self.calendarAppearance.isWeekMode;
        cacheFirstWeekDay = self.calendarAppearance.calendar.firstWeekday;
        
        if(self.calendarAppearance.focusSelectedDayChangeMode && self.currentDateSelected){
            [self setCurrentDate:self.currentDateSelected];
        }
        else{
            [self setCurrentDate:self.currentDate];
        }
    }
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    NSAssert(currentDate, @"JTCalendar currentDate cannot be null");
    [self.delegate currentMonth:currentDate];
    
    self->_currentDate = currentDate;
    [self.menuMonthsView setCurrentDate:currentDate];
    [self.contentView setCurrentDate:currentDate];
    
    [self repositionViews];
    [self.contentView reloadData];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{

    if(self.calendarAppearance.isWeekMode){
        return;
    }
    
    CGFloat ratio = CGRectGetWidth(self.contentView.frame) / CGRectGetWidth(self.menuMonthsView.frame);
    if(isnan(ratio)){
        ratio = 1.;
    }
    ratio *= self.calendarAppearance.ratioContentMenu;
    
    if(sender == self.menuMonthsView && self.menuMonthsView.scrollEnabled){
        self.contentView.contentOffset = CGPointMake(sender.contentOffset.x * ratio, self.contentView.contentOffset.y);
    }
    else if(sender == self.contentView && self.contentView.scrollEnabled){

//        self.menuMonthsView.contentOffset = CGPointMake(sender.contentOffset.x / ratio, self.menuMonthsView.contentOffset.y);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView == self.contentView){
        self.menuMonthsView.scrollEnabled = NO;
    }
    else if(scrollView == self.menuMonthsView){
        self.contentView.scrollEnabled = NO;
    }
}

// Use for scroll with scrollRectToVisible or setContentOffset
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updatePage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePage];
}

- (void)updatePage
{
    CGFloat pageWidth = CGRectGetWidth(self.contentView.frame);
    CGFloat fractionalPage = self.contentView.contentOffset.x / pageWidth;
        
    int currentPage = roundf(fractionalPage);
    if (currentPage == (NUMBER_PAGES_LOADED / 2)){
        if(!self.calendarAppearance.isWeekMode){
//            self.menuMonthsView.scrollEnabled = YES;
        }
        self.contentView.scrollEnabled = YES;
        return;
    }
    
    NSCalendar *calendar = self.calendarAppearance.calendar;
    NSDateComponents *dayComponent = [NSDateComponents new];
    
    dayComponent.month = 0;
    dayComponent.day = 0;
    
    if(!self.calendarAppearance.isWeekMode){
        dayComponent.month = currentPage - (NUMBER_PAGES_LOADED / 2);
    }
    else{
        dayComponent.day = 7 * (currentPage - (NUMBER_PAGES_LOADED / 2));
    }
    
    if(self.calendarAppearance.readFromRightToLeft){
        dayComponent.month *= -1;
        dayComponent.day *= -1;
    }
        
    NSDate *currentDate = [calendar dateByAddingComponents:dayComponent toDate:self.currentDate options:0];
    [self setCurrentDate:currentDate];
    
    if(!self.calendarAppearance.isWeekMode){
//        self.menuMonthsView.scrollEnabled = YES;
    }
    self.contentView.scrollEnabled = YES;
    
    if(currentPage < (NUMBER_PAGES_LOADED / 2)){
        if([self.dataSource respondsToSelector:@selector(calendarDidLoadPreviousPage)]){
            [self.dataSource calendarDidLoadPreviousPage];
        }
    }
    else if(currentPage > (NUMBER_PAGES_LOADED / 2)){
        if([self.dataSource respondsToSelector:@selector(calendarDidLoadNextPage)]){
            [self.dataSource calendarDidLoadNextPage];
        }
    }
}

- (void)repositionViews
{
    // Position to the middle page
    CGFloat pageWidth = CGRectGetWidth(self.contentView.frame);
    self.contentView.contentOffset = CGPointMake(pageWidth * ((NUMBER_PAGES_LOADED / 2)), self.contentView.contentOffset.y);
    
    CGFloat menuPageWidth = CGRectGetWidth([self.menuMonthsView.subviews.firstObject frame]);
    self.menuMonthsView.contentOffset = CGPointMake(menuPageWidth * ((NUMBER_PAGES_LOADED / 2)), self.menuMonthsView.contentOffset.y);
}

- (void)loadNextMonth
{
    [self loadNextPage];
}

- (void)loadPreviousMonth
{
    [self loadPreviousPage];
}

- (void)loadNextPage
{
    self.menuMonthsView.scrollEnabled = NO;
    
    CGRect frame = self.contentView.frame;
    frame.origin.x = frame.size.width * ((NUMBER_PAGES_LOADED / 2) + 1);
    frame.origin.y = 0;
    [self.contentView scrollRectToVisible:frame animated:YES];
}

- (void)loadPreviousPage
{
    self.menuMonthsView.scrollEnabled = NO;
    CGRect frame = self.contentView.frame;
    frame.origin.x = frame.size.width * ((NUMBER_PAGES_LOADED / 2) - 1);
    frame.origin.y = 0;
    [self.contentView scrollRectToVisible:frame animated:YES];
}

-(void)selectedDayView:(id)view{
    JTCalendarDayView * targetView =(JTCalendarDayView*)view;
//    targetView.backgroundColor = [UIColor colorWithRed:0x33/256. green:0xB3/256. blue:0xEC/256. alpha:1.f];
    [self selectedDayViewWithIndex:[DinnerUtility DateToString:targetView.date]];
}

-(void)selectedDayViewWithIndex:(NSString *)dayStr{
//    nextDayView = (JTCalendarDayView*)[self.dataCache getDayViewWtihIndex:dayStr];
//    nextDayView.backgroundColor = [UIColor whiteColor];
    
    NSMutableDictionary * dic = [[DataBaseManager getDefaultDataBaseManager]calendarDayViewArchive];
    for (NSString * key in dic.allKeys ){
        JTCalendarDayView * temp = dic[key];
        if([key isEqualToString:dayStr]){
            temp.layer.borderWidth = 1.0f;
            temp.layer.borderColor = [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:1.f].CGColor;
        }else{
            temp.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
}

-(void)currentDayViewWithDayString:(NSString *)dayStr{
    currentDayView = (JTCalendarDayView*)[self.dataCache getDayViewWtihIndex:dayStr];
    currentDayView.layer.borderWidth = 1.f;
}

-(void)nextDayViewDayWithDayString:(NSString *)dayStr{
    nextDayView = (JTCalendarDayView*)[self.dataCache getDayViewWtihIndex:dayStr];
    nextDayView.layer.borderWidth = 1.f;
}

-(void)changingPercent:(float)alhpa{

    currentDayView.layer.borderColor = [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:1-alhpa].CGColor;
    nextDayView.layer.borderColor = [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:alhpa].CGColor;
}

@end
