//
//  EditReplyViewController.h
//  PetGroup
//
//  Created by Tolecen on 13-11-5.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditReplyViewController : UIViewController
{
    float diffH;
    NSAttributedString * attributeStringHH;
    
    
}
@property (nonatomic,assign)int row;
@property (nonatomic,retain)NSString* articleID;
@property (nonatomic,retain)NSString* replyID;
@end
