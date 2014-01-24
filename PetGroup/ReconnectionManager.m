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
#import "MessageViewController.h"
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
    self.stopAttempt = NO;
    canRegetAddress = YES;
    self.isRunning = NO;
    connecting = NO;
    firstIn = YES;
    randomBase = arc4random()%11+5;
    self.networkAvailable = NO;
    self.appDel = [[UIApplication sharedApplication] delegate];
    self.tempData = [TempData sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disConnectMethod) name:@"Notification_disconnect" object:nil];
}
-(void)disConnectMethod
{
    haveBeginTry = NO;
    connecting = NO;
    if (!self.isRunning) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_catchStatus" object:@"disconnect" userInfo:nil];
        if ([SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil]&&[TempData sharedInstance].appActive) {
            [self reconnectionAttempt];
        }
        
    }
    

}
//判断是否具备条件可以重连
//xmppStream处于未连接状态，网络是可用的情况下进行重连
-(BOOL)isReconnectionAllowed
{
//    NSLog(@"kkkkk;;;;;;%d,%d,%d,%d",[self.appDel.xmppHelper isDisconnected],[self.appDel.xmppHelper isConnecting],[self.appDel.xmppHelper isConnected],self.networkAvailable);
    return ![self.appDel.xmppHelper isConnected]&&![self.appDel.xmppHelper isConnecting]&&self.networkAvailable&&!connecting;
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
-(void)reconnectionAttempt
{
    if (haveBeginTry||!self.networkAvailable||connecting) {  //防止从其他入口进入再次执行一个重连线程，保证只有一个线程在重连
        return;
    }
//    if (![[TempData sharedInstance] ifOpened])
//    {
//        haveBeginTry = YES;
//        [self connectToCharServerSuccess:^{
//            haveBeginTry = NO;
//            success();
//        } Failure:^{
//            haveBeginTry = NO;
//        }];
//        return;
//    }
//    if (haveBeginTry) {  //防止从其他入口进入再次执行一个重连线程，保证只有一个线程在重连
//        return;
//    }
     //开始重连，标识置为YES
    self.stopAttempt = NO;
    self.isRunning = YES;
    canRegetAddress = YES;
    firstIn = YES;
    done = NO;
    randomBase = 4;   //随机一个重连时间基准值
    attempts = 0;  //重连尝试次数，后面可以此判定多少次失败之后停止尝试

    dispatch_queue_t queue = dispatch_queue_create("com.pet.reconnectChatServer", NULL);
    dispatch_async(queue, ^{
        NSTimeInterval bt = [[NSDate date] timeIntervalSince1970];
        //执行重连方法，while循环尝试重连
        while (true) {
            if (![TempData sharedInstance].appActive) {
                haveBeginTry = NO;
                canRegetAddress = YES;
                self.isRunning = NO;
                break;
            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_catchStatus" object:@"connecting" userInfo:nil];
            if ([self isReconnectionAllowed]) {

                int remainingSeconds = [self timeDelay];
                NSLog(@"Attempts:%d,remaining Secs:%d,networkAvailable:%d",attempts,remainingSeconds,self.networkAvailable);
                
                if (firstIn) {
                    remainingSeconds = 0;
                }
                //while循环消耗时间，这段时间内不执行while下面的连接
                while ([self isReconnectionAllowed]&&remainingSeconds>0) {
                    if (![TempData sharedInstance].appActive) {
                        haveBeginTry = NO;
                        canRegetAddress = YES;
                        self.isRunning = NO;
                        break;
                    }
                    usleep(1000000);
                    remainingSeconds--;
                    NSLog(@"remaining:%d",remainingSeconds);
                }
                if (!haveBeginTry) {
                    firstIn = NO;
                    [self connectToChatServer];

                }

                                //跳出上面的等待重连之间之后开始重连

            }
            NSTimeInterval nt = [[NSDate date] timeIntervalSince1970];
            if (nt-bt>=100&&nt-bt<180) {
                if (canRegetAddress) {
                    randomBase = 2;
                    attempts = 0;
                    [self regetXMPPServerAddress];
                }
                
            }
            if (nt-bt>=180) {
                haveBeginTry = NO;
                canRegetAddress = YES;
                self.isRunning = NO;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    //失败之后以主线程返回
//                    failure();
//                });
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_catchStatus" object:@"failed" userInfo:nil];
                break;
            }
            if (!self.networkAvailable||self.stopAttempt) {
                done = NO;
                haveBeginTry = NO;
                self.isRunning = NO;
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_catchStatus" object:@"failed" userInfo:nil];
                break;
            }
            
            //判断xmppStream处于连接状态，将重连中的标识重置，跳出循环
            if ([self.appDel.xmppHelper isConnected]&&done) {
                done = NO;
                haveBeginTry = NO;
                self.isRunning = NO;
                break;
            }

        }
    });

}
-(void)connectToChatServer
{
    if (connecting) {
        return;
    }
    haveBeginTry = YES;
//    if (![self.regetTimer isValid]&&[TempData sharedInstance].appActive) {
//        self.regetTimer = [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(regetXMPPServerAddress) userInfo:nil repeats:NO];
//    }
    connecting = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_catchStatus" object:@"connecting" userInfo:nil];
    [self.appDel.xmppHelper connect:[[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]stringByAppendingString:[self.tempData getDomain]] password:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] host:[self.tempData getServer] success:^(void){
        done = YES;
        connecting = NO;
        haveBeginTry = NO;
        self.isRunning = NO;
        NSLog(@"登陆成功xmpp1");
//        success();//        [self.tempData setOpened:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_catchStatus" object:@"connected" userInfo:nil];
//        [self.appDel.xmppHelper checkToServerifSubscibe];
    }fail:^(NSError *result){
        haveBeginTry = NO;
        connecting = NO;
//        failure();
        if (!self.isRunning&&[result code]!=909) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_catchStatus" object:@"failed" userInfo:nil];
        }

    }];
}

-(void)regetXMPPServerAddress
{
    [self.appDel.xmppHelper disconnect];
    canRegetAddress = NO;
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    //    [paramDict setObject:userName forKey:@"username"];
    //    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"service.uri.pet_sso" forKey:@"service"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [postDict setObject:@"iphone" forKey:@"imei"];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [postDict setObject:@"getChatServer" forKey:@"method"];
    [NetManager requestWithURLStrNoController:BaseClientUrl Parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        haveBeginTry = NO;
        NSDictionary * dict = responseObject;
        TempData * tp = [TempData sharedInstance];
        [tp SetServer:[dict objectForKey:@"address"] TheDomain:[dict objectForKey:@"name"]];
        tp.hostPort = [dict objectForKey:@"port"];
//        [self.msgV logInToChatServer];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        haveBeginTry = NO;
    }];
    
}

@end
