//
//  ViewController.m
//  IOSBestPractice
//
//  Created by 吴永波 on 16/1/2.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#import "ViewController.h"
#import "BlockWrapper.h"
#import "MyProtocal.h"
#import "ProtocalUsage.h"
#import "NSString+Combine.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [UIView animateWithDuration:3 animations:^{
        self.view.alpha = 1.0f;
    }];
    
    //一般参数的使用方式
    BlockWrapper *blockWrapper = [[BlockWrapper alloc] init];
    [blockWrapper func1:10 second:100 third:1000];
    
    //selector参数的使用方式
    [blockWrapper func2:10 selectorParam:@selector(selectorParam:)];
 
    [blockWrapper func3:100 blockParam:^(int a) {
        NSLog(@"func3 in deployment param=%u", a);
    }];
    
    //先实现一个block 然后作为参数传进去 类似C/C++的回调函数
    SecondBlockParam blockParam = ^(int a) {
        NSLog(@"SecondBlockParam param=%u", a);
    };
    [blockWrapper func4:100 blockParam:blockParam];
    
    //block有返回值 可以在函数实现中使用
    ThirdBlockParam thirdBlock = ^(int a) {
        return (a+111);
    };
    [blockWrapper func5:1000 blockParam:thirdBlock];
    
    NSLog(@"---------------------------------------");
    NSLog(@"---------------------------------------");
    
    //-----------------------
    //自定义协议和使用
    //-----------------------
    _calculator = [[ProtocalUsage alloc] init];
    int add = [_calculator add:1 second:2];
    NSLog(@"viewDidLoad add=%u", add);
    
    //使用前先检查协议的某个方法是否被实现了
    if ([_calculator respondsToSelector:@selector(minus:second:)]) {
        int minus = [_calculator minus:100 second:1];
        NSLog(@"viewDidLoad minus=%u", minus);
    }
    
    //使用前先检查协议的某个方法是否被实现了
    if ([_calculator respondsToSelector:@selector(multiply:second:)]) {
        int multiply = [_calculator multiply:100 second:10];
        NSLog(@"viewDidLoad multiply=%u", multiply);
    }

    NSLog(@"---------------------------------------");
    NSLog(@"---------------------------------------");

    //-----------------------
    //类别Category的使用
    //-----------------------
    //第一种使用方法 扩展NSString的方法
    NSString *string1 = @"string1";
    NSString *string2 = @"string2";
    NSMutableString *mutableString1 = [[[NSString alloc] init] method1:string1 second:string2];
    NSMutableString *mutableString2 = [[[NSString alloc] init] method2:string1 second:string2];
    NSLog(@"viewDidLoad result1=%@   result2=%@", mutableString1, mutableString2);
    //第二种使用方法 覆盖NSString的方法
    NSString *newStr = [[[NSString alloc] init] substringFromIndex:10];
    NSLog(@"viewDidLoad newString=%@", newStr);
}

- (void) selectorParam:(int) a {
    NSLog(@"selectorParam param=%u", a);
}

@end
