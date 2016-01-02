//
//  SingletonInstance.h
//  IOSBestPractice
//
//  Created by 吴永波 on 16/1/2.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingletonInstance : NSObject {
    NSString *defaultProperty;
}

@property (nonatomic, retain) NSString *defaultProperty;

+ (id) sharedInstance;

@end