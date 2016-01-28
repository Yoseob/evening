//
//  FeedCell.m
//  dayBday
//
//  Created by LeeYoseob on 2016. 1. 27..
//  Copyright © 2016년 LeeYoseob. All rights reserved.
//

#import "FeedCell.h"

@implementation FeedCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)bindDiiner:(DinnerDay *)dinner{
    self.SentaxField.text = dinner.orignText;
    
    self.SentaxField.textColor = [UIColor grayColor]; //[DinnerUtility mainbackgroundColor];
    if(dinner.thumbnail.image){
        self.thumbNail.image = dinner.thumbnail.image;
    }else{
        self.thumbNail.image = nil;
        self.thumbNail.backgroundColor = [UIColor clearColor];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    
    NSString * dayString = [dateFormatter stringFromDate:[DinnerUtility StringToDate:dinner.dayStr]];
    
    if(dayString.length > 3){
        dayString = [dayString substringWithRange:NSMakeRange(0, 3)];
        dayString = [dayString uppercaseString];
    }
    self.dayStringLabel.text = dayString;
    self.dayLabel.text = [dinner.dayStr substringWithRange:NSMakeRange(8, 2)];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
