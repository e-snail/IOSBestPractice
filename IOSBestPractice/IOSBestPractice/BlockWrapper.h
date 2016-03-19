//
//  BlockWrapper.h
//  IOSBestPractice
//
//  Created by 吴永波 on 16/3/17.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SecondBlockParam) (int);
typedef int (^ThirdBlockParam) (int);

@interface BlockWrapper : NSObject {

int intInt;
NSString *strString;

}

@property (nonatomic, copy) NSString *strProperty;

- (int) func1:(int)withParam1 second:(int)withParam2 third:(int)withParam3;

//@selctor作为参数
//不能用 @selector代替 SEL  SEL是selector的类
- (int) func2:(int)withParam1 selectorParam:(SEL)withParam2;

//block作为参数
//以下两种声明方式都可以，但是第二种可读性更强
- (int) func3:(int)withParam1 blockParam:(void (^) (int))withParam2;
- (int) func4:(int)withParam1 blockParam:(SecondBlockParam)withParam2;
- (int) func5:(int)withParam1 blockParam:(ThirdBlockParam) withParam2;

@end