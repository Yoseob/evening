//
//  CheckBox.h
//  dayBday
//
//  Created by LeeYoseob on 2015. 11. 25..
//  Copyright © 2015년 LeeYoseob. All rights reserved.
//

#import "TransferAble.h"

@interface CheckBox : TransferAble
@property (nonatomic,assign)NSInteger location;
@property (nonatomic,assign)int status;

-(id)initWithLoc:(NSInteger)loc andStatus:(int)stat;
@end
