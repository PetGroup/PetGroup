//
//  KKMessageCell.h
//  XmppDemo
//


#import <UIKit/UIKit.h>
//#import <QuartzCore/QuartzCore.h>
#import "EGOImageView.h"
#import "EGOImageButton.h"
#import "OHAttributedLabel.h"
@interface KKMessageCell : UITableViewCell<OHAttributedLabelDelegate>


@property(nonatomic, retain) UILabel *senderAndTimeLabel;
@property(nonatomic, retain) UILabel *progressLabel;
@property(nonatomic, retain) OHAttributedLabel *messageContentView;
@property(nonatomic, retain) UIButton *bgImageView;
@property(nonatomic, retain) UIButton *sendFailBtn;
@property(nonatomic, retain) EGOImageView * headImgV;
@property(nonatomic, retain) EGOImageView * contentImgV;
@property(nonatomic, retain) UIButton * headBtn;
@property(nonatomic ,retain) UIButton * chattoHeadBtn;
@property(nonatomic ,retain) UIImageView * ifRead;
@property(nonatomic ,retain) UIImageView * imgRadiusBG;
@property(nonatomic ,retain) UIImageView * playAudioImageV;
@property(nonatomic ,retain) UIImageView * maskContentImgV;
@property(nonatomic ,retain) UIActivityIndicatorView * activityV;

@end
