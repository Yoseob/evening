//
//  JTCalendarDayView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarDayView.h"
#import "JTCircleView.h"
#import "DataBaseManager.h"

@interface JTCalendarDayView (){
    UIView *backgroundView;
//    UIImageView * thumbnailImage;
    UILabel *textLabel, *bottomLineView;
    UIView * underBar;
    BOOL isSelected;
    
    int cacheIsToday;
    NSString *cacheCurrentDateText;
}

@end

static NSString *const kJTCalendarDaySelected = @"kJTCalendarDaySelected";

@implementation JTCalendarDayView
@synthesize thumbnailImage;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

- (void)commonInit
{
    
    
   
    isSelected = NO;
    self.isOtherMonth = NO;

    {
        backgroundView = [UIView new];
        [self addSubview:backgroundView];
    }
    
    {
        thumbnailImage = [UIImageView new];
        [self addSubview:thumbnailImage];
    }
    
    {
        textLabel = [UILabel new];
        [self addSubview:textLabel];
    }
    
    {
        bottomLineView = [UILabel new];

        [self addSubview:bottomLineView];
    }
    

    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)];

        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:gesture];
    }
    
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDaySelected:) name:kJTCalendarDaySelected object:nil];
    }
}

- (void)layoutSubviews
{
    [self configureConstraintsForSubviews];
    
    // No need to call [super layoutSubviews]
}

// Avoid to calcul constraints (very expensive)
- (void)configureConstraintsForSubviews
{
    textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    CGFloat top_Left_Margin = 1;
    thumbnailImage.frame = CGRectMake(top_Left_Margin,
                                      top_Left_Margin,
                                      self.frame.size.width-(top_Left_Margin * 1),
                                      self.frame.size.height-(top_Left_Margin * 1));
    
    thumbnailImage.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    CGFloat x = self.frame.size.width/2;
    bottomLineView.frame = CGRectMake(x - 10 , self.frame.size.height - 10, 20, 1.8);
    bottomLineView.backgroundColor = [UIColor clearColor];

    bottomLineView.font = [UIFont systemFontOfSize:10];
    bottomLineView.layer.cornerRadius = 10.f;
    bottomLineView.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    bottomLineView.textAlignment = NSTextAlignmentCenter;
}

- (void)setDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
        [dateFormatter setDateFormat:self.calendarManager.calendarAppearance.dayFormat];
    }
    
    self->_date = date;
    textLabel.text = [dateFormatter stringFromDate:date];
    cacheIsToday = -1;
    cacheCurrentDateText = nil;
    

}

- (void)didTouch
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kJTCalendarDaySelected object:self.date];
    
    [self.calendarManager.dataSource calendarDidDateSelected:self.calendarManager date:self.date];
    [self.calendarManager setCurrentDateSelected:self.date];
    [self.calendarManager selectedDayView:self];

    
    JTCircleView * circleView = [JTCircleView new];
    [self addSubview:circleView];
    
    /*
    CGFloat sizeCircle = MIN(self.frame.size.width, self.frame.size.height);
    sizeCircle = sizeCircle * self.calendarManager.calendarAppearance.dayCircleRatio;
    sizeCircle = roundf(sizeCircle);
    circleView.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    circleView.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    circleView.layer.cornerRadius = sizeCircle / 2.;
    circleView.color = [UIColor whiteColor];
    
    CGFloat opacity = 1.;
    [UIView animateWithDuration:0.1 animations:^{
        circleView.layer.opacity = opacity;
        circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            circleView.layer.opacity = opacity;
            circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        }completion:^(BOOL finished) {
            circleView.hidden = YES;
        }];

    }];
     */
    
    if(!self.isOtherMonth || !self.calendarManager.calendarAppearance.autoChangeMonth){
        return;
    }
    
    NSInteger currentMonthIndex = [self monthIndexForDate:self.date];
    NSInteger calendarMonthIndex = [self monthIndexForDate:self.calendarManager.currentDate];
        
    currentMonthIndex = currentMonthIndex % 12;
    
    if(currentMonthIndex == (calendarMonthIndex + 1) % 12){
        [self.calendarManager loadNextPage];
    }
    else if(currentMonthIndex == (calendarMonthIndex + 12 - 1) % 12){
        [self.calendarManager loadPreviousPage];
    }
}

- (void)didDaySelected:(NSNotification *)notification
{
    NSDate *dateSelected = [notification object];
    
    if([self isSameDate:dateSelected]){
        if(!isSelected){
            [self setSelected:YES animated:YES];
        }
    }
    else if(isSelected){
        [self setSelected:NO animated:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

    if(isSelected == selected){
        animated = NO;
    }

    isSelected = selected;

    
}

- (void)setIsOtherMonth:(BOOL)isOtherMonth
{
    self->_isOtherMonth = isOtherMonth;
//    [self setSelected:isSelected animated:NO];
}

- (void)reloadData
{

    if(!self.isOtherMonth){
        textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColor];
    }
    else{
        textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorOtherMonth];
    }
    if([self isToday]){
        textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorToday];
        bottomLineView.backgroundColor = [self.calendarManager.calendarAppearance dayTextColorToday];
    }else {
        bottomLineView.backgroundColor = [UIColor clearColor];
    }

    thumbnailImage.image = self.thumbnail.image;

    if (thumbnailImage.image == nil && self.isHaveData){
        thumbnailImage.backgroundColor = [UIColor whiteColor];
    }else if(thumbnailImage.image){
        thumbnailImage.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
    }else{
        thumbnailImage.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    
//
//    BOOL selected = [self isSameDate:[self.calendarManager currentDateSelected]];
//    [self setSelected:selected animated:NO];
}

- (BOOL)isToday
{
    if(cacheIsToday == 0){
        return NO;
    }
    else if(cacheIsToday == 1){
        return YES;
    }
    else{
        if([self isSameDate:[NSDate date]]){
            cacheIsToday = 1;
            return YES;
        }
        else{
            cacheIsToday = 0;
            return NO;
        }
    }
}

- (BOOL)isSameDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    }
    
    if(!cacheCurrentDateText){
        cacheCurrentDateText = [dateFormatter stringFromDate:self.date];
    }
    
 
    NSString *dateText2 = [dateFormatter stringFromDate:date];
    
    if ([cacheCurrentDateText isEqualToString:dateText2]) {
        return YES;
    }
    
    return NO;
}

- (NSInteger)monthIndexForDate:(NSDate *)date
{
    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    NSDateComponents *comps = [calendar components:NSCalendarUnitMonth fromDate:date];
    return comps.month;
}

- (void)reloadAppearance
{

    textLabel.textAlignment = NSTextAlignmentCenter;
    bottomLineView.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:13];//
    //HelveticaNeue-Thin , HelveticaNeue-Light
    backgroundView.backgroundColor = self.calendarManager.calendarAppearance.dayBackgroundColor;
    backgroundView.layer.borderWidth = self.calendarManager.calendarAppearance.dayBorderWidth;
    backgroundView.layer.borderColor = self.calendarManager.calendarAppearance.dayBorderColor.CGColor;
    
//    [self configureConstraintsForSubviews];
//    [self setSelected:isSelected animated:NO];
}

@end
