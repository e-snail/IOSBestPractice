//
//  SingletonInstance.m
//  IOSBestPractice
//
//  Created by 吴永波 on 16/1/2.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SingletonInstance.h"

@implementation SingletonInstance

@synthesize defaultProperty;

/**
 * GCD(Grand Central Dispatch) based, dispatch_once_t makes it thread safe
 */
+ (id) sharedInstance {
    static SingletonInstance *instance = nil;
    static dispatch_once_t once_token;
    
    dispatch_once(&once_token, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

/**
 * Non-GCD based
 */
//+ (id) sharedInstance {
//    static SingletonInstance *instance = nil;
//    @synchronized(self) {
//        if (instance == nil) {
//            instance = [[self alloc] init];
//        }
//    }
//    return instance;
//}

- (id) init {
    if (self = [super init]) {
        defaultProperty = @"SingletonInstance Default property";
    }
    
    return self;
}

- (void) dealloc {
}

@end