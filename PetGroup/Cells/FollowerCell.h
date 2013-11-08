//
//  FollowerCell.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-24.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteReply.h"
#import <MediaPlayer/MediaPlayer.h>
@class FollowerCell;
@protocol followerCellDelegate<NSObject>
-(void)followerCellPressReplyButtonAtIndexPath:(NSIndexPath *)indexPath;
-(void)followerCellPressReportButtonAtIndexPath:(NSIndexPath *)indexPath;
-(void)followerCellPressImageWithID:(NSString*)imageID;
-(void)followerCellPressWithURL:(NSURL*)URL;
-(void)followerCellPressNameButtonOrHeadButtonAtIndexPath:(NSIndexPath *)indexPath;
@end
@interface FollowerCell : UITableViewCell<DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>
{
    NSMutableSet *mediaPlayers;
}
@property (nonatomic, strong) NSMutableSet *mediaPlayers;
@property (nonatomic,retain)NSIndexPath*indexPath;
@property (nonatomic,assign)id<followerCellDelegate>delegate;
@property (nonatomic,assign)NoteReply* reply;
+(CGFloat)heightForRowWithArticle:(NoteReply*)reply;
@end
