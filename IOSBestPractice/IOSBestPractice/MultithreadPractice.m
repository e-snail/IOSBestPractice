//
//  MultithreadPractice.m
//  IOSBestPractice
//
//  Created by 吴永波 on 16/3/15.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultithreadPractice.h"

#import <pthread.h>

/*
 参考文档  
 http://cnbin.github.io/blog/2015/05/26/ios-gcdshi-yong-ji-qiao/
 https://github.com/nixzhu/dev-blog/blob/master/2014-04-19-grand-central-dispatch-in-depth-part-1.md
 http://www.cocoachina.com/ios/20150731/12819.html
 */

@interface MultithreadPractice ()

@end

@implementation MultithreadPractice

- (void)showUsage {
    _threadString = [[NSMutableString alloc] initWithString:@"showUsage"];
    _gcdString = [[NSMutableString alloc] initWithString:@"showUsage"];
    
    //--------------------------
    //POSIX线程
    //--------------------------
    pthread_t thread;
    pthread_create(&thread, NULL, start, NULL);
    
    
    //--------------------------
    //NSThread
    //--------------------------
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(runThread:) object:nil];
    [thread1 start];
    [thread1 cancel];
    
    //功能同上
    [NSThread detachNewThreadSelector:@selector(detachThread:) toTarget:self withObject:nil];
    
    //同上
    [self performSelector:@selector(runThread1:) withObject:nil afterDelay:2];
    [self performSelectorInBackground:@selector(runThread2:) withObject:nil];
    
    
    //--------------------------
    //GCD grand central dispatch
    //--------------------------
    //主队列  主要用于UI线程刷新
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //串行任务队列
    dispatch_queue_t serialQueue = dispatch_queue_create("queue_tag_label", DISPATCH_QUEUE_SERIAL);
    //并行任务队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("queue_tag_lable_c", DISPATCH_QUEUE_CONCURRENT);
    //全局队列
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(global_queue, ^{
        [_gcdString appendString:@"  global_queue async"];
        NSLog(@" %@", _gcdString);
        NSLog(@"global queue async %@", [NSThread currentThread]);
    });
    
    //在主队列上同步执行
    //注意 mainQueue上只能异步执行，否则卡死在block中
    dispatch_async(mainQueue, ^{
        [_gcdString appendString:@"  mainQueue async"];
        NSLog(@" %@", _gcdString);
        NSLog(@"main queue sync %@", [NSThread currentThread]);
    });
    
    //在串行队列上异步执行
    //注意 串行队列+异步执行  线程还是并发执行
    dispatch_async(serialQueue, ^{
        [NSThread sleepForTimeInterval:3];
        
        [_gcdString appendString:@"  serialQueue async 11"];
        NSLog(@" %@", _gcdString);
        
        NSLog(@"serial queue async 11  %@", [NSThread currentThread]);
    });
    dispatch_async(serialQueue, ^{
        [NSThread sleepForTimeInterval:1];
        
        [_gcdString appendString:@"  serialQueue async 22"];
        NSLog(@" %@", _gcdString);
        
        NSLog(@"serial queue async 22  %@", [NSThread currentThread]);
    });
    
    //在并行队列上同步执行
    //注意 并行队列+同步执行  线程还是串行执行
    dispatch_async(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:3];
        
        [_gcdString appendString:@"  concurrentQueue async 11"];
        NSLog(@" %@", _gcdString);
        
        NSLog(@"concurrent queue async 11  %@", [NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:1];
        
        [_gcdString appendString:@"  concurrentQueue async 22"];
        NSLog(@" %@", _gcdString);
        
        NSLog(@"concurrent queue async 22  %@", [NSThread currentThread]);
    });
    
    NSMutableString *once_string = [[NSMutableString alloc] initWithString:@"init"];
    
    //延迟执行
    dispatch_time_t time1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(time1, dispatch_get_main_queue(), ^{
        NSLog(@" dispatch_after = %@", once_string);
    });
    
    //--------------------------
    //线程组
    //--------------------------
    dispatch_queue_t global_queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, global_queue1, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@" dispatch_group_async 1 = %@", [NSThread currentThread]);
    });
    dispatch_group_async(group, global_queue1, ^{
        NSLog(@" dispatch_group_async 2 = %@", [NSThread currentThread]);
    });
    dispatch_group_async(group, global_queue1, ^{
        NSLog(@" dispatch_group_async 3 = %@", [NSThread currentThread]);
    });
    //监听线程组所有线程结束
    dispatch_group_notify(group, global_queue1, ^{
        NSLog(@" dispatch_group_notify = %@", [NSThread currentThread]);
    });
    
    
    //--------------------------
    //使用GCD 实现单实例
    //dispatch_once的实现和性能 http://blog.jimmyis.in/dispatch_once/
    //--------------------------
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        [once_string appendString:@" first"];
    });
    
    [NSThread sleepForTimeInterval:1];
    
    //使用dispatch_one_t 不会重复进入
    dispatch_once(&once_token, ^{
        [once_string appendString:@" second"];
    });
    
    NSLog(@" once_string = %@", once_string);
}

void *start(void *data) {
    NSLog(@"pthread  thread info %@", [NSThread currentThread]);
    return NULL;
}

- (void)runThread:(id)sender {
    [NSThread sleepForTimeInterval:5];
    [_threadString appendString:@"  runThread"];
    NSLog(@"NSThread runThread   thread info %@  with String %@", [NSThread currentThread], _threadString);
}

- (void)detachThread:(id)sender {
    [_threadString appendString:@"  detachThread"];
    [NSThread sleepForTimeInterval:1];
    NSLog(@"NSThread detachThread   thread info %@  with String %@", [NSThread currentThread], _threadString);
}

- (void)runThread1:(id)sender {
    [NSThread sleepForTimeInterval:5];
    [_threadString appendString:@"  runThread_1"];
    NSLog(@"NSThread runThread_1   thread info %@  with String %@", [NSThread currentThread], _threadString);
}

- (void)runThread2:(id)sender {
    [NSThread sleepForTimeInterval:3];
    [_threadString appendString:@"  runThread_2"];
    NSLog(@"NSThread runThread_2   thread info %@  with String %@", [NSThread currentThread], _threadString);
}

@end