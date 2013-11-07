//
//  OwenrCell.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-24.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AriticleContent.h"
#import "EGOImageButton.h"
typedef  enum
{
    ButtonTypeImage = 1,
    ButtonTypeNormal
}ButtonType;
@protocol OwenrCellDelegate<NSObject>
-(void)owenrCellPressReplyButton;
-(void)owenrCellPressReportButton;
-(void)owenrCellPressImageWithID:(NSString*)imageID;
-(void)owenrCellPressWithURL:(NSURL*)URL;
-(void)owenrCellPressNameButtonOrHeadButton;
@end
@interface OwenrCell : UITableViewCell<DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>
{
    NSMutableSet *mediaPlayers;
}
@property (nonatomic, strong) NSMutableSet *mediaPlayers;
@property (nonatomic,assign)id<OwenrCellDelegate>delegate;
@property (nonatomic,retain)AriticleContent*article;
+(CGFloat)heightForRowWithArticle:(AriticleContent*)article;
@end
