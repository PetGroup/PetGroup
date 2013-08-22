//
//  KKMessageCell.h
//  XmppDemo
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface KKMessageCell : UITableViewCell


@property(nonatomic, retain) UILabel *senderAndTimeLabel;
@property(nonatomic, retain) UILabel *messageContentView;
@property(nonatomic, retain) UIButton *bgImageView;
@property(nonatomic, retain) UIImageView * headImgV;
@property(nonatomic, retain) UIButton * headBtn;
@property(nonatomic ,retain) UIButton * chattoHeadBtn;

@end
