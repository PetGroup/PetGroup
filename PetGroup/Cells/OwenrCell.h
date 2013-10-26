//
//  OwenrCell.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-24.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
@protocol OwenrCellDelegate<NSObject>
-(void)owenrCellPressReplyButtonAtIndexPath:(NSIndexPath *)indexPath;
-(void)owenrCellPressReportButtonAtIndexPath:(NSIndexPath *)indexPath;
@end
@interface OwenrCell : UITableViewCell
@property (nonatomic,retain)NSIndexPath*indexPath;
@property (nonatomic,assign)id<OwenrCellDelegate>delegate;
@property (nonatomic,retain)Article*article;
+(CGFloat)heightForRowWithArticle:(Article*)article;
@end
