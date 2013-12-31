//
//  NewReplyArticleDataSource.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-14.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "hotPintsDataSource.h"

@interface NewReplyArticleDataSource : hotPintsDataSource
@property (nonatomic,assign)BOOL needSave;
-(void)loadHistorySuccess:(void (^)(void))success failure:(void (^)(void))failure;
@end
