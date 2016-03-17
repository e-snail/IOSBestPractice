//
//  NSOperationRelated.m
//  IOSBestPractice
//
//  Created by 吴永波 on 16/3/17.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSOperationRelated.h"
#import "CustomizedNSOperation.h"

#define kURL @"http://avatar.csdn.net/2/C/D/1_totogo2010.jpg"

@interface NSOperationRelated ()

@end

@implementation NSOperationRelated

- (void)onInition {
    
    //--------------------------
    //NSInvocationOperation
    //--------------------------
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage:) object:kURL];
    
    NSLog(@"main thread----%@", [NSThread currentThread]);
    
    //--------------------------
    //NSOperationQueue & NSBlockOperation
    //--------------------------
    //自建线程队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
    //如果是在主线程中调用op的start方法,那么该任务是在主线程中执行;但如果是在其他子线程调用start方法,任务则是在其他子线程执行.
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"task0---%@", [NSThread currentThread]);
    }];
    //[blockOperation start];  在主线程中执行，因为是在主线程中触发的
    [queue addOperation:blockOperation];
    //addOperation 或者 addOperationWithBlock
    [queue addOperationWithBlock:^{
        NSLog(@"task1---%@", [NSThread currentThread]);
    }];
    
    //NSBlockOperation直接执行
    //当NSBlockOperation封装的操作数大于1的时候,就会执行异步操作.
    [blockOperation addExecutionBlock:^{
        NSLog(@"task2---%@", [NSThread currentThread]);
    }];
    [blockOperation addExecutionBlock:^{
        NSLog(@"task3---%@", [NSThread currentThread]);
    }];
    
    //设置最大并发数
    [queue setMaxConcurrentOperationCount:5];
    
    //主线程队列
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    NSBlockOperation *blockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"task4---%@", [NSThread currentThread]);
    }];
    [mainQueue addOperation:blockOperation1];
    
    //--------------------------
    //NSOperation的继承类
    //--------------------------
    CustomizedNSOperation *op = [[CustomizedNSOperation alloc] init];
    [op start];
}

- (void)downloadImage:(NSString *)url {
    NSLog(@"url=%@", url);
    NSURL *imgUrl = [NSURL URLWithString:url];
    NSData *imgData = [[NSData alloc] initWithContentsOfURL:imgUrl];
    UIImage *image = [[UIImage alloc] initWithData:imgData];
    
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:YES];
}

- (void)updateUI:(UIImage *)image {
    [_imageView setImage:image];
}

@end

