//
//  NSString+Combine.m
//  IOSBestPractice
//
//  Created by 吴永波 on 16/3/19.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Combine.h"

@implementation NSString (Combine)

- (NSMutableString *)method1:(NSString *)str1 second:(NSString *)str2 {
    NSMutableString *str = [[NSMutableString alloc] initWithString:str1];
    [str appendString:@" -- "];
    [str appendString:str2];
    
    return str;
}

- (NSMutableString *)method2:(NSString *)str1 second:(NSString *)str2 {
    NSMutableString *str = [[NSMutableString alloc] initWithString:str2];
    [str appendString:@" -- "];
    [str appendString:str1];
    
    return str;
}

- (NSString *)substringFromIndex:(NSUInteger)from {
    return @"I DONT KNOW!!!";
}

@end