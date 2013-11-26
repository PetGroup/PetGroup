//
//  EditArticleViewController.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-17.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Article.h"
#import "EmojiView.h"
@protocol EditArticleViewDelegate<NSObject>
-(void)editArticleViewDidEdit:(Article*)aricle;
@end
@interface EditArticleViewController : UIViewController<UITextFieldDelegate,EmojiViewDelegate>
{
    float diffH;
    NSAttributedString * attributeStringHH;
    EmojiView * theEmojiView;
    BOOL ifEmoji;
    
    UIButton * emojiBtn;
    UIButton* imageB;
    
}
@property (nonatomic,retain)id <EditArticleViewDelegate> delegate;
@property (nonatomic,retain)NSString* forumId;
@property (nonatomic,retain)NSString* forumName;
@end
