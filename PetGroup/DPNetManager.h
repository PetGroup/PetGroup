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

//#define APP_KEY @"01628871"
//#define APP_SECRET @"e82f7e4ee9fd42e9a1e275510d18cbbe"
@class DPNetManager;

@protocol DPNetManagerDelegate <NSObject>

-(void)DPNetManagerDidFinishLoading:(NSArray*)array;
-(void)DPNetManagerdidFailWithError:(NSError *)error;
@end
@interface DPNetManager : NSObject
@property(nonatomic,retain)NSString*URlString;
@property(nonatomic,weak)id<DPNetManagerDelegate>delegate;

-(id)initWithURL:(NSString*)URL delegate:(id<DPNetManagerDelegate>)delegate;
-(void) startUpdateData;
-(void)cancel;
+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params;
@end
