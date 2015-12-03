//
//  Thumbnail.h
//  dayBday
//
//  Created by LeeYoseob on 2015. 12. 3..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "DataBaseAccessObject.h"
#import "Thumbnail.h"
@interface ThumbnailDao  : DataBaseAccessObject
+(id)getDefaultThumbnailDao;


-(void)inserThumbnail:(UIImage *)image withDate:(NSDate*)date;
-(NSArray *)selectThumbnailsOfMonthWithDate:(NSDate *)target;
-(NSMutableDictionary *)selectThumbnails;
-(Thumbnail *)selectThumbnailWithDate:(NSDate *)target;
-(void)removeThumbnailWith:(NSDate *)date;
-(void)updateThumbnailWith:(NSDate *)date withThumbnail:(NSData*)image;
@end
