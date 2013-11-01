//
//  OwenrCell.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-24.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Article.h"
typedef  enum
{
    ButtonTypeImage = 1,
    ButtonTypeNormal
}ButtonType;
@protocol OwenrCellDelegate<NSObject>
-(void)owenrCellPressReplyButtonAtIndexPath:(NSIndexPath *)indexPath;
-(void)owenrCellPressReportButtonAtIndexPath:(NSIndexPath *)indexPath;
@end
@interface OwenrCell : UITableViewCell<DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>
{
    NSMutableSet *mediaPlayers;
}
@property (strong,nonatomic)DTAttributedTextContentView * textView;
@property (nonatomic, strong) NSMutableSet *mediaPlayers;
@property (nonatomic,retain)NSIndexPath*indexPath;
@property (nonatomic,assign)id<OwenrCellDelegate>delegate;
@property (nonatomic,retain)Article*article;
+(CGFloat)heightForRowWithArticle:(Article*)article;
@end
