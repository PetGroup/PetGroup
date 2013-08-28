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
        self.pageIndex = 0;
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

@end
