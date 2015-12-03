//
//  ImagesDao.h
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 22..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "DataBaseAccessObject.h"

@interface ImagesDao : DataBaseAccessObject



+(id)getDefaultImagesDao;
-(BOOL)insertDataWithString:(NSData *)dt targetDate:(NSDate *)target;
@end
