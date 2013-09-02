//
//  DelegateAndDataSource.m
//  PetGroup
//
//  Created by 阿铛 on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DelegateAndDataSource.h"
@interface DelegateAndDataSource()

@end
@implementation DelegateAndDataSource

- (id)init
{
    self = [super init];
    if (self) {
        self.dataSourceArray = [[NSMutableArray alloc]init];
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
    return 1;
}

@end
