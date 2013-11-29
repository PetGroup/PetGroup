//
//  BeautifulImageCell.h
//  PetGroup
//
//  Created by wangxr on 13-11-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TMQuiltViewCell.h"
#import "EGOImageView.h"
@protocol BeautifulImageCellDelegate <NSObject>

-(void)beautifulImageCellPressZanButtonAtIndexPath:(NSIndexPath*)indexPath;

@end
@interface BeautifulImageCell : TMQuiltViewCell
@property (nonatomic,assign) id<BeautifulImageCellDelegate>delegate;
@property (nonatomic,retain) EGOImageView* imageView;
@property (nonatomic,retain) UILabel* titleL;
@property (nonatomic,retain) NSIndexPath *indexPath;
@end
