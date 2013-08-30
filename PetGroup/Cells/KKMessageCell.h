//
//  KKMessageCell.h
//  XmppDemo
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EGOImageView.h"
@interface KKMessageCell : UITableViewCell


@property(nonatomic, retain) UILabel *senderAndTimeLabel;
@property(nonatomic, retain) UILabel *messageContentView;
@property(nonatomic, retain) UIButton *bgImageView;
@property(nonatomic, retain) EGOImageView * headImgV;
@property(nonatomic, retain) UIButton * headBtn;
@property(nonatomic ,retain) UIButton * chattoHeadBtn;

@end
