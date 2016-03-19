//
//  BlockWrapper.m
//  IOSBestPractice
//
//  Created by 吴永波 on 16/3/17.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockWrapper.h"
#import <math.h>

//用typedefine声明block
typedef int (^singleInt)(int);

//int (^tripile) (int);

//double (^times) (double a, double times) {
//    return pow(a, times);
//};

@interface BlockWrapper ()  //终于明白这个括号就是类扩展了

@property (nonatomic, strong) NSString *propertyString;

@end

@implementation BlockWrapper

@synthesize strProperty;

- (id)init {
    if (self = [super init]) {
        intInt = 1000;
        strString = @"strString";
        strProperty = @"strProperty";
    }
    
    //-------------------
    //用法1 自定义一个block并使用它
    //-------------------
    int (^customBlock)(int) = ^(int a) {
        intInt = 10000;
        strString = @"newStrString";
        strProperty = @"newStrProperty";
        
        return a + intInt;
    };
    
    int value = customBlock(234);
    NSLog(@"init return value=%u", value);

    NSLog(@"int newStr=%@ newProperty=%@", strString, strProperty);
    
    return self;
}

//类实现里定义block
int (^tripleInt) (int a) = ^(int a) {
    return a * a * a;
};

- (int) func1:(int)withParam1 second:(int)withParam2 third:(int)withParam3 {

    NSLog(@"param1= %u, param2=%u", withParam1, withParam2);
    
    //函数实现里定义block
    int (^doubleInt) (int a) = ^(int a) {
        return a * a;
    };
    
    int a = 10;

    //实现之前声明的函数
    int (^singleInt)(int a) = ^(int a) {
        return a;
    };
    
    NSLog(@"a = 10, single it return = %u", singleInt(a));
    
    NSLog(@"a = 10, double it return = %u", doubleInt(a));
    
    NSLog(@"a = 10, triple it return = %u", tripleInt(a));
    

    return 0;
}

- (int) func2:(int)withParam1 selectorParam:(SEL)withParam2 {
    
    NSLog(@"func2 param1 = %u", withParam1);
    
    return 0;
}

- (int) func3:(int)withParam1 blockParam:(void (^)(int))withParam2 {
    NSLog(@"func3 param1=%u", withParam1);
    withParam2(withParam1); //要用这种调用方式
    
    return 0;
}

//-------------------
//用法2 block作回调函数
//-------------------
- (int) func4:(int)withParam1 blockParam:(SecondBlockParam)withParam2 {
    NSLog(@"func4 param1=%u", withParam1);
    withParam2(withParam1);
    
    return 0;
}

- (int) func5:(int)withParam1 blockParam:(ThirdBlockParam)withParam2 {
    NSLog(@"func5 param1=%u", withParam1);
    int result = withParam2(withParam1);
    NSLog(@"func5 return=%u", result);
    
    return result;
}

@end