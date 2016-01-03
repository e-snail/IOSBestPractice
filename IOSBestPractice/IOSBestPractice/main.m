//
//  main.m
//  IOSBestPractice
//
//  Created by 吴永波 on 16/1/2.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import "SingletonInstance.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        //singleton usage
        /*
        SingletonInstance *instance = [SingletonInstance sharedInstance];
        NSLog(@"property is %@", [instance defaultProperty]);
        */
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
