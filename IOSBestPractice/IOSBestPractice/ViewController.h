//
//  ViewController.h
//  IOSBestPractice
//
//  Created by 吴永波 on 16/1/2.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProtocal.h"

@interface ViewController : UIViewController

@property (strong) id <MyProtocal> calculator;

@end

