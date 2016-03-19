//
//  NSString+Combine.h
//  IOSBestPractice
//
//  Created by 吴永波 on 16/3/19.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#ifndef NSString_Combine_h
#define NSString_Combine_h

#import <Foundation/Foundation.h>

@interface NSString (Combine)

- (NSMutableString *)method1:(NSString*) str1 second:(NSString *)str2;
- (NSMutableString *)method2:(NSString*) str1 second:(NSString *)str2;

@end

#endif /* NSString_Combine_h */
