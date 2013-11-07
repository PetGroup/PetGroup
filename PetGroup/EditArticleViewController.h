//
//  EditArticleViewController.h
//  PetGroup
//
//  Created by 阿铛 on 13-10-17.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface EditArticleViewController : UIViewController
{
    float diffH;
    NSAttributedString * attributeStringHH;

    
}
@property (nonatomic,retain)NSString* forumId;
@property (nonatomic,retain)NSString* forumName;
@end
