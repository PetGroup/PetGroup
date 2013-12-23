//
//  KKChatController.m
//  XmppDemo
//
//  Created by 夏 华 on 12-7-12.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "KKChatController.h"
#import "CustomTabBar.h"
#import "MLNavigationController.h"
#import "KKMessageCell.h"
#import "AppDelegate.h"
#import "XMPPHelper.h"
#import "JSON.h"
#import "HeightCalculate.h"
#ifdef NotUseSimulator
    #import "amrFileCodec.h"
#endif

#define padding 20
#define LocalMessage @"localMessage"
#define NameKeys @"namekeys"
@interface KKChatController (){
    
    NSMutableArray *messages;
    
}

@end

@implementation KKChatController
@synthesize tView;
@synthesize messageTextField;
@synthesize chatWithUser;
@synthesize nickName;
@synthesize session;
@synthesize audioRecorder;


- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    diffH = [Common diffHeight:self];
    postDict = [NSMutableDictionary dictionary];
    canAdd = YES;
    previousTime = 0;
    touchTimeFinal = 0;
    touchTimePre = 0;
    uDefault = [NSUserDefaults standardUserDefaults];
    currentID = [uDefault objectForKey:@"account"];
    canSendAudio = NO;
    sendingFileArray = [NSMutableArray array];
    playWhose = @"myself";

    
    NSLog(@"wwwwwww:%@",currentID);
//    if (currentID) {
//        userDefaults = [[NSUserDefaults standardUserDefaults] objectForKey:currentID];
//    }
//    else
//    {
//        userDefaults = [NSMutableDictionary dictionary];
//    }
    self.ifFriend = YES;
    if (![DataStoreManager ifHaveThisFriend:self.chatWithUser]) {
        self.ifFriend = NO;
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImageView * bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [bgV setImage:[UIImage imageNamed:@"chat_bg.png"]];
    [self.view addSubview:bgV];
    messages = [DataStoreManager qureyAllCommonMessages:self.chatWithUser];
    [self normalMsgToFinalMsg];
    myHeadImg = @"";
    myHeadImg = [DataStoreManager queryFirstHeadImageForUser:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
    
    self.tView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-(44+diffH)-50) style:UITableViewStylePlain];
   // NSLog(@"wwwwww%f",self.view.frame.size.height);
    [self.view addSubview:self.tView];
    [self.tView setBackgroundColor:[UIColor clearColor]];
    self.tView.delegate = self;
    self.tView.dataSource = self;
    self.tView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (messages.count>0) {
        [self.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
 //   [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(closeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *profileButton=[UIButton buttonWithType:UIButtonTypeCustom];
    profileButton.frame=CGRectMake(282, 7+diffH, 30, 30);
    [profileButton setBackgroundImage:[UIImage imageNamed:@"gengduoxinxi.png"] forState:UIControlStateNormal];
    //   [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [profileButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.view addSubview:profileButton];
    [profileButton addTarget:self action:@selector(moreOperation) forControlEvents:UIControlEventTouchUpInside];
    
    titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 2+diffH, 120, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=self.nickName;
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];


    
    
//    inPutView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, 320, 50)];
//    [inPutView setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:inPutView];
//    inputbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
//    [inputbg setImage:[UIImage imageNamed:@"inputbg.png"]];
//    [inPutView addSubview:inputbg];
//    UIImageView * inputbg2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6.5, 262, 37)];
//    [inputbg2 setImage:[UIImage imageNamed:@"chat_input.png"]];
//    [inPutView addSubview:inputbg2];
    
//    self.messageTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 262, 30)];
//    [self.messageTextField setBackgroundColor:[UIColor clearColor]];
//    self.messageTextField.delegate = self;
//    self.messageTextField.returnKeyType = UIReturnKeySend;
//    [inPutView addSubview:self.messageTextField];
    
    ifAudio = NO;
    ifEmoji = NO;

    
//    self.textView = [[BHExpandingTextView alloc] initWithFrame:CGRectMake(40, 7, 200, 35)];
//    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
//    self.textView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
//    [self.textView.internalTextView setReturnKeyType:UIReturnKeySend];
//    self.textView.delegate = self;
//    [inPutView addSubview:self.textView];
    
    
    
    
    inPutView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, 320, 50)];
    
	self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(40, 7, 200, 35)];
    self.textView.isScrollable = NO;
    self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	self.textView.minNumberOfLines = 1;
	self.textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
	self.textView.returnKeyType = UIReturnKeySend; //just as an example
	self.textView.font = [UIFont systemFontOfSize:15.0f];
	self.textView.delegate = self;
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.textView.backgroundColor = [UIColor clearColor];
    //    self.inputTF.placeholder = @"Type to see the textView grow!";
    
    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
    
    [self.view addSubview:inPutView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"chat_input.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(40, 7, 200, 35);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"inputbg.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, inPutView.frame.size.width, inPutView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [inPutView addSubview:imageView];
    
    [inPutView addSubview:entryImageView];
    [inPutView addSubview:self.textView];
    
    emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [emojiBtn setFrame:CGRectMake(237, inPutView.frame.size.height-12-36, 45, 45)];
    [emojiBtn setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
    [inPutView addSubview:emojiBtn];
    [emojiBtn addTarget:self action:@selector(emojiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    

    
    audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [audioBtn setFrame:CGRectMake(-2, inPutView.frame.size.height-12-36, 45, 45)];
    [audioBtn setImage:[UIImage imageNamed:@"audioBtn.png"] forState:UIControlStateNormal];
    [inPutView addSubview:audioBtn];
    [audioBtn addTarget:self action:@selector(audioBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
   
    audioRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [audioRecordBtn setFrame:CGRectMake(40, inPutView.frame.size.height-42, 200, 35)];
    [audioRecordBtn setBackgroundImage:[UIImage imageNamed:@"yanzhengma_normal.png"] forState:UIControlStateNormal];
    [audioRecordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    [inPutView addSubview:audioRecordBtn];
    audioRecordBtn.hidden = YES;
    [audioRecordBtn addTarget:self action:@selector(buttonDown) forControlEvents:UIControlEventTouchDown];

    [audioRecordBtn addTarget:self action:@selector(buttonUp) forControlEvents:UIControlEventTouchUpInside];
    [audioRecordBtn addTarget:self action:@selector(buttonCancel:) forControlEvents:UIControlEventTouchUpOutside];
    [audioRecordBtn addTarget:self action:@selector(buttonCancel:) forControlEvents:UIControlEventTouchCancel];
  /**************   语音图片等
    emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [emojiBtn setFrame:CGRectMake(250, inPutView.frame.size.height-12-27, 25, 27)];
    [emojiBtn setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
    [inPutView addSubview:emojiBtn];
    [emojiBtn addTarget:self action:@selector(emojiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
      ********/
    picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [picBtn setFrame:CGRectMake(275, inPutView.frame.size.height-12-36, 45, 45)];
    [picBtn setImage:[UIImage imageNamed:@"picBtnsec.png"] forState:UIControlStateNormal];
    [inPutView addSubview:picBtn];
    [picBtn addTarget:self action:@selector(picBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
   

    
//    senBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [senBtn setFrame:CGRectMake(282, inPutView.frame.size.height-37.5, 28, 27.5)];
//    [senBtn setImage:[UIImage imageNamed:@"chat_send.png"] forState:UIControlStateNormal];
//    [inPutView addSubview:senBtn];
//    [senBtn addTarget:self action:@selector(sendButton:) forControlEvents:UIControlEventTouchUpInside];

    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
   // [self.messageTextField becomeFirstResponder];
    self.appDel = [[UIApplication sharedApplication] delegate];
    self.appDel.xmppHelper.chatDelegate = self;
    
    btnLongTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLongTapAction:)];
    btnLongTap.minimumPressDuration = 1;
    
    [DataStoreManager blankMsgUnreadCountForUser:self.chatWithUser];
    
    if ([self.chatUserImg isEqualToString:@"no"]) {
        [self getUserInfoWithUserName:self.chatWithUser];
    }
//  语音初始化
    rootRecordPath = [RootDocPath stringByAppendingPathComponent:@"localRecord"];
    rootChatImgPath = [RootDocPath stringByAppendingPathComponent:@"chatImg"];
    self.session = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [self.session setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    
    [self initTwoAudioPlayFrame];
    
    theEmojiView = [[EmojiView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-253, 320, 253) WithSendBtn:YES];
    theEmojiView.delegate = self;
    [self.view addSubview:theEmojiView];
    theEmojiView.hidden = YES;
    
    [self addRecordAnimation];
    
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(copyMsg)];
    UIMenuItem *copyItem2 = [[UIMenuItem alloc] initWithTitle:@"转发"action:@selector(transferMsg)];
    UIMenuItem *copyItem3 = [[UIMenuItem alloc] initWithTitle:@"删除"action:@selector(deleteMsg)];
    menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:[NSArray arrayWithObjects:copyItem,copyItem2,copyItem3, nil]];
//    KKAppDelegate *del = [self appDelegate];
//    del.messageDelegate = self;
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)normalMsgToFinalMsg 
{
    NSMutableArray* formattedEntries = [NSMutableArray arrayWithCapacity:messages.count];
    NSMutableArray* heightArray = [NSMutableArray array];
    for(NSDictionary* plainEntry in messages)
    {
        NSString *message = [plainEntry objectForKey:@"msg"];
        NSMutableAttributedString* mas = [OHASBasicHTMLParser attributedStringByProcessingMarkupInString:message];
        
        OHParagraphStyle* paragraphStyle = [OHParagraphStyle defaultParagraphStyle];
        paragraphStyle.textAlignment = kCTJustifiedTextAlignment;
        paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
        paragraphStyle.firstLineHeadIndent = 0.f; // indentation for first line
        paragraphStyle.lineSpacing = 5.f; // increase space between lines by 3 points
        [mas setParagraphStyle:paragraphStyle];
        [mas setFont:[UIFont systemFontOfSize:15]];
        //            [mas setTextColor:[randomColors objectAtIndex:(idx%5)]];
        [mas setTextAlignment:kCTTextAlignmentLeft lineBreakMode:kCTLineBreakByWordWrapping];
        CGSize size = [mas sizeConstrainedToSize:CGSizeMake(220, CGFLOAT_MAX)];
        NSNumber * width = [NSNumber numberWithFloat:size.width];
        NSNumber * height = [NSNumber numberWithFloat:size.height];
        [formattedEntries addObject:mas];
        NSArray * hh = [NSArray arrayWithObjects:width,height, nil];
        [heightArray addObject:hh];
    }
    self.finalMessageArray = formattedEntries;
    self.HeightArray = heightArray;
}

-(void)audioBtnClicked:(UIButton *)sender
{
    if (!ifAudio) {
        self.textView.text = @"";
        ifAudio = YES;
        [sender setImage:[UIImage imageNamed:@"keyboard.png"] forState:UIControlStateNormal];
        audioRecordBtn.hidden = NO;
        self.textView.hidden = YES;
        [self.textView resignFirstResponder];
        if ([clearView superview]) {
            [clearView removeFromSuperview];
        }
        if ([popLittleView superview]) {
            [popLittleView removeFromSuperview];
        }
        canAdd = YES;
        if (ifEmoji) {
            [self autoMovekeyBoard:0];
            ifEmoji = NO;
            [UIView animateWithDuration:0.2 animations:^{
                [theEmojiView setFrame:CGRectMake(0, theEmojiView.frame.origin.y+260+diffH, 320, 253)];
                
                [m_EmojiScrollView setFrame:CGRectMake(0, m_EmojiScrollView.frame.origin.y+260+diffH, 320, 253)];
                [emojiBGV setFrame:CGRectMake(0, emojiBGV.frame.origin.y+260+diffH, 320, emojiBGV.frame.size.height)];
                [m_Emojipc setFrame:CGRectMake(0, m_Emojipc.frame.origin.y+260+diffH, 320, m_Emojipc.frame.size.height)];
            } completion:^(BOOL finished) {
                theEmojiView.hidden = YES;
                [m_EmojiScrollView removeFromSuperview];
                [emojiBGV removeFromSuperview];
                [m_Emojipc removeFromSuperview];
            }];
            
            [emojiBtn setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        ifAudio = NO;
        [sender setImage:[UIImage imageNamed:@"audioBtn.png"] forState:UIControlStateNormal];
        self.textView.hidden = NO;
        audioRecordBtn.hidden = YES;
        [self.textView.internalTextView becomeFirstResponder];
    }
}
-(void)emojiBtnClicked:(UIButton *)sender
{
    if (!ifEmoji) {
        [self.textView resignFirstResponder];
        ifEmoji = YES;
        ifAudio = NO;
        [sender setImage:[UIImage imageNamed:@"keyboard.png"] forState:UIControlStateNormal];
        [audioBtn setImage:[UIImage imageNamed:@"audioBtn.png"] forState:UIControlStateNormal];
        self.textView.hidden = NO;
        audioRecordBtn.hidden = YES;
        [self showEmojiScrollView];
        
    }
    else
    {
        [self.textView.internalTextView becomeFirstResponder];
        ifEmoji = NO;
        theEmojiView.hidden = YES;
        [m_EmojiScrollView removeFromSuperview];
        [emojiBGV removeFromSuperview];
        [m_Emojipc removeFromSuperview];
        [sender setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
    }
}
-(void)picBtnClicked:(UIButton *)sender
{
//    [self getAudioFromNet:@"A344636A31B2414699376AF299A6B33F"];
    UIActionSheet* addActionSheet = [[UIActionSheet alloc]initWithTitle:@"选择发送图片方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    addActionSheet.tag = actionSheetChoosePic;
    [addActionSheet showInView:self.view];
    
}
-(void)audioRecordBtnClicked:(UIButton *)sender
{
    
}
-(void)initTwoAudioPlayFrame
{
    animationOne=[[NSMutableArray alloc]init] ;
    for(int i=0;i<3;i++){
        NSString *str=nil;
        str=[NSString stringWithFormat:@"ReceiverVoiceNodePlaying00%d.png",i+1];
        UIImage *img=[UIImage imageNamed:str];
        [animationOne addObject:img];
    }
    animationTwo=[[NSMutableArray alloc]init] ;
    for(int i=0;i<3;i++){
        NSString *str=nil;
        str=[NSString stringWithFormat:@"SenderVoiceNodePlaying00%d.png",i+1];
        UIImage *img=[UIImage imageNamed:str];
        [animationTwo addObject:img];
    }
}
-(void)addRecordAnimation
{
    audioplayButton=[UIButton buttonWithType:UIButtonTypeCustom];
    audioplayButton.frame=CGRectMake(80, self.view.frame.size.height/2-80, 160, 160);
    [audioplayButton setImage:[UIImage imageNamed:@"third_xiemessage_record_icon.png"] forState:UIControlStateNormal];
    [self.view addSubview:audioplayButton];
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, 160, 20)];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setFont:[UIFont systemFontOfSize:14]];
    [textLabel setText:@"手指移出按钮取消说话"];
    [audioplayButton addSubview:textLabel];
    audioplayButton.hidden = YES;
    recordAnimationIV=[[UIImageView alloc]initWithFrame:CGRectMake(180, self.view.frame.size.height/2-55, 50, 100)];
    NSMutableArray *arr=[[NSMutableArray alloc]init] ;
    for(int i=1;i<=24;i++){
        NSString *str=nil;
        str=[NSString stringWithFormat:@"third_xiemessage_record_ani%d.png",i];
        UIImage *img=[UIImage imageNamed:str];
        [arr addObject:img];
    }

    recordAnimationIV.animationImages=arr;
    recordAnimationIV.animationDuration=1.0;
    recordAnimationIV.animationRepeatCount=0;
    
    recordAnimationIV.hidden = YES;
    [self.view addSubview:recordAnimationIV];
}
-(void)showRecordAnimation
{
    [recordAnimationIV startAnimating];
    audioplayButton.hidden = NO;
    recordAnimationIV.hidden = NO;
}
-(void)hideRecordAnimation
{
    audioplayButton.hidden = YES;
    recordAnimationIV.hidden = YES;
    [recordAnimationIV stopAnimating];
}
-(void)buttonDown
{
    canSendAudio = NO;
    [audioRecordBtn setTitle:@"松开发送您说的话" forState:UIControlStateNormal];
    beginTime = [[NSDate date] timeIntervalSince1970];
    NSLog(@"recording voice button touchDown");
    [self showRecordAnimation];
    
    [self beginRecord];
    // beginTime =
}
-(void)buttonUp
{
    
    [audioRecordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
    if(endTime-beginTime>0.5)
    {
        canSendAudio = YES;
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"说话时间太短了" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        canSendAudio = NO;
    }
    [self stopRecording];
    [self hideRecordAnimation];

}
-(void)buttonCancel:(UIButton *)sender
{
    [self stopRecording];
    [audioRecordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    [self hideRecordAnimation];
}

-(void)showEmojiScrollView
{
    [self.textView resignFirstResponder];
    [inPutView setFrame:CGRectMake(0, self.view.frame.size.height-227-inPutView.frame.size.height, 320, inPutView.frame.size.height)];
 /*   //表情列表如果存在就隐藏
    //if (m_EmojiScrollView==nil)
    //{
    //将面板先于工具栏加入视图，避免遮挡
    UIImageView *sixGridBGV=[[UIImageView alloc]initWithFrame:CGRectMake(-320, 0, 1280, self.view.frame.size.height-227)];//原来是253
    [sixGridBGV setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
    
    //创建表情视图
    UIScrollView *i_emojiScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,  self.view.frame.size.height-253, 320, self.view.frame.size.height-227)];//原来是227和253
    //设置表情列表scrollview属性
    i_emojiScrollView.backgroundColor=[UIColor yellowColor];
    m_EmojiScrollView = i_emojiScrollView;
    [m_EmojiScrollView addSubview:sixGridBGV];
    m_EmojiScrollView.delegate=self;
    m_EmojiScrollView.bouncesZoom = YES;
    m_EmojiScrollView.pagingEnabled = YES;
    m_EmojiScrollView.showsHorizontalScrollIndicator = NO;
    m_EmojiScrollView.showsVerticalScrollIndicator = NO;
    [m_EmojiScrollView setContentSize:CGSizeMake(960,self.view.frame.size.height-227)];//原来是253
    m_EmojiScrollView.backgroundColor = [UIColor clearColor];
    m_EmojiScrollView.scrollEnabled = YES;
    [self.view addSubview:m_EmojiScrollView];
    [self emojiView];
    //启动pagecontrol
    [self loadPageControl];
    emojiBGV = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-45.5-26.5-10, 320, 45.5+26.5+10)];
    emojiBGV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:emojiBGV];
    UIImageView * ebgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 26.5+10, 320, 45.5)];
    [ebgv setImage:[UIImage imageNamed:@"qqqqq_06.png"]];
    [emojiBGV addSubview:ebgv];
    UIButton * backEmojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backEmojiBtn setFrame:CGRectMake(320-12-49.5, 5, 40.5, 23)];
    [backEmojiBtn setImage:[UIImage imageNamed:@"qqqqq_03.png"] forState:UIControlStateNormal];
    [emojiBGV addSubview:backEmojiBtn];
    [backEmojiBtn addTarget:self action:@selector(backBtnDo) forControlEvents:UIControlEventTouchUpInside];
    UIButton * sendEmojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendEmojiBtn setFrame:CGRectMake(320-12-71.5, 43.5, 71.5, 32)];
    [sendEmojiBtn setImage:[UIImage imageNamed:@"btn_03.png"] forState:UIControlStateNormal];
    [emojiBGV addSubview:sendEmojiBtn];
    [sendEmojiBtn addTarget:self action:@selector(sendButton:) forControlEvents:UIControlEventTouchUpInside];
*/
    theEmojiView.hidden = NO;
    [theEmojiView setFrame:CGRectMake(0, self.view.frame.size.height-253, 320, 253)];
    [self autoMovekeyBoard:253];

}
-(void)backBtnDo
{
    if (self.textView.text.length>=1) {
        self.textView.text = [self.textView.text substringToIndex:(self.textView.text.length-1)];
    }
    
}
-(void)emojiSendBtnDo
{
    [self sendButton:nil];
}
-(void)loadPageControl
{
	//创建并初始化uipagecontrol
	m_Emojipc=[[UIPageControl alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height-70, 280, 20)];
	//设置背景颜色
	m_Emojipc.backgroundColor=[UIColor clearColor];
	//设置pc页数（此时不会同步跟随显示）
	m_Emojipc.numberOfPages=3;
	//设置当前页,为第一张，索引为零
	m_Emojipc.currentPage=0;
	//添加事件处理，btn点击
	[m_Emojipc addTarget:self action:@selector(pagePressed:) forControlEvents:UIControlEventTouchUpInside];
	//将pc添加到视图上
	[self.view addSubview:m_Emojipc];
    NSLog(@"load page control");
}
-(void)emojiView
{
    for (int n = 0; n <=84; n++) {
        UIButton *btn = [[UIButton alloc]init];
        if (n<28) {
            [btn setFrame:CGRectMake(13.75*(n%7+1)+30*(n%7), (n/7+1)*12+30*(n/7), 30, 30)];
        }
        else if(n>=28&&n<56)
            [btn setFrame:CGRectMake(13.75*(n%7+1)+30*(n%7)+320, ((n-28)/7+1)*12+30*((n-28)/7), 30, 30)];
        else
            [btn setFrame:CGRectMake(13.75*(n%7+1)+30*(n%7)+640, ((n-56)/7+1)*12+30*((n-56)/7), 30, 30)];
        [btn setBackgroundColor:[UIColor clearColor]];
        NSString * emojiStr = n+1>=10?[NSString stringWithFormat:@"0%d",n+1]:[NSString stringWithFormat:@"00%d",n+1];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"biaoqing%@.png",emojiStr]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(emojiButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:n];
        
        [m_EmojiScrollView addSubview:btn];
    }
}
-(void)emojiButtonPress:(id)sender
{
	//获取对应的button
	UIButton *selectedButton = (UIButton *) sender;
	int  n = selectedButton.tag;
	//根据button的tag获取对应的图片名
	NSString *facefilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emotionThird.plist"];
	NSDictionary *m_pEmojiDic = [[NSDictionary alloc] initWithContentsOfFile:facefilePath];
	NSString *i_transCharacter = [m_pEmojiDic objectForKey:[NSString stringWithFormat:@"%d",n+1]];
    //提示文字标签隐藏
	//判断输入框是否有内容，追加转义字符
	if (self.textView.text == nil) {
		self.textView.text = [NSString stringWithFormat:@"[%@] ",i_transCharacter];
	}
	else {
		self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"[%@] ",i_transCharacter]];
	}
    [self autoMovekeyBoard:253];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	float a=m_EmojiScrollView.contentOffset.x;
	int page=floor((a-320/2)/320)+1;
	m_Emojipc.currentPage=page;
}


-(void)getUserInfoWithUserName:(NSString *)userNameit
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict2 = [NSMutableDictionary dictionary];
    [paramDict setObject:userNameit forKey:@"username"];
    [postDict2 setObject:paramDict forKey:@"params"];
    [postDict2 setObject:@"1" forKey:@"channel"];
    [postDict2 setObject:@"getUserinfo" forKey:@"method"];
    [postDict2 setObject:@"service.uri.pet_user" forKey:@"service"];
    [postDict2 setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict2 setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [postDict2 setObject:@"iphone" forKey:@"imei"];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict2 setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict2 TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * recDict = responseObject;
        [DataStoreManager saveUserInfo:recDict];
        self.chatUserImg = [self getHead:[recDict objectForKey:@"img"]];
        self.nickName = [recDict objectForKey:@"nickname"];
        titleLabel.text=self.nickName;
        [self.tView reloadData];
  
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(NSString *)getHead:(NSString *)headStr
{
    NSArray* i = [headStr componentsSeparatedByString:@","];

    NSArray *arr = [[i objectAtIndex:0] componentsSeparatedByString:@"_"];
    if (arr.count>1) {
        return arr[0];
    }
    return @"";

}
-(void)moreOperation
{
    UIActionSheet* action = [[UIActionSheet alloc]initWithTitle:@"你要做什么" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除聊天记录" otherButtonTitles: nil];
    action.tag = actionSheetMore;
    [action showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        if (actionSheet.tag==actionSheetMore) {
            UIAlertView * delAlert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"确定要删除聊天记录么，删除了就不可恢复了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
            delAlert.tag = 112;
            [delAlert show];
        }
        else
        {
            UIImagePickerController * imagePicker;
            if (imagePicker==nil) {
                imagePicker=[[UIImagePickerController alloc]init];
                imagePicker.delegate=self;
//                imagePicker.allowsEditing = YES;
            }
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                //                    [self presentModalViewController:imagePicker animated:YES];
                [self presentViewController:imagePicker animated:YES completion:^{
                    
                }];
            }
            else {
                UIAlertView *cameraAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备不支持相机" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
                [cameraAlert show];
            }

        }


    }
    else if(buttonIndex==1)
    {
        if (actionSheet.tag==actionSheetChoosePic) {
            UIImagePickerController * imagePicker;
            if (imagePicker==nil) {
                imagePicker=[[UIImagePickerController alloc]init];
                imagePicker.delegate=self;
//                imagePicker.allowsEditing = YES;
            }
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                //                    [self presentModalViewController:imagePicker animated:YES];
                [self presentViewController:imagePicker animated:YES completion:^{
                    
                }];
            }
            else {
                UIAlertView *libraryAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备不支持相册" delegate:self cancelButtonTitle:@"了解" otherButtonTitles:nil];
                [libraryAlert show];
            }

        }
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage*selectImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self sendingImage:selectImage];
    //修改相册封面，未完待续

}
-(void)sendingImage:(UIImage *)theImage
{
    UIImage * a = [NetManager compressImageDownToPhoneScreenSize:theImage targetSizeX:80 targetSizeY:80];
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:rootChatImgPath] == NO)
    {
        [fm createDirectoryAtPath:rootChatImgPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString * imageUUID = gen_uuid();
    NSString * sendingID = [NSString stringWithFormat:@"%@_%f_%f",imageUUID,a.size.width,a.size.height];
    //            NSURL * myRecordPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.caf",rootRecordPath,theAudioID]];
    //            [data writeToURL:myRecordPath atomically:YES];
    [UIImageJPEGRepresentation(a, 0.6) writeToFile:[NSString stringWithFormat:@"%@/compress_%@.jpg",rootChatImgPath,imageUUID] atomically:YES];
    [UIImageJPEGRepresentation(theImage, 0.6) writeToFile:[NSString stringWithFormat:@"%@/origin_%@.jpg",rootChatImgPath,imageUUID] atomically:YES];


    [self tempSendFileMsgWithFileID:sendingID MsgID:imageUUID FileType:@"img" Status:@"sending"];
    int imgIndex = messages.count-1;
    indexPathTo = [NSIndexPath indexPathForRow:imgIndex inSection:0];
    KKMessageCell * cell = (KKMessageCell *)[self.tView cellForRowAtIndexPath:indexPathTo];
    double maskH = cell.maskContentImgV.frame.size.height;
    [NetManager chatUploadImage:theImage WithURLStr:BaseUploadImageUrl ImageName:@"CoverImage" TheController:self Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"a:%d,b:%lld,c:%lld",bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
        double bytesE = (double)totalBytesWritten/(double)totalBytesExpectedToWrite;
        [cell.maskContentImgV setFrame:CGRectMake(cell.maskContentImgV.frame.origin.x, cell.maskContentImgV.frame.origin.y, cell.maskContentImgV.frame.size.width, maskH-maskH*bytesE)];
        cell.progressLabel.frame = CGRectMake(cell.bgImageView.frame.origin.x, cell.bgImageView.frame.origin.y+cell.bgImageView.frame.size.height/2-10, cell.bgImageView.frame.size.width, 20);
        cell.progressLabel.text = [NSString stringWithFormat:@"%.0f%%",bytesE*100];
        NSLog(@"bytes written:%@,FRame:%f",cell.progressLabel.text,maskH*bytesE);
//        cell.messageContentView.textAlignment = NSTextAlignmentCenter;
        
    } Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self finalSendMsgWithFileID:[NSString stringWithFormat:@"%@_%f_%f",responseObject,a.size.width,a.size.height] MsgID:imageUUID FileType:@"img"];
        [UIImageJPEGRepresentation(a, 0.6) writeToFile:[NSString stringWithFormat:@"%@/compress_%@.jpg",rootChatImgPath,responseObject] atomically:YES];
        [UIImageJPEGRepresentation(theImage, 0.6) writeToFile:[NSString stringWithFormat:@"%@/origin_%@.jpg",rootChatImgPath,responseObject] atomically:YES];
        cell.progressLabel.text = @"";
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self finalMsgFailedSendWithFileID:sendingID MsgID:imageUUID FileType:@"img"];
        cell.progressLabel.text = @"";
    }];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

-(void)toContactProfile
{
    PersonDetailViewController * detailV = [[PersonDetailViewController alloc] init];
    HostInfo * hostInfo = [[HostInfo alloc] initWithNewHostInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.nickName?self.nickName:self.chatWithUser,@"nickname",self.chatWithUser,@"username", nil] PetsArray:nil];
    detailV.hostInfo = hostInfo;
    detailV.needRequest = YES;
    detailV.friendStatus = self.friendStatus;
    [self.navigationController pushViewController:detailV animated:YES];
    [self.customTabBarController hidesTabBar:YES animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendButton:nil];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    if ([touch view]==clearView) {
        [self.textView resignFirstResponder];
        if (ifEmoji) {
            [self autoMovekeyBoard:0];
            ifEmoji = NO;
            [UIView animateWithDuration:0.2 animations:^{
                [theEmojiView setFrame:CGRectMake(0, theEmojiView.frame.origin.y+260+diffH, 320, 253)];
                
                [m_EmojiScrollView setFrame:CGRectMake(0, m_EmojiScrollView.frame.origin.y+260, 320, 253)];
                [emojiBGV setFrame:CGRectMake(0, emojiBGV.frame.origin.y+260+diffH, 320, emojiBGV.frame.size.height)];
                [m_Emojipc setFrame:CGRectMake(0, m_Emojipc.frame.origin.y+260+diffH, 320, m_Emojipc.frame.size.height)];
            } completion:^(BOOL finished) {
                theEmojiView.hidden = YES;
                [m_EmojiScrollView removeFromSuperview];
                [emojiBGV removeFromSuperview];
                [m_Emojipc removeFromSuperview];
            }];

            [emojiBtn setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
        }
        
        [clearView removeFromSuperview];
        if ([popLittleView superview]) {  
            [popLittleView removeFromSuperview];
        }
        canAdd = YES;
    }
    

 
}

- (void)viewDidUnload
{
    [self setTView:nil];
    [self setMessageTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
#pragma mark -
#pragma mark Responding to keyboard events
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if(textField == self.messageTextField)
	{
        //		[self moveViewUp];
	}
}

-(void) autoMovekeyBoard: (float) h{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
	//inPutView.frame = CGRectMake(0.0f, (float)(self.view.frame.size.height-h-inPutView.frame.size.height), 320.0f, inPutView.frame.size.height);

    
    CGRect containerFrame = inPutView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (h + containerFrame.size.height);
	// animations settings

	
	// set views with new info
	inPutView.frame = containerFrame;
    
	
	// commit animations


//	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
//	tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f,(float)(480.0-h-108.0));
    [UIView commitAnimations];
    self.tView.frame = CGRectMake(0.0f, 44+diffH, 320.0f, self.view.frame.size.height-(44+diffH)-inPutView.frame.size.height-h);
    if (messages.count>0) {
        [self.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    if (h>0&&canAdd) {
        canAdd = NO;
        clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-(44+diffH)-inPutView.frame.size.height-h)];
        [clearView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:clearView];
    }
    if ([clearView superview]) {
        [clearView setFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-(44+diffH)-inPutView.frame.size.height-h)];
    }


}
#pragma mark -
#pragma mark HPExpandingTextView delegate
//改变键盘高度
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = inPutView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	inPutView.frame = r;
    
    if ([clearView superview]) {
        [clearView setFrame:CGRectMake(0, 44+diffH, 320, clearView.frame.size.height+diff)];
    }
    self.tView.frame = CGRectMake(0.0f, 44+diffH, 320.0f, self.tView.frame.size.height+diff);
    if (messages.count>0) {
        [self.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    //    [senBtn setFrame:CGRectMake(282, inPutView.frame.size.height-37.5, 28, 27.5)];
    [picBtn setFrame:CGRectMake(275, inPutView.frame.size.height-12-36, 45, 45)];
    [emojiBtn setFrame:CGRectMake(237, inPutView.frame.size.height-12-36, 45, 45)];
    [audioBtn setFrame:CGRectMake(-2, inPutView.frame.size.height-12-36, 45, 45)];
}

-(BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [self sendButton:nil];
    return YES;
}
#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    ifEmoji = NO;
    theEmojiView.hidden = YES;
    [m_EmojiScrollView removeFromSuperview];
    [emojiBGV removeFromSuperview];
    [m_Emojipc removeFromSuperview];
    [emojiBtn setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
    if ([clearView superview]) {
        [clearView removeFromSuperview];
    }
    if ([popLittleView superview]) {
        [popLittleView removeFromSuperview];
    }
    canAdd = YES;
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self autoMovekeyBoard:keyboardRect.size.height];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
   
        [self autoMovekeyBoard:0];
 

}
-(NSString *)selectedEmoji:(NSString *)ssss
{
	if (self.textView.text == nil) {
		self.textView.text = ssss;
	}
	else {
		self.textView.text = [self.textView.text stringByAppendingString:ssss];
	}

    return 0;
}
-(void)deleteEmojiStr
{
    if (self.textView.text.length>=1) {
        self.textView.text = [self.textView.text substringToIndex:(self.textView.text.length-1)];
    }
}
-(void)addEmojiScrollView
{
    if (self.textView.text.length>=1) {
        self.textView.text = [self.textView.text substringToIndex:(self.textView.text.length-1)];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [messages count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"msgCell";
    
    KKMessageCell *cell =(KKMessageCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[KKMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSMutableDictionary *dict = [messages objectAtIndex:indexPath.row];
    NSString *sender = [dict objectForKey:@"sender"];
    NSString *time = [dict objectForKey:@"time"];
    NSString *msgType = [dict objectForKey:@"fileType"];
    
    cell.messageContentView.attributedText = [self.finalMessageArray objectAtIndex:indexPath.row];

//    CGSize size = [cell.messageContentView sizeThatFits:CGSizeMake(220, CGFLOAT_MAX)];
    CGSize size = CGSizeMake([[[self.HeightArray objectAtIndex:indexPath.row] objectAtIndex:0] floatValue], [[[self.HeightArray objectAtIndex:indexPath.row] objectAtIndex:1] floatValue]);
   // CGSize size = [cell.messageContentView.attributedText sizeConstrainedToSize:CGSizeMake(220, CGFLOAT_MAX)];
    size.width = size.width<20?20:size.width;
    size.height = size.height<20?20:size.height;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // cell.userInteractionEnabled = NO;
    
    UIImage *bgImage = nil;

    if ([sender isEqualToString:@"you"]) {
        cell.headImgV.placeholderImage = [UIImage imageNamed:@"moren_people.png"];
        NSURL * theUrl = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",myHeadImg]];
        cell.headImgV.imageURL = theUrl;
        [cell.headImgV setFrame:CGRectMake(320-10-40, padding*2-15, 40, 40)];
        bgImage = [[UIImage imageNamed:@"bubble_02.png"]
                   stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        [cell.headBtn setFrame:cell.headImgV.frame];
        
        [cell.headBtn addTarget:self action:@selector(myBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [cell.bgImageView setBackgroundImage:bgImage forState:UIControlStateNormal];
        [cell.bgImageView setTag:(indexPath.row+1)];
        [cell.bgImageView addTarget:self action:@selector(offsetButtonTouchBegin:) forControlEvents:UIControlEventTouchDown];
        [cell.bgImageView addTarget:self action:@selector(offsetButtonTouchEnd:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if ([msgType isEqualToString:@"audio"]) {
            NSArray * audioFile = [self getFileIDAndSize:[dict objectForKey:@"msg"]];
            int theDuration = [audioFile[1] intValue]+1;
            int dW = 220*theDuration/60;
            float theW = dW>45?(float)dW:45.0f;
            cell.messageContentView.attributedText = nil;
            [cell.messageContentView setFrame:CGRectMake(320-theW- padding-15-10-25+3, padding*2-9, 40, 30)];
            cell.messageContentView.text = [NSString stringWithFormat:@"%d'",theDuration];
//            cell.messageContentView.backgroundColor = [UIColor redColor];
            [cell.bgImageView setFrame:CGRectMake(320-theW - padding-20-10-25, padding*2-15, theW+20, 35)];
            [cell.playAudioImageV setFrame:CGRectMake(320-10-40-35, padding*2-9, 20, 20)];
            [cell.playAudioImageV setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying003@2x"]];
            cell.playAudioImageV.hidden = NO;
            [cell.activityV setFrame:CGRectMake(320-theW - padding-20-10-25-33, padding*2-15+3, 30, 30)];
            if ([[dict objectForKey:@"status"] isEqualToString:@"sending"]) {
                
                [cell.activityV startAnimating];
            }
            else if ([[dict objectForKey:@"status"] isEqualToString:@"sended"]){
                [cell.activityV stopAnimating];
                
            }
            else
            {
                [cell.activityV stopAnimating];
               
            }
            cell.ifRead.hidden = YES;
            cell.contentImgV.hidden = YES;
            cell.maskContentImgV.hidden = YES;
            
        }
        else if ([msgType isEqualToString:@"img"]){
            NSArray * imgFile = [self getFileIDAndSize:[dict objectForKey:@"msg"]];
            float imgW = [imgFile[1] floatValue];
            float imgH = [imgFile[2] floatValue];
            cell.messageContentView.attributedText = nil;
            [cell.messageContentView setFrame:CGRectMake(320-imgW- padding-15-10-25+3+10, padding*2-9, 40, 30)];
            [cell.bgImageView setFrame:CGRectMake(320-imgW - padding-20-10-25-10+10, padding*2-15, imgW+20, imgH+10)];
            cell.contentImgV.hidden = NO;
            [cell.contentImgV setFrame:CGRectMake(320-imgW - padding-20-10-25-4.5+10, padding*2-15+5, imgW, imgH)];
            [cell.activityV setFrame:CGRectMake(320-imgW - padding-20-10-25-10-33+10, padding*2-15+3, 30, 30)];
            if ([[dict objectForKey:@"status"] isEqualToString:@"sending"]) {
                [cell.activityV startAnimating];
                cell.maskContentImgV.hidden = NO;
                cell.maskContentImgV.backgroundColor = [UIColor blackColor];
                cell.maskContentImgV.alpha = 0.65;
                cell.maskContentImgV.frame = cell.contentImgV.frame;
            }
            else if ([[dict objectForKey:@"status"] isEqualToString:@"sended"]){
                [cell.activityV stopAnimating];
                cell.maskContentImgV.hidden = YES;
            }
            else
            {
                [cell.activityV stopAnimating];
                cell.maskContentImgV.hidden = NO;
                cell.maskContentImgV.frame = cell.contentImgV.frame;
            }

            NSString *path = [NSString stringWithFormat:@"%@/compress_%@.jpg",rootChatImgPath,imgFile[0]];
            UIImage * tempImg = [UIImage imageWithContentsOfFile:path];
            if (tempImg) {
                [cell.contentImgV setImage:tempImg];
            }
            else
            {
                cell.contentImgV.backgroundColor = [UIColor lightGrayColor];
                cell.contentImgV.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@/%d",imgFile[0],[imgFile[1] intValue]]];
            }
            cell.playAudioImageV.hidden = YES;
            cell.ifRead.hidden = YES;
//            UIImage * hImg = [
        }
        else{
            cell.ifRead.hidden = YES;
            cell.contentImgV.hidden = YES;
            [cell.messageContentView setFrame:CGRectMake(320-size.width - padding-15-10-25, padding*2-10, size.width, size.height)];
            [cell.bgImageView setFrame:CGRectMake(320-size.width - padding-20-10-25, padding*2-15, size.width+20, size.height+10)];
            cell.playAudioImageV.hidden = YES;
            cell.maskContentImgV.hidden = YES;


        }
    }else {
        [cell.headImgV setFrame:CGRectMake(10, padding*2-15, 40, 40)];
        [cell.chattoHeadBtn setFrame:cell.headImgV.frame];
        [cell.chattoHeadBtn addTarget:self action:@selector(chatToBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        cell.headImgV.placeholderImage = [UIImage imageNamed:@"moren_people.png"];
        NSURL * theUrl = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",self.chatUserImg]];
        cell.headImgV.imageURL = theUrl;
        bgImage = [[UIImage imageNamed:@"bubble_01.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        [cell.bgImageView setBackgroundImage:bgImage forState:UIControlStateNormal];
        [cell.bgImageView setTag:(indexPath.row+1)];
        [cell.bgImageView addTarget:self action:@selector(offsetButtonTouchBegin:) forControlEvents:UIControlEventTouchDown];
        [cell.bgImageView addTarget:self action:@selector(offsetButtonTouchEnd:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([msgType isEqualToString:@"audio"]) {
            NSArray * audioFile = [self getFileIDAndSize:[dict objectForKey:@"msg"]];
            int theDuration = [audioFile[1] intValue]+1;
            int dW = 220*theDuration/60;
            float theW = dW>45?(float)dW:45.0f;
            cell.messageContentView.attributedText = nil;
            [cell.messageContentView setFrame:CGRectMake(padding+5+45+theW-20, padding*2-9+3-3, 40, 30)];
            cell.messageContentView.text = [NSString stringWithFormat:@"%d'",theDuration];
            
            [cell.bgImageView setFrame:CGRectMake(padding-10+45, padding*2-10-2-3, theW+20, 35)];
            [cell.playAudioImageV setFrame:CGRectMake(padding-10+45+10, padding*2-9+3-3, 20, 20)];
            [cell.playAudioImageV setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying@2x"]];
            cell.playAudioImageV.hidden = NO;
            [cell.activityV setFrame:CGRectMake(padding-10+45+theW+5, padding*2-15+3, 30, 30)];
            [cell.activityV stopAnimating];
            if ([[dict objectForKey:@"readed"] isEqualToString:@"NO"]) {
                cell.ifRead.hidden = NO;
                [cell.ifRead setFrame:CGRectMake(padding-10+45+theW+23, padding*2-10+11, 15, 15)];
            }
            else
            {
                cell.ifRead.hidden = YES;
            }
            cell.contentImgV.hidden = YES;
            cell.maskContentImgV.hidden = YES;

        }
        else if ([msgType isEqualToString:@"img"]){
            NSArray * imgFile = [self getFileIDAndSize:[dict objectForKey:@"msg"]];
            float imgW = [imgFile[1] floatValue];
            float imgH = [imgFile[2] floatValue];
            cell.messageContentView.attributedText = nil;
            [cell.messageContentView setFrame:CGRectMake(padding+5+45+imgW-20, padding*2-9, 40, 30)];
            [cell.bgImageView setFrame:CGRectMake(padding-10+45, padding*2-15, imgW+20, imgH+10)];
            cell.contentImgV.hidden = NO;
            [cell.contentImgV setFrame:CGRectMake(padding-10+45+13, padding*2-15+5, imgW, imgH)];
            [cell.activityV setFrame:CGRectMake(padding-10+45+imgW+10+5, padding*2-15+3, 30, 30)];
            if ([[dict objectForKey:@"status"] isEqualToString:@"sending"]) {
                [cell.activityV startAnimating];
                cell.maskContentImgV.hidden = NO;
                cell.maskContentImgV.backgroundColor = [UIColor blackColor];
                cell.maskContentImgV.alpha = 0.65;
                cell.maskContentImgV.frame = cell.contentImgV.frame;
            }
            else if ([[dict objectForKey:@"status"] isEqualToString:@"sended"]){
                [cell.activityV stopAnimating];
                cell.maskContentImgV.hidden = YES;
            }
            else
            {
                [cell.activityV stopAnimating];
                cell.maskContentImgV.hidden = NO;
                cell.maskContentImgV.frame = cell.contentImgV.frame;
            }
            
            cell.contentImgV.backgroundColor = [UIColor lightGrayColor];
            cell.contentImgV.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@/%d",imgFile[0],[imgFile[1] intValue]]];
        
            cell.playAudioImageV.hidden = YES;
            cell.ifRead.hidden = YES;
            //            UIImage * hImg = [
        }

        else{
            cell.ifRead.hidden = YES;
            cell.contentImgV.hidden = YES;
            [cell.messageContentView setFrame:CGRectMake(padding+5+45, padding*2-5-3, size.width, size.height)];
            [cell.bgImageView setFrame:CGRectMake(padding-10+45, padding*2-10-3, size.width+20, size.height+10)];
            cell.playAudioImageV.hidden = YES;
            cell.maskContentImgV.hidden = YES;
 
        }
    }
    
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    
    if (indexPath.row>0) {
        NSLog(@"mmmm:%d",[time intValue]-[[[messages objectAtIndex:(indexPath.row-1)] objectForKey:@"time"] intValue]);
        if ([time intValue]-[[[messages objectAtIndex:(indexPath.row-1)] objectForKey:@"time"] intValue]<60) {
            cell.senderAndTimeLabel.hidden = YES;
        }
        else
        {
            cell.senderAndTimeLabel.hidden = NO;
        }
    }
    previousTime = nowTime;
    NSString * timeStr = [self CurrentTime:[NSString stringWithFormat:@"%d",(int)nowTime] AndMessageTime:[NSString stringWithFormat:@"%d",[time intValue]]];
    if ([sender isEqualToString:@"you"]) {
        cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", @"我", timeStr];
        CGRect rect = [self.view convertRect:cell.frame fromView:self.tView];
        NSLog(@"dsdsdsdsdsd%@",NSStringFromCGRect(rect));
    }
    else
    {
        cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", self.nickName, timeStr];
        CGRect rect = [self.view convertRect:cell.frame fromView:self.tView];
        NSLog(@"dsdsdsdsdsd%@",NSStringFromCGRect(rect));
    }
    
    return cell;
    
}
-(NSArray *)getFileIDAndSize:(NSString *)msgBody
{
    NSArray *fileArray = [msgBody componentsSeparatedByString:@"_"];
    return fileArray;
}
-(void)chatToBtnClicked
{
    [self toContactProfile];
}
-(void)myBtnClicked
{
    MyProfileViewController * myP = [[MyProfileViewController alloc] init];
    myP.hostInfo = [[HostInfo alloc] initWithHostInfo:[DataStoreManager queryMyInfo]];
    [self.navigationController pushViewController:myP animated:YES];
}
-(void)offsetButtonTouchBegin:(UIButton *)sender
{
    touchTimePre = [[NSDate date] timeIntervalSince1970];
    tempBtn = sender;
    NSLog(@"begin");
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(endIt:) userInfo:nil repeats:NO];
    
}
-(void)offsetButtonTouchEnd:(UIButton *)sender
{
    if ([[NSDate date] timeIntervalSince1970]-touchTimePre<0.5) {
        NSMutableDictionary *dict = [messages objectAtIndex:(tempBtn.tag-1)];
        NSString *msgType = [dict objectForKey:@"fileType"];
        if ([msgType isEqualToString:@"audio"]) {
            readyIndex = tempBtn.tag-1;
            NSArray * audioFile = [self getFileIDAndSize:[dict objectForKey:@"msg"]];
            NSString * audiofileID = audioFile[0];
            NSString  *localRecordPath = [NSString stringWithFormat:@"%@/%@.caf",rootRecordPath,audiofileID];
            NSFileManager *fm = [NSFileManager defaultManager];
            if([fm fileExistsAtPath:localRecordPath] == NO){
                [self getAudioFromNet:audiofileID];
            }
            else
                [self playAudioWithAudioID:audiofileID];
  
            
        }
        else if ([msgType isEqualToString:@"img"]){
            readyIndex = tempBtn.tag-1;
            NSArray * imgFile = [self getFileIDAndSize:[dict objectForKey:@"msg"]];
            NSString * imgfileID = imgFile[0];
            NSString * imgfilePath = [NSString stringWithFormat:@"%@/origin_%@.jpg",rootChatImgPath,imgfileID];
            NSFileManager *fm = [NSFileManager defaultManager];
            if([fm fileExistsAtPath:imgfilePath] == YES){
//                PhotoViewController * pv = [[PhotoViewController alloc] initWithPath:imgfilePath];
//                [self.navigationController presentViewController:pv animated:NO completion:^{
//                    
//                }];
            }
            else
            {
//                NSArray * iA = [NSArray arrayWithObject:imgfileID];
//                PhotoViewController * pv = [[PhotoViewController alloc] initWithSmallImages:nil images:iA indext:0];
//                [self.navigationController presentViewController:pv animated:NO completion:^{
//                    
//                }];
            }

        }
        else
        {
            
        }
    }
    NSLog(@"end");
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
//    return (action == @selector(copyMsg));
//    return (action == @selector(transferMsg));
//    return (action == @selector(deleteMsg));
    if (action == @selector(copyMsg) || action == @selector(transferMsg) || action == @selector(deleteMsg))
    {
        return YES;
    }
    else
        return NO;
}
-(void)endIt:(UIButton *)sender
{
    if (tempBtn.highlighted == YES) {
        NSLog(@"haha");
        indexPathTo = [NSIndexPath indexPathForRow:(tempBtn.tag-1) inSection:0];
        KKMessageCell * cell = (KKMessageCell *)[self.tView cellForRowAtIndexPath:indexPathTo];
        tempStr = [[messages objectAtIndex:indexPathTo.row] objectForKey:@"msg"];
        CGRect rect = [self.view convertRect:tempBtn.frame fromView:cell.contentView];
        NSLog(@"ssasasasasa%@",NSStringFromCGRect(rect));
        readyIndex = tempBtn.tag-1;

//        [self displayPopLittleViewWithRectX:(rect.origin.x+(rect.size.width-182)/2) RectY:rect.origin.y-54 TheRect:rect];
        
        [self canBecomeFirstResponder];
        [self becomeFirstResponder];
        [menu setTargetRect:CGRectMake(rect.origin.x, rect.origin.y, 60, 90) inView:self.view];
        [menu setMenuVisible:YES animated:YES];
    }

    //[yy setBackgroundImage:nil forState:UIControlStateNormal];
}
-(void)displayPopLittleViewWithRectX:(float)originX RectY:(float)originY TheRect:(CGRect)rect
{
    if ([popLittleView superview]) {
        
        [popLittleView removeFromSuperview];
        
    }
    if (![clearView superview]) {
        clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height-(44+diffH)-50)];
        [clearView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:clearView];
    }


    popLittleView = [[UIView alloc] initWithFrame:CGRectMake(originX, originY+diffH, 182, 54.5)];
    UIImageView * popBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 182, 54.5)];
    [popBG setImage:[UIImage imageNamed:@"popview2.png"]];
    [popLittleView addSubview:popBG];
    [self.view addSubview:popLittleView];
//    for (int i = 0; i<3; ++i) {
//        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setFrame:CGRectMake(10+i*50+i*10, 10, 50, 35)];
//        [btn setBackgroundImage:[UIImage imageNamed:@"selectednormal-s.png"] forState:UIControlStateNormal];
//        [btn setTitle:@"转发" forState:UIControlStateNormal];
//        [popLittleView addSubview:btn];
//    }
    btnBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 182, 45)];
    [btnBG setBackgroundColor:[UIColor clearColor]];
    [popLittleView addSubview:btnBG];
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:CGRectMake(10, 10, 50, 25)];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"selectednormal-s.png"] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn1 setTitle:@"复制" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(copyMsg) forControlEvents:UIControlEventTouchUpInside];

    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setFrame:CGRectMake(68, 10, 50, 25)];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"selectednormal-s.png"] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn2 setTitle:@"转发" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(transferMsg) forControlEvents:UIControlEventTouchUpInside];

    UIButton * btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 setFrame:CGRectMake(126, 10, 50, 25)];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"selectednormal-s.png"] forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn3 setTitle:@"删除" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(deleteMsg) forControlEvents:UIControlEventTouchUpInside];
    [btnBG addSubview:btn1];
    [btnBG addSubview:btn2];
    [btnBG addSubview:btn3];
    if (originX+182>320) {
        originX = originX-(originX+182-320);
        [popLittleView setFrame:CGRectMake(originX, originY+diffH, 182, 54.5)];
    }
    else if (originX<0)
    {
        [popLittleView setFrame:CGRectMake(0, originY+diffH, 182, 54.5)];
    }
    if (originY<(44+diffH)) {
        originY = originY+54.5+rect.size.height;
        [popLittleView setFrame:CGRectMake(originX, originY+diffH, 182, 54.5)];
        CGAffineTransform atransform;
        atransform = CGAffineTransformRotate(popLittleView.transform, M_PI);
        popLittleView.transform =  atransform;
        
        CGAffineTransform atransform2;
        atransform2 = CGAffineTransformRotate(btnBG.transform, M_PI);
        btnBG.transform =  atransform2;
    }
    
//    if (originY-54.5-rect.size.height<44) {
//
//    }


}
-(void)copyMsg
{
    [popLittleView removeFromSuperview];
    if ([clearView superview]) {
        [clearView removeFromSuperview];
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = tempStr;
}
-(void)transferMsg
{
    [popLittleView removeFromSuperview];
    if ([clearView superview]) {
        [clearView removeFromSuperview];
    }
    selectContactPage * selectV = [[selectContactPage alloc] init];
    selectV.contactDelegate = self;
    [self presentViewController:selectV animated:YES completion:^{
        
    }];
    [self.customTabBarController hidesTabBar:YES animated:NO];
    
}
-(void)getContact:(NSDictionary *)userDict
{
    tempDict = userDict;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定要转发给%@吗",[userDict objectForKey:@"displayName"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if (alertView.tag==112) {
            [DataStoreManager deleteMsgsWithSender:self.chatWithUser Type:COMMONUSER];
            messages = [DataStoreManager qureyAllCommonMessages:self.chatWithUser];
            [self normalMsgToFinalMsg];
            [self.tView reloadData];
        }
        else
            [self sureToTransform:tempDict];
    }
}
-(void)sureToTransform:(NSDictionary *)userDict
{
    self.chatWithUser = [userDict objectForKey:@"username"];
    self.nickName = [userDict objectForKey:@"displayName"];
    self.chatUserImg = [userDict objectForKey:@"img"];
    titleLabel.text=self.nickName;
    
    self.ifFriend = YES;
    if (![DataStoreManager ifHaveThisFriend:self.chatWithUser]) {
        self.ifFriend = NO;
    }
    messages = [DataStoreManager qureyAllCommonMessages:self.chatWithUser];
    [self normalMsgToFinalMsg];
    [DataStoreManager blankMsgUnreadCountForUser:self.chatWithUser];
    [self sendMsg:tempStr];
    [self.tView reloadData];
}
-(void)deleteMsg
{
    [popLittleView removeFromSuperview];
    if ([clearView superview]) {
        [clearView removeFromSuperview];
    }
    [DataStoreManager deleteCommonMsg:[[messages objectAtIndex:readyIndex] objectForKey:@"msg"] Time:[[messages objectAtIndex:readyIndex] objectForKey:@"time"]];
     [messages removeObjectAtIndex:readyIndex];
    [self.finalMessageArray removeObjectAtIndex:readyIndex];
    if (messages.count>0) {
        [DataStoreManager refreshThumbMsgsAfterDeleteCommonMsg:[messages lastObject] ForUser:self.chatWithUser ifDel:NO];
    }
    else
        [DataStoreManager refreshThumbMsgsAfterDeleteCommonMsg:[messages lastObject] ForUser:self.chatWithUser ifDel:YES];
    [self normalMsgToFinalMsg];
    [self.tView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPathTo] withRowAnimation:UITableViewRowAnimationRight];
    [self.tView reloadData];

}
-(void)btnLongTapAction:(UILongPressGestureRecognizer *)gestureRecognizer
{if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) 
    NSLog(@"222");
}
-(void)longPress:(UIButton*)sender
{
    
}

//每一行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dict  = [messages objectAtIndex:indexPath.row];
//    NSString *msg = [dict objectForKey:@"msg"];
    NSString *msgType = [dict objectForKey:@"fileType"];
//    CGSize textSize = {260.0-10-30 , 10000.0};
//    CGSize size = [msg sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
 //   NSAttributedString* attrStr = [self.finalMessageArray objectAtIndex:indexPath.row];
//    CGSize size = [attrStr sizeConstrainedToSize:CGSizeMake(220, CGFLOAT_MAX)];
    float theH = [[[self.HeightArray objectAtIndex:indexPath.row] objectAtIndex:1] floatValue];
    if ([msgType isEqualToString:@"audio"]) {
        theH = 35;
    }
    else if([msgType isEqualToString:@"img"]){
        NSArray * imgFile = [self getFileIDAndSize:[dict objectForKey:@"msg"]];
        float imgH = [imgFile[2] floatValue];
        theH = imgH;
    }
    theH += padding*2;

    CGFloat height = theH < 65 ? 65 : theH;
    
    return height;
    
}

- (void)sendButton:(id)sender {
    
    //本地输入框中的信息
    NSString *message = self.textView.text;
    [self sendMsg:message];
  
}
-(void)sendMsg:(NSString *)message
{
    if (message.length > 0) {
        if (!self.ifFriend) {
            [self.appDel.xmppHelper addOrDenyFriend:YES user:self.chatWithUser];
            [DataStoreManager addFriendToLocal:self.chatWithUser];
            [DataStoreManager updateReceivedHellosStatus:@"accept" ForPerson:self.chatWithUser];
            NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
            [body setStringValue:[NSString stringWithFormat:@"我是%@，我们已经是朋友啦!",[DataStoreManager queryNickNameForUser:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]]];
            
            //生成XML消息文档
            NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
            //   [mes addAttributeWithName:@"nickname" stringValue:@"aaaa"];
            //消息类型
            [mes addAttributeWithName:@"type" stringValue:@"chat"];
            
            //发送给谁
            [mes addAttributeWithName:@"to" stringValue:[self.chatWithUser stringByAppendingString:[[TempData sharedInstance] getDomain]]];
            //   NSLog(@"chatWithUser:%@",chatWithUser);
            //由谁发送
            [mes addAttributeWithName:@"from" stringValue:[[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] stringByAppendingString:[[TempData sharedInstance] getDomain]]];
            
            [mes addAttributeWithName:@"msgtype" stringValue:@"normalchat"];
            [mes addAttributeWithName:@"fileType" stringValue:@"text"];  //如果发送图片音频改这里
            [mes addAttributeWithName:@"msgTime" stringValue:[Common getCurrentTime]];
            [mes addChild:body];
            if (![self.appDel.xmppHelper sendMessage:mes]) {
                [KGStatusBar showSuccessWithStatus:@"网络有点问题，稍后再试吧" Controller:self];
                //Do something when send failed...
                return;
            }
            
            
            
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            
            [dictionary setObject:[NSString stringWithFormat:@"我添加了%@为好友",self.nickName] forKey:@"msg"];
            [dictionary setObject:@"you" forKey:@"sender"];
            //加入发送时间
            [dictionary setObject:[Common getCurrentTime] forKey:@"time"];
            [dictionary setObject:self.chatWithUser forKey:@"receiver"];
            [messages addObject:dictionary];
            [self normalMsgToFinalMsg];
            [DataStoreManager storeMyMessage:dictionary];
            //重新刷新tableView
            [self.tView reloadData];
            if (messages.count>0) {
                [self.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            self.ifFriend = YES;
        }
        
        //XMPPFramework主要是通过KissXML来生成XML文件
        //生成<body>文档
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:message];
        
        //生成XML消息文档
        NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
        //   [mes addAttributeWithName:@"nickname" stringValue:@"aaaa"];
        //消息类型
        [mes addAttributeWithName:@"type" stringValue:@"chat"];

        //发送给谁
        [mes addAttributeWithName:@"to" stringValue:[self.chatWithUser stringByAppendingString:[[TempData sharedInstance] getDomain]]];
        //   NSLog(@"chatWithUser:%@",chatWithUser);
        //由谁发送
        [mes addAttributeWithName:@"from" stringValue:[[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] stringByAppendingString:[[TempData sharedInstance] getDomain]]];
        
        [mes addAttributeWithName:@"msgtype" stringValue:@"normalchat"];
        [mes addAttributeWithName:@"fileType" stringValue:@"text"];  //如果发送图片音频改这里
        [mes addAttributeWithName:@"msgTime" stringValue:[Common getCurrentTime]];

        //    NSLog(@"from:%@",[[NSUserDefaults standardUserDefaults] stringForKey:USERID]);
        //组合
        
        //        NSXMLElement * kind = [NSXMLElement elementWithName:@"kind"];
        //        [kind setStringValue:@"chat"];
        [mes addChild:body];
        //        [mes addChild:kind];
        
        //发送消息
        
       // [self.appDel.xmppHelper.xmppStream sendElement:mes];
        if (![self.appDel.xmppHelper sendMessage:mes]) {
            [KGStatusBar showSuccessWithStatus:@"网络有点问题，稍后再试吧" Controller:self];
            //Do something when send failed...
            return;
        }
        
        
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        
        [dictionary setObject:message forKey:@"msg"];
        [dictionary setObject:@"you" forKey:@"sender"];
        //加入发送时间
        [dictionary setObject:[Common getCurrentTime] forKey:@"time"];
        [dictionary setObject:self.chatWithUser forKey:@"receiver"];
        [messages addObject:dictionary];
        [self normalMsgToFinalMsg];
        [DataStoreManager storeMyMessage:dictionary];
        //重新刷新tableView
        [self.tView reloadData];
        if (messages.count>0) {
            [self.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        self.textView.text = @"";
    }
}

#pragma mark KKMessageDelegate
-(void)newMessageReceived:(NSDictionary *)messageCotent{
    
    
    
    
    NSRange range = [[messageCotent objectForKey:@"sender"] rangeOfString:@"@"];
    NSString * sender = [[messageCotent objectForKey:@"sender"] substringToIndex:range.location];
    
    
    NSString * type = [messageCotent objectForKey:@"msgType"];
    type = type?type:@"notype";
    if ([type isEqualToString:@"reply"]||[type isEqualToString:@"zanDynamic"]) {
        AudioServicesPlayAlertSound(1003);
        [DataStoreManager storeNewMsgs:messageCotent senderType:SYSTEMNOTIFICATION];
    }
    else if ([type isEqualToString:@"notice"]||[type isEqualToString:@"ency"]||[type isEqualToString:@"exper"]||[type isEqualToString:@"bbs_note"]){
        AudioServicesPlayAlertSound(1003);
        [DataStoreManager storeNewMsgs:messageCotent senderType:SYSTEMNOTIFICATION];
    }
    else if([type isEqualToString:@"normalchat"])
    {
        [DataStoreManager storeNewMsgs:messageCotent senderType:COMMONUSER];
        if ([sender isEqualToString:self.chatWithUser]) {
            [messages addObject:messageCotent];
            [self normalMsgToFinalMsg];
            [self.tView reloadData];
            if (messages.count>0) {
                [self.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            AudioServicesPlayAlertSound(1003);
        }
        else
        {
            AudioServicesPlayAlertSound(1007);
        }
    }
    
}
-(void)makeMsgVStoreMsg:(NSDictionary *)messageContent
{
    
}

- (void)closeButton:(id)sender {
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
   // [self.mlNavigationController mlPopViewController];
}

-(NSString *)CurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime
{
    NSString * finalTime;
    int theCurrentT = [currentTime intValue];
    int theMessageT = [messageTime intValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString *currentStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    NSString * msgT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString * nowT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    int msgHour = [[msgT substringToIndex:2] intValue];
    int hours = [[nowT substringToIndex:2] intValue];
    int minutes = [[nowT substringFromIndex:3] intValue];
    // NSLog(@"hours:%d,minutes:%d",hours,minutes);
    int currentDayBegin = theCurrentT-hours*3600-minutes*60;
    int yesterdayBegin = currentDayBegin-3600*24;
    int qiantianBegin = yesterdayBegin-3600*24;
    //今天
    if ([currentStr isEqualToString:messageDateStr]) {
        
        
        if (msgHour>0&&msgHour<11) {
            finalTime = [NSString stringWithFormat:@"早上 %@",msgT];
        }
        else if (msgHour>=11&&msgHour<13){
            finalTime = [NSString stringWithFormat:@"中午 %@",msgT];
        }
        else if(msgHour>=13&&msgHour<18) {
            finalTime = [NSString stringWithFormat:@"下午 %@",msgT];
        }
        else{
            finalTime = [NSString stringWithFormat:@"晚上 %@",msgT];
        }
    }
    //昨天
    else if(theMessageT>=yesterdayBegin&&theMessageT<currentDayBegin){
        if (msgHour>0&&msgHour<11) {
            finalTime = [NSString stringWithFormat:@"昨天早上 %@",msgT];
        }
        else if (msgHour>=11&&msgHour<13){
            finalTime = [NSString stringWithFormat:@"昨天中午 %@",msgT];
        }
        else if(msgHour>=13&&msgHour<18) {
            finalTime = [NSString stringWithFormat:@"昨天下午 %@",msgT];
        }
        else{
            finalTime = [NSString stringWithFormat:@"昨天晚上 %@",msgT];
        }
    }
    //前天
    else if (theMessageT>=qiantianBegin&&theMessageT<yesterdayBegin)
    {
        NSDate * msgDate = [NSDate dateWithTimeIntervalSince1970:theMessageT];
        NSString * weekday = [Common getWeakDay:msgDate];
        if (msgHour>0&&msgHour<11) {
            finalTime = [NSString stringWithFormat:@"%@早晨 %@",weekday,msgT];
        }
        else if (msgHour>=11&&msgHour<13){
            finalTime = [NSString stringWithFormat:@"%@中午 %@",weekday,msgT];
        }
        else if(msgHour>=13&&msgHour<18) {
            finalTime = [NSString stringWithFormat:@"%@下午 %@",weekday,msgT];
        }
        else{
            finalTime = [NSString stringWithFormat:@"%@晚上 %@",weekday,msgT];
        }
    }
    //今年
    else if([[messageDateStr substringToIndex:4] isEqualToString:[currentStr substringToIndex:4]]){
        finalTime = [NSString stringWithFormat:@"%@月%@日 %@",[[messageDateStr substringFromIndex:5] substringToIndex:2],[messageDateStr substringFromIndex:8],msgT];
    }
    
    else
    {
        finalTime = [NSString stringWithFormat:@"%@ %@",messageDateStr,msgT];
    }
  //  NSLog(@"finalTime:%@",finalTime);
    return finalTime;
}





- (BOOL)beginRecord
{
    NSLog(@"begin record");
    [self.session setCategory :AVAudioSessionCategoryPlayAndRecord error:nil];
    [self.session setActive: YES error: nil];
    UInt32 doChangeDefault = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefault), &doChangeDefault);
	NSError *error;
    [recordSetting setObject:
     [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
	// Recording settings
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                              //[NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                              [NSNumber numberWithFloat:8000.00], AVSampleRateKey,
                              [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                              //  [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
                              [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                              [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                              [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                              [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                              nil];
	
	// File URL
    NSString *path = [RootDocPath stringByAppendingPathComponent:@"localRecord"];
    rootRecordPath = path;
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:path] == NO)
    {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString * audioUUID = gen_uuid();
    NSString  *localRecordPath = [NSString stringWithFormat:@"%@/%@.caf",path,audioUUID];

	NSURL *url = [NSURL fileURLWithPath:localRecordPath];
	
	// Create recorder
	self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    [self.audioRecorder recordForDuration:(NSTimeInterval)60];
    [self.audioRecorder prepareToRecord];
	if (!self.audioRecorder)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return NO;
	}
	// Initialize degate, metering, etc.
	self.audioRecorder.delegate = self;
	self.audioRecorder.meteringEnabled = YES;
	
	if (![self.audioRecorder prepareToRecord])
	{
		NSLog(@"Error: Prepare to record failed");
        
		return NO;
	}
	
	if (![self.audioRecorder record])
	{
		NSLog(@"Error: Record failed");
        
		return NO;
	}
	return YES;
}
- (void) stopRecording
{
    NSLog(@"stop record");
	// This causes the didFinishRecording delegate method to fire
	[self.audioRecorder stop];
}
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{

    if (!canSendAudio) {
        return;
    }
    NSLog(@"stop record delegate do");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        #ifdef NotUseSimulator
////        NSString *filePath1 = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/recording.caf"];
//        NSString  *localRecordPath = [NSString stringWithFormat:@"%@/audioRecord.caf",rootRecordPath];
//        
////        NSURL *url = [NSURL fileURLWithPath:localRecordPath];
////        NSString *filePath2 = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/recording.amr"];
////        NSString  *localRecordPath2 = [NSString stringWithFormat:@"%@/audioRecord.amr",rootRecordPath];
//        
//        NSURL *url = [NSURL fileURLWithPath:localRecordPath];
////        NSURL *url2 = [NSURL fileURLWithPath:localRecordPath2];
        
        NSData * data = [NSData dataWithContentsOfURL:recorder.url];
        NSLog(@"LENGTH:%d",[data length]);
        NSData * data1 =EncodeWAVEToAMR(data,1,16);
        NSLog(@"LENGTH2:%d",[data1 length]);
//        [data1 writeToURL:url2 atomically:YES];
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:recorder.url options:nil];
        CMTime time = asset.duration;
        double durationInSeconds = CMTimeGetSeconds(time);
        int duration = (int)durationInSeconds;
        NSString * audioUUID = [[NSString stringWithFormat:@"%@",recorder.url] substringFromIndex:(rootRecordPath.length+1+7)];
        audioUUID = [audioUUID substringToIndex:(audioUUID.length-4)];
        [sendingFileArray addObject:[NSString stringWithFormat:@"%@_%d",audioUUID,duration]];
        NSString * sendingID = [NSString stringWithFormat:@"%@_%d",audioUUID,duration];
        [self tempSendFileMsgWithFileID:sendingID MsgID:audioUUID FileType:@"audio" Status:@"sending"];
        
        
        [NetManager uploadAudioFileData:data1 WithURLStr:BaseUploadImageUrl MsgID:audioUUID AudioID:audioUUID  AudioName:@"recording.amr"  TheController:self Success:^(AFHTTPRequestOperation *operation, id responseObject, NSString * theAudioID,NSString *msgID) {
//            NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSDictionary * dict = [receiveStr JSONValue];
//            if ([dict objectForKey:@"success"]) {
            NSString * sendedID = [NSString stringWithFormat:@"%@_%d",theAudioID,duration];
//            NSURL * myRecordPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.caf",rootRecordPath,theAudioID]];
//            [data writeToURL:myRecordPath atomically:YES];
            [data writeToFile:[NSString stringWithFormat:@"%@/%@.caf",rootRecordPath,theAudioID] atomically:YES];
            [self finalSendMsgWithFileID:sendedID MsgID:msgID FileType:@"audio"];
//            }
//            else
//            {
//                NSLog(@"audioUploadError:%@",[dict objectForKey:@"entity"]);
//            }
            NSLog(@"audioUploaded:%@",theAudioID);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, NSString * theAudioID,NSString * msgID) {
            NSString * notsendedID = [NSString stringWithFormat:@"%@_%d",theAudioID,duration];
            [self finalMsgFailedSendWithFileID:notsendedID MsgID:msgID FileType:@"audio"];
            NSLog(@"audioUploadError:%@",error);
//            self tempSendFileMsgWithID:<#(NSString *)#> FileType:<#(NSString *)#> Status:<#(NSString *)#>
        }];
        #endif
        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *succeful=[[UIAlertView alloc]initWithTitle:nil message:@"录音压缩完成,可以上传!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [succeful show];
            
        });
    });


}
-(void)tempSendFileMsgWithFileID:(NSString *)fileID MsgID:(NSString *)msgID FileType:(NSString *)fileType Status:(NSString *)theStatus
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:msgID forKey:@"msgID"];
    [dictionary setObject:fileID forKey:@"msg"];
    [dictionary setObject:@"you" forKey:@"sender"];
    [dictionary setObject:fileType forKey:@"fileType"];
    [dictionary setObject:theStatus forKey:@"status"];
    //加入发送时间
    [dictionary setObject:[Common getCurrentTime] forKey:@"time"];
    [dictionary setObject:self.chatWithUser forKey:@"receiver"];
    [messages addObject:dictionary];
    [self normalMsgToFinalMsg];
    [DataStoreManager storeMyMessage:dictionary];
    //重新刷新tableView
    [self.tView reloadData];
    if (messages.count>0) {
        [self.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    self.textView.text = @"";
}
-(void)finalSendMsgWithFileID:(NSString *)fileID MsgID:(NSString *)msgID FileType:(NSString *)fileType
{
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:fileID];
    
    //生成XML消息文档
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    //   [mes addAttributeWithName:@"nickname" stringValue:@"aaaa"];
    //消息类型
    [mes addAttributeWithName:@"type" stringValue:@"chat"];
    
    //发送给谁
    [mes addAttributeWithName:@"to" stringValue:[self.chatWithUser stringByAppendingString:[[TempData sharedInstance] getDomain]]];
    //   NSLog(@"chatWithUser:%@",chatWithUser);
    //由谁发送
    [mes addAttributeWithName:@"from" stringValue:[[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] stringByAppendingString:[[TempData sharedInstance] getDomain]]];
    
    [mes addAttributeWithName:@"msgtype" stringValue:@"normalchat"];
    [mes addAttributeWithName:@"fileType" stringValue:fileType];  //如果发送图片音频改这里
    [mes addAttributeWithName:@"msgTime" stringValue:[Common getCurrentTime]];
    
    //    NSLog(@"from:%@",[[NSUserDefaults standardUserDefaults] stringForKey:USERID]);
    //组合
    
    //        NSXMLElement * kind = [NSXMLElement elementWithName:@"kind"];
    //        [kind setStringValue:@"chat"];
    [mes addChild:body];
    //        [mes addChild:kind];
    
    //发送消息
    
    // [self.appDel.xmppHelper.xmppStream sendElement:mes];
    if (![self.appDel.xmppHelper sendMessage:mes]) {
        [KGStatusBar showSuccessWithStatus:@"网络有点问题，稍后再试吧" Controller:self];
        //Do something when send failed...
        return;
    }
    
    
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject:msgID forKey:@"msgID"];
    [dictionary setObject:fileID forKey:@"msg"];
    [dictionary setObject:@"you" forKey:@"sender"];
    [dictionary setObject:fileType forKey:@"fileType"];
    [dictionary setObject:@"sended" forKey:@"status"];

    //加入发送时间
    [dictionary setObject:[Common getCurrentTime] forKey:@"time"];
    [dictionary setObject:self.chatWithUser forKey:@"receiver"];
    int uu = 0;
    for (int i = 0;i<messages.count;i++) {
        if ([[messages[i] objectForKey:@"msgID"] isEqualToString:msgID]) {
            uu = i;
            break;
        }
    }
    [messages replaceObjectAtIndex:uu withObject:dictionary];
    [self normalMsgToFinalMsg];
    [DataStoreManager storeMyMessage:dictionary];
    //重新刷新tableView
    [self.tView reloadData];


}
-(void)finalMsgFailedSendWithFileID:(NSString *)fileID MsgID:(NSString *)msgID FileType:(NSString *)fileType
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject:msgID forKey:@"msgID"];
    [dictionary setObject:@"" forKey:@"msg"];
    [dictionary setObject:@"you" forKey:@"sender"];
    [dictionary setObject:fileType forKey:@"fileType"];
    [dictionary setObject:@"failed" forKey:@"status"];
    
    //加入发送时间
    [dictionary setObject:[Common getCurrentTime] forKey:@"time"];
    [dictionary setObject:self.chatWithUser forKey:@"receiver"];
    int uu = 0;
    for (int i = 0;i<messages.count;i++) {
        if ([[messages[i] objectForKey:@"msgID"] isEqualToString:msgID]) {
            uu = i;
            break;
        }
    }
    [messages replaceObjectAtIndex:uu withObject:dictionary];
    [self normalMsgToFinalMsg];
    [DataStoreManager storeMyMessage:dictionary];
    //重新刷新tableView
    [self.tView reloadData];

}
-(void)getAudioFromNet:(NSString *)audioID
{
    #ifdef NotUseSimulator
    [NetManager downloadAudioFileWithURL:BaseImageUrl FileName:audioID TheController:self Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString  *localRecordPath = [NSString stringWithFormat:@"%@/%@.caf",rootRecordPath,audioID];
        NSData *  wavData = DecodeAMRToWAVE(responseObject);
        if ([wavData writeToFile:localRecordPath atomically:YES]) {
            [self playAudioWithAudioID:audioID];
        }
        else
        {
            NSLog(@"write failed");
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    #endif
}
-(void)playAudioWithAudioID:(NSString *)audioID
{
    NSError *err = nil;
    [self.session setCategory :AVAudioSessionCategoryPlayback error:&err];
    NSString  *localRecordPath = [NSString stringWithFormat:@"%@/%@.caf",rootRecordPath,audioID];
    audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:localRecordPath] error:nil];
    if (audioPlayer) {
        audioPlayer.delegate = self;
        audioPlayer.volume=1.0;
        [audioPlayer prepareToPlay];
        [audioPlayer play];
    }
    NSDictionary *dictionary = [messages objectAtIndex:readyIndex];
    NSMutableDictionary * dDict = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    [dDict setObject:@"YES" forKey:@"readed"];
    [messages replaceObjectAtIndex:readyIndex withObject:dDict];
    [self normalMsgToFinalMsg];
    if ([[dDict objectForKey:@"sender"] isEqualToString:@"you"]) {
        [DataStoreManager storeMyMessage:dDict];
    }
    else
        [DataStoreManager storeNewMsgs:dDict senderType:COMMONUSER];
    
    //重新刷新tableView
    [self.tView reloadData];
    indexPathTo = [NSIndexPath indexPathForRow:(tempBtn.tag-1) inSection:0];
    KKMessageCell * cell = (KKMessageCell *)[self.tView cellForRowAtIndexPath:indexPathTo];
    if ([[dDict objectForKey:@"sender"] isEqualToString:@"you"]) {
        cell.playAudioImageV.animationImages = animationTwo;
    }
    else
    {
        cell.playAudioImageV.animationImages = animationOne;
    }
    [cell.playAudioImageV startAnimating];
//    else
//    {
//        [self getAudioFromNet:audioID];
//    }


}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    indexPathTo = [NSIndexPath indexPathForRow:readyIndex inSection:0];
    KKMessageCell * cell = (KKMessageCell *)[self.tView cellForRowAtIndexPath:indexPathTo];
    cell.playAudioImageV.animationImages = nil;
    [cell.playAudioImageV stopAnimating];
    NSDictionary *dictionary = [messages objectAtIndex:readyIndex];
    if ([[dictionary objectForKey:@"sender"] isEqualToString:@"you"]) {
        [cell.playAudioImageV setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying003@2x"]];
    }
    else
        [cell.playAudioImageV setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying@2x"]];
    NSLog(@"audio play done!");
}

-(void)viewWillAppear:(BOOL)animated
{

}
-(void)viewWillDisappear:(BOOL)animated
{
    [DataStoreManager blankMsgUnreadCountForUser:self.chatWithUser];
}
//-(KKAppDelegate *)appDelegate{
//    
//    return (KKAppDelegate *)[[UIApplication sharedApplication] delegate];
//}
//
//-(XMPPStream *)xmppStream{
//    
//    return [[self appDelegate] xmppStream];
//}

@end
