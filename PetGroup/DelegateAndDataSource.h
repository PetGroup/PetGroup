//
//  DelegateAndDataSource.h
//  PetGroup
//
//  Created by 阿铛 on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DelegateAndDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak)UIViewController* viewC;

@end
