//
//  JTCalendarDayView.h
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import <UIKit/UIKit.h>

#import "JTCalendar.h"
#import "DataBaseManager.h"
@interface JTCalendarDayView : UIView

@property (weak, nonatomic) JTCalendar *calendarManager;

@property (strong, nonatomic) NSDate *date;
@property (assign ,nonatomic) BOOL isHaveData;
@property (strong,nonatomic) Thumbnail * thumbnail;
@property (assign, nonatomic) BOOL isOtherMonth;
@property (strong,nonatomic) UIImageView * thumbnailImage;
- (void)reloadData;
- (void)reloadAppearance;

@end
