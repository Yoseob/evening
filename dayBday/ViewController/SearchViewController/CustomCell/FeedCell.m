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

-(void)bindDinner:(DinnerDay *)dinner andThumbnail:(Thumbnail * )image;{
    
    UILabel * currentField = self.SentaxField;

    self.dayStringLabel.textColor = [UIColor grayColor]; //[DinnerUtility mainbackgroundColor];
    dinner.thumbnail = image;
    
    if(dinner.thumbnail.image){
        self.thumbNail.hidden = NO;
        self.SentaxField.hidden = NO;
        self.thumbNail.image = dinner.thumbnail.image;
        self.onlyTextLabel.hidden = YES;
    }else{
        self.thumbNail.image = nil;
        self.thumbNail.backgroundColor = [UIColor clearColor];
        self.thumbNail.hidden = YES;
        self.SentaxField.hidden = YES;
        self.onlyTextLabel.hidden = NO;
        currentField = self.onlyTextLabel;
        
    }
    
    currentField.text = dinner.orignText;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE / MMMM dd / YYYY"];
    
    NSString * dayString = [dateFormatter stringFromDate:[DinnerUtility StringToDate:dinner.dayStr]];
    
    self.dayStringLabel.text = dayString;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
