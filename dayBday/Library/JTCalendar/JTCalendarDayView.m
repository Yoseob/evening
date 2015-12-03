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
    UIImageView * thumbnailImage;
    UIImage * tImage;
    UILabel *textLabel, *taskLabel;
    UIView * underBar;
    BOOL isSelected;
    
    int cacheIsToday;
    NSString *cacheCurrentDateText;
}
@end

static NSString *const kJTCalendarDaySelected = @"kJTCalendarDaySelected";

@implementation JTCalendarDayView

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
        taskLabel = [UILabel new];

        [self addSubview:taskLabel];
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


    CGFloat sizeCircle = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat sizeDot = sizeCircle;
    
    sizeCircle = sizeCircle * self.calendarManager.calendarAppearance.dayCircleRatio;
    sizeDot = sizeDot * self.calendarManager.calendarAppearance.dayDotRatio;
    
    sizeCircle = roundf(sizeCircle);
    sizeDot = roundf(sizeDot);
    
    CGFloat top_Left_Margin = 1;
    thumbnailImage.frame = CGRectMake(top_Left_Margin, top_Left_Margin, self.frame.size.width-top_Left_Margin*2, self.frame.size.height-(top_Left_Margin *2));
    thumbnailImage.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    

    CGFloat x = self.frame.size.width/2;
    taskLabel.frame = CGRectMake(x - 10 , self.frame.size.height - 10, 20, 1.8);
    taskLabel.backgroundColor = [UIColor clearColor];

    taskLabel.font = [UIFont systemFontOfSize:10];
    taskLabel.layer.cornerRadius = 10.f;
    taskLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    taskLabel.textAlignment = NSTextAlignmentCenter;
    
    
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
    [self setSelected:YES animated:YES];
    [self.calendarManager setCurrentDateSelected:self.date];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kJTCalendarDaySelected object:self.date];
    
    [self.calendarManager.dataSource calendarDidDateSelected:self.calendarManager date:self.date];
    
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
    
    if(selected){
        if(!self.isOtherMonth){

//            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorSelected];
            self.layer.borderWidth = 1.f;
            self.layer.borderColor = [self.calendarManager.calendarAppearance dayCircleColorToday].CGColor;
            taskLabel.backgroundColor = [UIColor clearColor];
            taskLabel.textColor = [UIColor blackColor];
            taskLabel.text = @"";

        }
        else{

            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorSelectedOtherMonth];
            self.layer.borderWidth = 0.f;
            thumbnailImage.image = nil;
            taskLabel.backgroundColor = [UIColor clearColor];
            taskLabel.textColor = [UIColor blackColor];
          
        }
    
    }
    else if([self isToday]){
        if(!self.isOtherMonth){
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorToday];
            taskLabel.backgroundColor = [UIColor redColor];

            taskLabel.textColor = [UIColor whiteColor];
            self.layer.borderWidth = 0.f;

        }
        else{
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorTodayOtherMonth];
            self.layer.borderWidth = 0.f;
            taskLabel.backgroundColor = [UIColor clearColor];
            taskLabel.textColor = [UIColor blackColor];
            taskLabel.text = @"";
        }
    }else if(tImage){
        if(!self.isOtherMonth){
            textLabel.textColor = [UIColor whiteColor];//[self.calendarManager.calendarAppearance dayTextColorToday];
            taskLabel.text = @"";
            taskLabel.textColor = [UIColor whiteColor];
            self.layer.borderWidth = 0.f;
            
        }
        else{
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorTodayOtherMonth];
            self.layer.borderWidth = 0.f;
            taskLabel.backgroundColor = [UIColor clearColor];
            taskLabel.textColor = [UIColor blackColor];
            taskLabel.text = @"";
        }

    }else {
        if(!self.isOtherMonth){
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColor];
            self.layer.borderWidth = 0.f;
            taskLabel.backgroundColor = [UIColor clearColor];
            taskLabel.textColor = [UIColor blackColor];
            taskLabel.text = @"";
            
        }
        else{
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorOtherMonth];
            self.layer.borderWidth = 0.f;
            taskLabel.backgroundColor = [UIColor clearColor];
            taskLabel.textColor = [UIColor blackColor];
            taskLabel.text = @"";
        }
    }
}

- (void)setIsOtherMonth:(BOOL)isOtherMonth
{
    self->_isOtherMonth = isOtherMonth;
    [self setSelected:isSelected animated:NO];
}

- (void)reloadData
{

    thumbnailImage.image = nil;
    tImage = nil;
    Thumbnail * thumbnail = [self.calendarManager.dataCache haveEvent:self.date];
    thumbnailImage.image = thumbnail.image;
    
    BOOL selected = [self isSameDate:[self.calendarManager currentDateSelected]];
    [self setSelected:selected animated:NO];
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
    taskLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:13];//
    //HelveticaNeue-Thin , HelveticaNeue-Light
    backgroundView.backgroundColor = self.calendarManager.calendarAppearance.dayBackgroundColor;
    backgroundView.layer.borderWidth = self.calendarManager.calendarAppearance.dayBorderWidth;
    backgroundView.layer.borderColor = self.calendarManager.calendarAppearance.dayBorderColor.CGColor;
    
    [self configureConstraintsForSubviews];
    [self setSelected:isSelected animated:NO];
}

@end
