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


- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
   
    postDict = [NSMutableDictionary dictionary];
    canAdd = YES;
    previousTime = 0;
    touchTimeFinal = 0;
    touchTimePre = 0;
    uDefault = [NSUserDefaults standardUserDefaults];
    currentID = [uDefault objectForKey:@"account"];

    
    NSLog(@"wwwwwww:%@",currentID);
//    if (currentID) {
//        userDefaults = [[NSUserDefaults standardUserDefaults] objectForKey:currentID];
//    }
//    else
//    {
//        userDefaults = [NSMutableDictionary dictionary];
//    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImageView * bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [bgV setImage:[UIImage imageNamed:@"chat_bg.png"]];
    [self.view addSubview:bgV];
    messages = [DataStoreManager qureyAllCommonMessages:self.chatWithUser];
    
    self.tView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44-50) style:UITableViewStylePlain];
   // NSLog(@"wwwwww%f",self.view.frame.size.height);
    [self.view addSubview:self.tView];
    [self.tView setBackgroundColor:[UIColor clearColor]];
    self.tView.delegate = self;
    self.tView.dataSource = self;
    self.tView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
 //   [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(closeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *profileButton=[UIButton buttonWithType:UIButtonTypeCustom];
    profileButton.frame=CGRectMake(282, 7, 28, 28);
    [profileButton setBackgroundImage:[UIImage imageNamed:@"chat-profile.png"] forState:UIControlStateNormal];
    //   [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [profileButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.view addSubview:profileButton];
    [profileButton addTarget:self action:@selector(toContactProfile) forControlEvents:UIControlEventTouchUpInside];
    
    titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 2, 120, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=self.nickName;
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];


    
    
    inPutView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, 320, 50)];
    [inPutView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:inPutView];
    inputbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [inputbg setImage:[UIImage imageNamed:@"inputbg.png"]];
    [inPutView addSubview:inputbg];
//    UIImageView * inputbg2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6.5, 262, 37)];
//    [inputbg2 setImage:[UIImage imageNamed:@"chat_input.png"]];
//    [inPutView addSubview:inputbg2];
    
//    self.messageTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 262, 30)];
//    [self.messageTextField setBackgroundColor:[UIColor clearColor]];
//    self.messageTextField.delegate = self;
//    self.messageTextField.returnKeyType = UIReturnKeySend;
//    [inPutView addSubview:self.messageTextField];
    
    self.textView = [[UIExpandingTextView alloc] initWithFrame:CGRectMake(10, 10, 262, 30)];
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
    [self.textView.internalTextView setReturnKeyType:UIReturnKeySend];
    self.textView.delegate = self;
    self.textView.maximumNumberOfLines=5;
    [inPutView addSubview:self.textView];
    
    senBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [senBtn setFrame:CGRectMake(282, inPutView.frame.size.height-37.5, 28, 27.5)];
    [senBtn setImage:[UIImage imageNamed:@"chat_send.png"] forState:UIControlStateNormal];
    [inPutView addSubview:senBtn];
    [senBtn addTarget:self action:@selector(sendButton:) forControlEvents:UIControlEventTouchUpInside];

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
//    KKAppDelegate *del = [self appDelegate];
//    del.messageDelegate = self;
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)toContactProfile
{

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
	inPutView.frame = CGRectMake(0.0f, (float)(self.view.frame.size.height-h-inPutView.frame.size.height), 320.0f, inPutView.frame.size.height);

    
//	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
//	tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f,(float)(480.0-h-108.0));
    [UIView commitAnimations];
    self.tView.frame = CGRectMake(0.0f, 44, 320.0f, self.view.frame.size.height-44-inPutView.frame.size.height-h);
    if (messages.count>0) {
        [self.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    if (h>0&&canAdd) {
        canAdd = NO;
        clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44-inPutView.frame.size.height-h)];
        [clearView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:clearView];
    }
    if ([clearView superview]) {
        [clearView setFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44-inPutView.frame.size.height-h)];
    }


}
#pragma mark -
#pragma mark UIExpandingTextView delegate
//改变键盘高度
-(void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height
{
    /* Adjust the height of the toolbar when the input component expands */
    float diff = (self.textView.frame.size.height - height);
    CGRect r = inPutView.frame;
    CGRect r2 = inputbg.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    r2.size.height-=diff;
    inPutView.frame = r;
    inputbg.frame = r2;
    if ([clearView superview]) {
        [clearView setFrame:CGRectMake(0, 44, 320, clearView.frame.size.height+diff)];
    }
    self.tView.frame = CGRectMake(0.0f, 44, 320.0f, self.tView.frame.size.height+diff);
    if (messages.count>0) {
        [self.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    [senBtn setFrame:CGRectMake(282, inPutView.frame.size.height-37.5, 28, 27.5)];
    
}
//return方法
- (BOOL)expandingTextViewShouldReturn:(UIExpandingTextView *)expandingTextView{
    [self sendButton:nil];
    return YES;
}
//文本是否改变
-(void)expandingTextViewDidChange:(UIExpandingTextView *)expandingTextView
{
 
}

#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
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
  //  NSLog(@"dict:%@",dict);
    
    //发送者
    NSString *sender = [dict objectForKey:@"sender"];
    //消息
    NSString *message = [dict objectForKey:@"msg"];
 //   NSLog(@"nnnnnn:%@",message);
    //时间
    NSString *time = [dict objectForKey:@"time"];
    
 //   NSLog(@"kkkkkkkkkkk:%@,llllllll:%@",dict,time);
    
    CGSize textSize = {260.0-10-30 ,10000.0};
    CGSize size = [message sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:textSize lineBreakMode:UILineBreakModeCharacterWrap];
    
    //size.width +=(padding/2);
    
    cell.messageContentView.text = message;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   // cell.userInteractionEnabled = NO;
    
    UIImage *bgImage = nil;
    NSString * imgid = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"pUserView"] objectForKey:@"petUserView"] objectForKey:@"img"];
    //发送消息
    if ([sender isEqualToString:@"you"]) {
        [cell.headImgV setImage:[UIImage imageNamed:@"moren_people.png"]];
        [cell.headImgV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://123.178.27.74/pet/static/%@",imgid]] placeholderImage:[UIImage imageNamed:imgid]];
        [cell.headImgV setFrame:CGRectMake(320-10-40, padding*2-15, 40, 40)];
        bgImage = [[UIImage imageNamed:@"bubble_02.png"]
                   stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        [cell.headBtn setFrame:cell.headImgV.frame];
        
        [cell.headBtn addTarget:self action:@selector(myBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.messageContentView setFrame:CGRectMake(320-size.width - padding-15-10-25, padding*2-10, size.width, size.height)];
        [cell.bgImageView setFrame:CGRectMake(320-size.width - padding-20-10-25, padding*2-15, size.width+20, size.height+10)];
        [cell.bgImageView setBackgroundImage:bgImage forState:UIControlStateNormal];
        [cell.bgImageView addTarget:self action:@selector(offsetButtonTouchBegin:) forControlEvents:UIControlEventTouchDown];
        [cell.bgImageView setTag:(indexPath.row+1)];
    }else {

        [cell.headImgV setFrame:CGRectMake(10, padding*2-15, 40, 40)];
        [cell.chattoHeadBtn setFrame:cell.headImgV.frame];
        [cell.chattoHeadBtn addTarget:self action:@selector(chatToBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//        NSRange range = [sender rangeOfString:@"@"];
//        sender = [sender substringToIndex:range.location];
        [cell.headImgV setImage:[UIImage imageNamed:@"moren_people.png"]];
            
        if ([userName isEqualToString:@"爱宠小助手"])
            [cell.headImgV setImage:[UIImage imageNamed:@"sss.png"]];
        bgImage = [[UIImage imageNamed:@"bubble_01.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        [cell.messageContentView setFrame:CGRectMake(padding+5+45, padding*2-5, size.width, size.height)];
        [cell.bgImageView setFrame:CGRectMake(padding-10+45, padding*2-10, size.width+20, size.height+10)];
        [cell.bgImageView setBackgroundImage:bgImage forState:UIControlStateNormal];
        [cell.bgImageView addTarget:self action:@selector(offsetButtonTouchBegin:) forControlEvents:UIControlEventTouchDown];
        [cell.bgImageView setTag:(indexPath.row+1)];
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
-(void)chatToBtnClicked
{
    [self toContactProfile];
}
-(void)myBtnClicked
{
//    MyProfileViewController * myP = [[MyProfileViewController alloc] init];
//    [self.navigationController pushViewController:myP animated:YES];
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
    if ([[NSDate date] timeIntervalSince1970]-touchTimePre>1) {
        
    }
    NSLog(@"end");
}
-(void)endIt:(UIButton *)sender
{
    if (tempBtn.highlighted == YES) {
        NSLog(@"haha");
        indexPathTo = [NSIndexPath indexPathForRow:(tempBtn.tag-1) inSection:0];
        KKMessageCell * cell = (KKMessageCell *)[self.tView cellForRowAtIndexPath:indexPathTo];
        tempStr = cell.messageContentView.text;
        CGRect rect = [self.view convertRect:tempBtn.frame fromView:cell.contentView];
        NSLog(@"ssasasasasa%@",NSStringFromCGRect(rect));
        readyIndex = tempBtn.tag-1;

        [self displayPopLittleViewWithRectX:(rect.origin.x+(rect.size.width-182)/2) RectY:rect.origin.y-54 TheRect:rect];
    }

    //[yy setBackgroundImage:nil forState:UIControlStateNormal];
}
-(void)displayPopLittleViewWithRectX:(float)originX RectY:(float)originY TheRect:(CGRect)rect
{
    if ([popLittleView superview]) {
        
        [popLittleView removeFromSuperview];
        
    }
    if (![clearView superview]) {
        clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44-50)];
        [clearView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:clearView];
    }


    popLittleView = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, 182, 54.5)];
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
        [popLittleView setFrame:CGRectMake(originX, originY, 182, 54.5)];
    }
    else if (originX<0)
    {
        [popLittleView setFrame:CGRectMake(0, originY, 182, 54.5)];
    }
    if (originY<44) {
        originY = originY+54.5+rect.size.height;
        [popLittleView setFrame:CGRectMake(originX, originY, 182, 54.5)];
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
}
-(void)deleteMsg
{
    [popLittleView removeFromSuperview];
    if ([clearView superview]) {
        [clearView removeFromSuperview];
    }
     [messages removeObjectAtIndex:readyIndex];
    [self.tView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPathTo] withRowAnimation:UITableViewRowAnimationRight];
   
    [self.tView reloadData];
    NSDictionary * userDefaults2 = [uDefault objectForKey:currentID];
    NSMutableDictionary * userDefaults = [NSMutableDictionary dictionaryWithDictionary:userDefaults2];
    [peopleDict setObject:messages forKey:userName];
    [userDefaults setObject:peopleDict forKey:LocalMessage];
    [uDefault setObject:userDefaults forKey:currentID];
    [uDefault synchronize];
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
    NSString *msg = [dict objectForKey:@"msg"];
    
    CGSize textSize = {260.0-10-30 , 10000.0};
    CGSize size = [msg sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
    
    size.height += padding*2;
    
    CGFloat height = size.height < 65 ? 65 : size.height;
    
    return height;
    
}

- (void)sendButton:(id)sender {
    
    //本地输入框中的信息
    NSString *message = self.textView.text;
    
    if (message.length > 0) {
        
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
        [mes addAttributeWithName:@"to" stringValue:[self.chatWithUser stringByAppendingString:Domain]];
     //   NSLog(@"chatWithUser:%@",chatWithUser);
        //由谁发送
        [mes addAttributeWithName:@"from" stringValue:[[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] stringByAppendingString:Domain]];
    //    NSLog(@"from:%@",[[NSUserDefaults standardUserDefaults] stringForKey:USERID]);
        //组合
        [mes addChild:body];
        
        //发送消息
        
        [self.appDel.xmppHelper.xmppStream sendElement:mes];
        

        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        
        [dictionary setObject:message forKey:@"msg"];
        [dictionary setObject:@"you" forKey:@"sender"];
        //加入发送时间
        [dictionary setObject:[Common getCurrentTime] forKey:@"time"];
        [dictionary setObject:self.chatWithUser forKey:@"receiver"];
        [messages addObject:dictionary];
        [DataStoreManager storeMyMessage:dictionary];
        //重新刷新tableView
        [self.tView reloadData];
        if (messages.count>0) {
            [self.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        self.textView.text = @"";
    }
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.messageTextField resignFirstResponder];
//    if ([popLittleView superview]) {
//        [popLittleView removeFromSuperview];
//    }
}
#pragma mark KKMessageDelegate
-(void)newMessageReceived:(NSDictionary *)messageCotent{
    
    AudioServicesPlayAlertSound(1003);
    
    
    NSRange range = [[messageCotent objectForKey:@"sender"] rangeOfString:@"@"];
    NSString * sender = [[messageCotent objectForKey:@"sender"] substringToIndex:range.location];
    if ([sender isEqualToString:self.chatWithUser]) {
        [DataStoreManager storeNewMsgs:messageCotent senderType:COMMONUSER];
        [messages addObject:messageCotent];
        [self.tView reloadData];
        if (messages.count>0) {
            [self.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    else
        [self.msgDelegate makeMsgVStoreMsg:messageCotent];
    
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
