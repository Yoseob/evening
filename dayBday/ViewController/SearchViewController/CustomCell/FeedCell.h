//
//  FeedCell.h
//  dayBday
//
//  Created by LeeYoseob on 2016. 1. 27..
//  Copyright © 2016년 LeeYoseob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DinnerDay.h"
#import "DinnerUtility.h"
@interface FeedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *SentaxField;
@property (weak, nonatomic) IBOutlet UIImageView *thumbNail;
@property (weak, nonatomic) IBOutlet UILabel *dayStringLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlyTextLabel;

-(void)bindDinner:(DinnerDay *)dinner andThumbnail:(Thumbnail * )image;

@end
