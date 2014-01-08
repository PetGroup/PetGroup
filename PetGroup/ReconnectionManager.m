//
//  ReconnectionManager.m
//  PetGroup
//
//  Created by Tolecen on 14-1-4.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import "ReconnectionManager.h"
#import "AppDelegate.h"
#import "XMPPHelper.h"
#import "TempData.h"
@implementation ReconnectionManager
static ReconnectionManager *sharedInstance=nil;

+(ReconnectionManager *) sharedInstance
{
    @synchronized(self)
    {
        if(!sharedInstance)
        {
            sharedInstance=[[self alloc] init];
            [sharedInstance commonInit];
        }
        return sharedInstance;
    }
}
-(void)commonInit
{
    haveBeginTry = NO;
    done = NO;
    randomBase = arc4random()%11+5;
    self.networkAvailable = NO;
    self.appDel = [[UIApplication sharedApplication] delegate];
    self.tempData = [TempData sharedInstance];
}

//判断是否具备条件可以重连
//xmppStream处于未连接状态，网络是可用的情况下进行重连
-(BOOL)isReconnectionAllowed
{
    NSLog(@"kkkkk;;;;;;%d,%d,%d,%d",[self.appDel.xmppHelper isDisconnected],[self.appDel.xmppHelper isConnecting],[self.appDel.xmppHelper isConnected],self.networkAvailable);
    return [self.appDel.xmppHelper isDisconnected]&&self.networkAvailable;
}
-(int)timeDelay
{
    attempts++;
    if (attempts > 13) {
        return randomBase*6*5;      // between 2.5 and 7.5 minutes (~5 minutes)
    }
    if (attempts > 7) {
        return randomBase*6;       // between 30 and 90 seconds (~1 minutes)
    }
    return randomBase;
}


//外部检测到断开或连接失败执行此方法开始尝试重连...
-(void)reconnectionAttemptIfSuccess:(void (^)())success
{
    if (haveBeginTry) {  //防止从其他入口进入再次执行一个重连线程，保证只有一个线程在重连
        return;
    }
    if (![[TempData sharedInstance] ifOpened])
    {
        haveBeginTry = YES;
        [self connectToCharServerSuccess:^{
            haveBeginTry = NO;
            success();
        } Failure:^{
            haveBeginTry = NO;
        }];
        return;
    }
    if (haveBeginTry) {  //防止从其他入口进入再次执行一个重连线程，保证只有一个线程在重连
        return;
    }
    haveBeginTry = YES;  //开始重连，标识置为YES
    done = NO;
    randomBase = 0;   //随机一个重连时间基准值
    attempts = 0;  //重连尝试次数，后面可以此判定多少次失败之后停止尝试
    dispatch_queue_t queue = dispatch_queue_create("com.pet.reconnectChatServer", NULL);
    dispatch_async(queue, ^{
        //执行重连方法，while循环尝试重连
        while (true) {
            if ([self isReconnectionAllowed]) {
                int remainingSeconds = [self timeDelay];
                NSLog(@"Attempts:%d,remaining Secs:%d,networkAvailable:%d",attempts,remainingSeconds,self.networkAvailable);
                

                //while循环消耗时间，这段时间内不执行while下面的连接
                while ([self isReconnectionAllowed]&&remainingSeconds>0) {
                    usleep(1000000);
                    remainingSeconds--;
                    NSLog(@"remaining:%d",remainingSeconds);
                }
                [self connectToCharServerSuccess:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //成功之后以主线程返回
                        success();
                    });
                } Failure:^{
                    
                }];
                //跳出上面的等待重连之间之后开始重连

            }
            else
            {
                done = NO;
                haveBeginTry = NO;
                break;
            }
            
            //判断xmppStream处于连接状态，将重连中的标识重置，跳出循环
            if (([self.appDel.xmppHelper isConnected]&&done)||!self.networkAvailable) {
                done = NO;
                haveBeginTry = NO;
                break;
            }

        }
    });

}
-(void)connectToCharServerSuccess:(void (^)())success Failure:(void (^)())failure
{
    [self.appDel.xmppHelper connect:[[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]stringByAppendingString:[self.tempData getDomain]] password:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] host:[self.tempData getServer] success:^(void){
        done = YES;
        NSLog(@"登陆成功xmpp1");
        success();
//        [self.tempData setOpened:YES];
//        [self.appDel.xmppHelper checkToServerifSubscibe];
    }fail:^(NSError *result){
        failure();
    }];
}
@end
