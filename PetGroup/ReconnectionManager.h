//
//  ReconnectionManager.h
//  PetGroup
//
//  Created by Tolecen on 14-1-4.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XMPPHelper,AppDelegate,TempData,MessageViewController;
@interface ReconnectionManager : NSObject
{
    int randomBase;
    int attempts;
    BOOL haveBeginTry;
    BOOL done;
//    BOOL stopAttempt;
    BOOL canRegetAddress;
    BOOL connecting;
    BOOL firstIn;
    BOOL manualStop;
}

@property (strong,nonatomic) AppDelegate * appDel;
@property (strong,nonatomic) TempData * tempData;
@property (assign,nonatomic) BOOL networkAvailable;
@property (assign,nonatomic) BOOL stopAttempt;
@property (assign,nonatomic) BOOL isRunning;
@property (strong,nonatomic) NSTimer * regetTimer;
@property (strong,nonatomic) MessageViewController * msgV;

+(ReconnectionManager *) sharedInstance;
-(void)reconnectionAttempt;
@end
