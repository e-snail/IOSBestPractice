//
//  ProtocalUsage.m
//  IOSBestPractice
//
//  Created by 吴永波 on 16/3/19.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProtocalUsage.h"

@interface ProtocalUsage ()

@end

@implementation ProtocalUsage

- (id) init {
    if (self = [super init]) {
    }
    
    return self;
}

- (int)add:(int) value1 second:(int) value2 {
    return (value1 + value2);
}

- (int)minus:(int) value1 second:(int) value2 {
    return (value1 - value2);
}

@end