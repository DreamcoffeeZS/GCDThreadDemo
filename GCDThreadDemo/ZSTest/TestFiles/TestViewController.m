//
//  TestViewController.m
//  Test
//
//  Created by zhoushuai on 16/3/7.
//  Copyright © 2016年 zhoushuai. All rights reserved.
//

#import "TestViewController.h"
#import "FirstViewController.h"
#import <objc/message.h>


@interface TestViewController ()

@property (nonatomic, strong) dispatch_queue_t serialQueue;
@end

@implementation TestViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"测试";
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    
    //示例1：
    /*
    dispatch_sync(mainQueue, ^{
        NSLog(@"主线程所在的串行队列_同步添加任务_当前线程：%@",[NSThread currentThread]);
        //此情况死锁
    });
     */
    
    //示例2：
    dispatch_async(mainQueue, ^{
        NSLog(@"主线程所在的串行队列_异步添加任务_当前线程：%@",[NSThread currentThread]);
        //主线程所在的串行队列_异步添加任务_当前线程：<NSThread: 0x600000064b00>{number = 1, name = main}
    });
    
    
    
    
    
    
    //示例1:
    dispatch_async(globalQueue, ^{
        NSLog(@"全局并发队列_同步添加任务_当前线程：%@",[NSThread currentThread]);
        //打印：全局并发队列_同步添加任务_当前线程：<NSThread: 0x600000668440>{number = 4, name = (null)}
        //此例说明：全局并发队列是独立于主线程串行队列的异步线程队列。
    });
    
    
    
    
    
    /*
    //创建串行队列,传入参数为DISPATCH_QUEUE_SERIAL
    self.serialQueue = dispatch_queue_create("com.lysongzi.serial", DISPATCH_QUEUE_SERIAL);
    
    //同步执行队列中的任务，会立即在当前线程执行该任务
    dispatch_sync(self.serialQueue, ^{
        NSLog(@"这里是同步执行的串行队列01。===> %@", [NSThread currentThread]);
    });
    
    //异步执行任务，会新开一个线程，多个任务按顺序执行
    dispatch_async(self.serialQueue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"串行01 ===> %d ===> %@", i, [NSThread currentThread]);
        }
    });
    
    dispatch_sync(self.serialQueue, ^{
        NSLog(@"这里是同步执行的串行队列02。===> %@", [NSThread currentThread]);
    });
    
    dispatch_async(self.serialQueue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"串行02 ===> %d ===> %@", i, [NSThread currentThread]);
        }
    });
    
    dispatch_async(self.serialQueue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"串行03 ===> %d ===> %@", i, [NSThread currentThread]);
        }
    });
    */
}
@end
