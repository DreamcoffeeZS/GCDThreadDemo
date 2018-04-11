//
//  TestViewController.m
//  Test
//
//  Created by zhoushuai on 16/3/7.
//  Copyright © 2016年 zhoushuai. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@property (nonatomic, strong) dispatch_queue_t serialQueue;

@property (nonatomic,strong)dispatch_queue_t  concurrentQueue;
@end

@implementation TestViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"测试GCD&&Thread";
}

#pragma mark - Respond To Events
- (IBAction)onBtnClick:(UIButton *)sender {
    NSString *selectorStr = [NSString stringWithFormat:@"testGCDThread%ld",(long)sender.tag];
    SEL sel = NSSelectorFromString(selectorStr);
    [self performSelector:sel withObject:nil];
}

#pragma mark - private Methods
//1.主线程队列(串行)：同步
//死锁
- (void)testGCDThread1{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    for (int i = 0; i < 10; i++) {
        dispatch_sync(mainQueue, ^{
            NSLog(@"主线程队列(串行)_同步%@-%d", [NSThread currentThread], i);
        });
    }
}

//2.主线程队列(串行)：异步
//异步任务在主线程上执行，而且是按序执行
- (void)testGCDThread2{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    for (int i = 0; i < 10; i++) {
        dispatch_async(mainQueue, ^{
            NSLog(@"主线程队列(串行)_异步%@-%d", [NSThread currentThread], i);
        });
    }
}


//3.全局队列(并行)：同步
//不创建新线程，所有任务在同一线程按序执行
- (void)testGCDThread3{
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 10; i++) {
        dispatch_sync(globalQueue, ^{
            NSLog(@"全局队列(并行)_同步:%@-%d", [NSThread currentThread], i);
        });
    }
}


//4.全局队列(并行)：异步
//新建多个线程，多任务无序执行
- (void)testGCDThread4{
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 10; i++) {
        dispatch_async(globalQueue, ^{
            NSLog(@"全局队列(并行)_异步:%@-%d", [NSThread currentThread], i);
        });
    }
}




//5.自定义串行队列：同步
//不创建新线程，所有任务在同一线程按序执行
- (void)testGCDThread5{
    for (int i = 0; i < 10; i++) {
        dispatch_sync(self.serialQueue, ^{
            NSLog(@"自定义串行队列_同步:%@-%d", [NSThread currentThread], i);
        });
    }
}


//6.自定义串行队列：异步
//创建一个子线程，多个任务在新线程上按顺序执行
- (void)testGCDThread6{
    dispatch_async(self.serialQueue, ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"自定义串行队列_异步:%@-%d", [NSThread currentThread],i);
        }
    });
}


//7.自定义并行队列：同步
//不会开启新线程，多个任务按序执行
- (void)testGCDThread7{
    for (int i = 0; i < 10; i++) {
        dispatch_sync(self.concurrentQueue, ^{
            NSLog(@"自定义并行队列_同步:%@-%d", [NSThread currentThread], i);
        });
    }
}


//8.自定义并行队列：异步
//创建多个线程，多任务无序执行
- (void)testGCDThread8{
//    for (int i = 0; i < 10; i++) {
//        dispatch_async(self.concurrentQueue, ^{
//            NSLog(@"%@ %d", [NSThread currentThread], i);
//        });
//    }
    [self testOperationQueue];
}


//9.测试NSOperationQueue
- (void)testOperationQueue{
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 4;
    
    // 2.创建操作
    // 使用 NSInvocationOperation 创建操作1
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    
    // 使用 NSInvocationOperation 创建操作2
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2) object:nil];
    

    // 使用 NSInvocationOperation 创建操作3
    NSInvocationOperation *op3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task3) object:nil];
    
    // 使用 NSInvocationOperation 创建操作4
    NSInvocationOperation *op4 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task4) object:nil];

    // 3.使用 addOperation: 添加所有操作到队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];

}

- (void)task1{
    NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
}

- (void)task2{
    NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
}

- (void)task3{
    NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
}

- (void)task4{
    NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
}



#pragma mark - Getter && Setter
//创建串行队列,传入参数为DISPATCH_QUEUE_SERIAL
- (dispatch_queue_t)serialQueue{
    if (!_serialQueue) {
        _serialQueue = dispatch_queue_create("testQueue1", DISPATCH_QUEUE_SERIAL);
    }
    return _serialQueue;
}

//创建并行队列,传入参数为DISPATCH_QUEUE_SERIAL
- (dispatch_queue_t)concurrentQueue{
    if (!_concurrentQueue) {
        _concurrentQueue =  dispatch_queue_create("testQueue2", DISPATCH_QUEUE_CONCURRENT);
    }
    return _concurrentQueue;
}

@end
