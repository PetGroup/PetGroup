//
//  TableViewDatasourceDidChange.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-28.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Dynamic;
@protocol TableViewDatasourceDidChange <NSObject>
-(void)dynamicListDeleteOneDynamic:(Dynamic*)dynamic;
-(void)dynamicListAddOneDynamic:(Dynamic*)dynamic;
-(void)dynamicListJustReload;
@end
