//
//  DPNetManager.h
//  PetGroup
//
//  Created by wangxr on 13-11-25.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
#define APP_KEY @"30376663"
#define APP_SECRET @"5896365496984c9d915763481f62ed58"
@class DPNetManager;

@protocol DPNetManagerDelegate <NSObject>

-(void)DPNetManagerDidFinishLoading:(NSArray*)array;
-(void)DPNetManagerdidFailWithError:(NSError *)error;
@end
@interface DPNetManager : NSObject
@property(nonatomic,retain)NSString*URlString;
@property(nonatomic,assign)id<DPNetManagerDelegate>delegate;

-(id)initWithURL:(NSString*)URL delegate:(id<DPNetManagerDelegate>)delegate;
-(void) startUpdateData;
-(void)cancel;
+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params;
@end