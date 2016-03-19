//
//  MyProtocal.h
//  IOSBestPractice
//
//  Created by 吴永波 on 16/3/19.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#ifndef MYPROTOCAL_XXXX
#define MYPROTOCAL_XXXX

@protocol MyProtocal <NSObject>

@required
- (int) add:(int) value1 second:(int) value2;
- (int) minus:(int) value1 second:(int) value2;

@optional
- (int) multiply:(int) value1 second:(int) value2;
- (int) devide:(int) value1 second:(int) value2;

@end

#endif