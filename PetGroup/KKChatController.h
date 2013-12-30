//
//  KKChatController.h
//  XmppDemo
//
//  Created by 夏 华 on 12-7-12.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "XMPPFramework.h"
#import "Common.h"
#import "HPGrowingTextView.h"
#import "TempData.h"
#import "StoreMsgDelegate.h"
#import "PersonDetailViewController.h"
#import "MyProfileViewController.h"
#import "selectContactPage.h"
#import "OHASBasicHTMLParser.h"
#import "EmojiView.h"
#import "HeadImageCutViewController.h"
#import "MBProgressHUD.h"
typedef  enum
{
    actionSheetMore = 0,
    actionSheetChoosePic
}ActionSheetStyle;
@class AppDelegate, XMPPHelper;
@interface KKChatController : UIViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,StoreMsgDelegate,getContact,UIAlertViewDelegate,UIActionSheetDelegate,UIScrollViewDelegate,AVAudioRecorderDelegate,AVAudioSessionDelegate,AVAudioPlayerDelegate,HPGrowingTextViewDelegate,EmojiViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CutHeadImageSucceedDelegate,MBProgressHUDDelegate>
{
    UILabel *titleLabel;
    NSString * userName;
   // NSMutableDictionary * userDefaults;
    NSUserDefaults * uDefault;
    NSMutableDictionary * peopleDict;
    UIView * inPutView;
    UILongPressGestureRecognizer *btnLongTap;
    UIButton * tempBtn;
    UIView * popLittleView;
    UIView * btnBG;
    int readyIndex;
    NSIndexPath * indexPathTo;
    NSString * tempStr;
    UIView * clearView;
    BOOL canAdd;
    NSString * currentID;
    UIImageView * inputbg;
    UIButton * senBtn;
    double previousTime;
    double touchTimePre;
    int touchTimeFinal;
    NSMutableDictionary * userInfoDict;
    NSMutableDictionary * postDict;
    NSString * myHeadImg;
    NSDictionary * tempDict;
    
    BOOL ifAudio;
    BOOL ifEmoji;
    
    UIButton * audioBtn;
    UIButton * emojiBtn;
    UIButton * picBtn;
    UIButton * audioRecordBtn;
    
    NSTimeInterval beginTime;
    UIButton * audioplayButton;
    UIImageView *recordAnimationIV;
    UILabel * recordTimeLabel;
    
    UIScrollView *m_EmojiScrollView;
    UIPageControl *m_Emojipc;
    UIView * emojiBGV;
    
    EmojiView * theEmojiView;
    
    NSMutableDictionary *recordSetting;
    AVAudioPlayer * audioPlayer;
    NSString * rootRecordPath;
    NSMutableArray * animationOne;
    NSMutableArray * animationTwo;
    
    float diffH;
    
    UIMenuController * menu;
    
    BOOL canSendAudio;
    NSMutableArray * sendingFileArray;
    
    NSString * playWhose;
    NSString * rootChatImgPath;
    
    NSString * nowPlayingAudioID;
    MBProgressHUD * hud;
    
    UIMenuItem *copyItem;
    UIMenuItem *copyItem2;
    UIMenuItem *copyItem3;
    
    NSDictionary * waitingTransDict;
    NSDictionary *settings;
    
    BOOL recordTimeOut;
    BOOL stopTime;
    
    BOOL audioCancelled;
    
    NSTimer * recordTimer;
    
    NSTimeInterval * recordBtnBeginTime;
    
}
@property (strong, nonatomic)  UITableView *tView;
@property (strong, nonatomic)  NSMutableArray *finalMessageArray;
@property (strong, nonatomic)  NSMutableArray *HeightArray;
@property (strong, nonatomic)  UITextField *messageTextField;
//@property (strong, nonatomic)  UIButton * sendBtn;
@property(nonatomic, retain) NSString *chatWithUser;
@property(nonatomic, assign) BOOL ifFriend;
@property(nonatomic, retain) NSString *nickName;
@property(nonatomic, retain) NSString *friendStatus;
@property(nonatomic, retain) NSString *chatUserImg;
@property (strong,nonatomic) AppDelegate * appDel;
@property (strong,nonatomic) HPGrowingTextView *textView;
@property (assign,nonatomic) id<StoreMsgDelegate> msgDelegate;
@property (nonatomic,retain) AVAudioSession *session;
@property (nonatomic,retain) AVAudioRecorder *audioRecorder;
@property (assign,nonatomic) ActionSheetStyle actionSheetStyle;
- (void)sendButton:(id)sender;
- (void)closeButton:(id)sender;
@end
