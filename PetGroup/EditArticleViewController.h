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
#import "UIPlaceHolderTextView.h"
@protocol EditArticleViewDelegate<NSObject>
-(void)editArticleViewDidEdit:(Article*)aricle;
@end
@interface EditArticleViewController : UIViewController<UITextFieldDelegate,EmojiViewDelegate,UITextViewDelegate>
{
    float diffH;
    NSAttributedString * attributeStringHH;
    EmojiView * theEmojiView;
    BOOL ifEmoji;
    
    UIButton * emojiBtn;
    UIButton* imageB;
    
}
@property (nonatomic,retain)id <EditArticleViewDelegate> delegate;
@property (nonatomic,retain)NSArray* CircleTree;
@property (nonatomic,retain)NSString* assortID;
@property (nonatomic,retain)NSIndexPath* indexPath;
@end
