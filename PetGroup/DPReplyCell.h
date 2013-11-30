//
//  DPReplyCell.h
//  PetGroup
//
//  Created by wangxr on 13-11-30.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPReply.h"
@interface DPReplyCell : UITableViewCell
@property (nonatomic,retain)DPReply* reply;
+(CGFloat)heightForRowWithDynamic:(DPReply*)reply;
@end
