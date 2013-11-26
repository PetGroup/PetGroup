//
//  EditReplyViewController.h
//  PetGroup
//
//  Created by Tolecen on 13-11-5.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmojiView.h"
@protocol EditReplyViewDelegate<NSObject>
-(void)editReplyViewDidEdit;
@end
@interface EditReplyViewController : UIViewController<EmojiViewDelegate>
{
    float diffH;
    NSAttributedString * attributeStringHH;
    EmojiView * theEmojiView;
    BOOL ifEmoji;
    UIButton * emojiBtn;
    UIButton* imageB;
}
@property (nonatomic,assign)id<EditReplyViewDelegate>delegate;
@property (nonatomic,assign)int row;
@property (nonatomic,retain)NSString* articleID;
@property (nonatomic,retain)NSString* replyID;
@end
