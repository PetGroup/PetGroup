//
//  ReconnectionManager.h
//  PetGroup
//
//  Created by Tolecen on 14-1-4.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XMPPHelper,AppDelegate,TempData;
@interface ReconnectionManager : NSObject
{
    int randomBase;
    int attempts;
    BOOL haveBeginTry;
    BOOL done;
}

@property (strong,nonatomic) AppDelegate * appDel;
@property (strong,nonatomic) TempData * tempData;
@property (assign,nonatomic) BOOL networkAvailable;

+(ReconnectionManager *) sharedInstance;
-(void)reconnectionAttemptIfSuccess:(void (^)())success;
@end
