//
//  TableViewNeedReloadData.h
//  PetGroup
//
//  Created by Tolecen on 13-10-28.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Dynamic;
@protocol TableViewNeedReloadData <NSObject>
-(void)dynamicListNeedReloadData:(Dynamic*)dynamic;
@end
