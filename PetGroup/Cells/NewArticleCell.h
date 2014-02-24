//
//  NewArticleCell.h
//  PetGroup
//
//  Created by wangxr on 14-2-24.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicCellDelegate.h"
#import "Article.h"
@interface NewArticleCell : UITableViewCell
@property (nonatomic,assign)Article* article;
@property (nonatomic,weak)id<DynamicCellDelegate> delegate;
+ (CGFloat)heightForRowWithArticle:(Article*)article;
@end
