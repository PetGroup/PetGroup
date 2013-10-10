//
//  ParticularDynamicViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-9-23.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ParticularDynamicViewController.h"
#import "TempData.h"
#import "MBProgressHUD.h"
#import "EasyDynamicCell.h"
#import "ReplyCell.h"
#import "UIExpandingTextView.h"
#import "HeightCalculate.h"
#import "ReplyComment.h"
@interface ParticularDynamicViewController ()<UITableViewDataSource,UITableViewDelegate,UIExpandingTextViewDelegate,UIActionSheetDelegate>
{
    UIButton * assessB;
    UIButton * reprintB;
    
    MBProgressHUD * hud;
    
    int assessOrPraise;
    
    UIImageView * inputbg;
    UIView * inPutView;
    BOOL request;
}
@property (nonatomic,retain)NSString* reportType;
@property (nonatomic,retain)UITableView * tableV;
@property (nonatomic,strong)UIImageView*  actionIV;
@property (nonatomic,strong)UIExpandingTextView* inputTF;
@property (nonatomic,weak)id theID;
@property (nonatomic,strong)UIView* reportView;
@end

@implementation ParticularDynamicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.selfTypr = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"详情"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton *moreButten=[UIButton buttonWithType:UIButtonTypeCustom];
    moreButten.frame=CGRectMake(278, 3, 35, 33);
    [moreButten setBackgroundImage:[UIImage imageNamed:@"gengduoxinxi"] forState:UIControlStateNormal];
    [moreButten addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreButten];
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
    [self.view addSubview:_tableV];
    _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableV.delegate = self;
    _tableV.dataSource = self;
    
    self.highArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.dynamic.replyViews.count; i++) {
        Reply* rel = self.dynamic.replyViews[i];
        [self.highArray addObject:rel];
        for (int j = 0; j < rel.replyComments.count; j++) {
            ReplyComment* recom = (ReplyComment*)rel.replyComments[j];
            [self.highArray addObject:recom];
        }
    }
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"正在加载，请稍后";
    
    inPutView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 50)];
    [inPutView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:inPutView];
    inputbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [inputbg setImage:[UIImage imageNamed:@"inputbg.png"]];
    [inPutView addSubview:inputbg];
    
    self.inputTF = [[UIExpandingTextView alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
    self.inputTF.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
    [self.inputTF.internalTextView setReturnKeyType:UIReturnKeySend];
    self.inputTF.delegate = self;
    self.inputTF.maximumNumberOfLines=5;
    [inPutView addSubview:self.inputTF];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (self.selfTypr == 1) {
        [self assess];
    }
    if (self.selfTypr == 2) {
        [self reprint];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
   _tableV.frame = CGRectMake(_tableV.frame.origin.x, _tableV.frame.origin.y, _tableV.contentSize.width, _tableV.contentSize.height); 
}
-(void)backButton:(UIButton*)button
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeActionImageView];
    [self keyBoardResign];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.dynamic.easyRowHigh;
    }
    if (indexPath.section == 1) {
        if ([self.highArray[indexPath.row] isKindOfClass:[Reply class]]) {
            Reply* rel = (Reply*)self.highArray[indexPath.row];
            NSString* repS = [NSString stringWithFormat:@"%@:%@",rel.petUser.nickName,rel.msg];
            CGSize size = [HeightCalculate calSizeWithString:repS WithMaxWidth:240];
            return size.height+10;
        }else{
            ReplyComment* recom = (ReplyComment*)self.highArray[indexPath.row];
            NSString* repS = [NSString stringWithFormat:@"%@回复%@:%@",recom.commentUserView.nickName,recom.replyUserView.nickName,recom.commentsMsg];
            CGSize size = [HeightCalculate calSizeWithString:repS WithMaxWidth:240];
            return size.height+10;
        } ;
    }
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        int count = 0;
        for (Reply* reply in self.dynamic.replyViews) {
            count++;
            for (id a in reply.replyComments) {
                count++;
            }
        }
        return count;
    }else
        return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        static NSString *cellIdentifier = @"EasyDynamicCell";
        EasyDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil) {
            cell = [[EasyDynamicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        cell.viewC = self;
        cell.dynamic = self.dynamic;
        return cell;
    }else{
        static NSString *cellIdentifier = @"ReplyCell";
        ReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil) {
            cell = [[ReplyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        cell.viewC = self;
        cell.theID = self.highArray[indexPath.row];
        return cell;
    }

    
}
#pragma mark - button action
-(void)more
{
    UIActionSheet* a = [[UIActionSheet alloc]initWithTitle:@"您想要做什么？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles: nil];
    [a showInView:self.view];
}
-(void)assess//评论
{
    [self removeActionImageView];
    [_inputTF becomeFirstResponder];
    assessOrPraise = 1;
    _inputTF.placeholder = [NSString stringWithFormat:@"评论:%@",self.dynamic.petUser.nickName];
}
-(void)reprint//转发
{
    [self removeActionImageView];
    [_inputTF becomeFirstResponder];
    assessOrPraise = 2;
    _inputTF.placeholder = @"转发至我的动态";
}
-(void)didInput
{
    if (_inputTF.text.length>0) {
        switch (assessOrPraise) {
            case 1:
            {
                NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
                NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
                long long a = (long long)(cT*1000);
                [params setObject:[[TempData sharedInstance] getMyUserID] forKey:@"petuserId"];
                [params setObject:self.dynamic.dynamicID forKey:@"userstateId"];
                [params setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"replyTime"];
                [params setObject:self.inputTF.text forKey:@"msg"];
                NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
                [body setObject:@"1" forKey:@"channel"];
                [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
                [body setObject:@"iphone" forKey:@"imei"];
                [body setObject:params forKey:@"params"];
                [body setObject:@"addReply" forKey:@"method"];
                [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
                [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
                [hud show:YES];
                [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [hud hide:YES];
                    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
                    Reply* rep = [[Reply alloc]initWithDictionary:dic];
                    [self.dynamic.replyViews addObject:rep];
                    self.highArray = [[NSMutableArray alloc]init];
                    for (int i = 0; i < self.dynamic.replyViews.count; i++) {
                        Reply* rel = self.dynamic.replyViews[i];
                        [self.highArray addObject:rel];
                        for (int j = 0; j < rel.replyComments.count; j++) {
                            ReplyComment* recom = (ReplyComment*)rel.replyComments[j];
                            [self.highArray addObject:recom];
                        }
                    }
                    [self.tableV reloadData];
                }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [hud hide:YES];
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                    [alert show];
                }];
            }break;
            case 2:
            {
                if (_inputTF.text.length<=80) {
                    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
                    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
                    long long a = (long long)(cT*1000);
                    [params setObject:@"" forKey:@"transmitUrl"];
                    [params setObject:self.inputTF.text forKey:@"transmitMsg"];
                    [params setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"submitTime"];
                    [params setObject:@"1" forKey:@"ifTransmitMsg"];
                    [params setObject:self.dynamic.msg forKey:@"msg"];
                    [params setObject:self.dynamic.imageID forKey:@"imgid"];
                    [params setObject:[[TempData sharedInstance] getMyUserID] forKey:@"userid"];
                    [params setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLon]] forKey:@"longitude"];
                    [params setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLat]] forKey:@"latitude"];
                    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
                    [body setObject:@"1" forKey:@"channel"];
                    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
                    [body setObject:@"iphone" forKey:@"imei"];
                    [body setObject:params forKey:@"params"];
                    [body setObject:@"addUserState" forKey:@"method"];
                    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
                    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
                    [hud show:YES];
                    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [hud hide:YES];
                    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [hud hide:YES];
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                        [alert show];
                    }];
                }else{
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"转发内容不得超过80个字" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
                    [alert show];
                }
                
            }break;
            case 3:
            {
                NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
                NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
                long long a = (long long)(cT*1000);
                [params setObject:[[TempData sharedInstance] getMyUserID] forKey:@"commentUserid"];
                [params setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"commentTime"];
                if ([self.theID isKindOfClass:[Reply class]]) {
                    [params setObject:((Reply*)self.theID).petUser.userId forKey:@"replyUserid"];
                    [params setObject:((Reply*)self.theID).replyID forKey:@"replyId"];
                    [params setObject:((Reply*)self.theID).dynamicID forKey:@"userStateid"];
                }
                if ([self.theID isKindOfClass:[ReplyComment class]]) {
                    [params setObject:((ReplyComment*)self.theID).commentUserView.userId forKey:@"replyUserid"];
                    [params setObject:((ReplyComment*)self.theID).replyID forKey:@"replyId"];
                    [params setObject:((ReplyComment*)self.theID).userStateid forKey:@"userStateid"];
                }
                
                [params setObject:_inputTF.text forKey:@"msg"];
                NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
                [body setObject:@"1" forKey:@"channel"];
                [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
                [body setObject:@"iphone" forKey:@"imei"];
                [body setObject:params forKey:@"params"];
                [body setObject:@"addCommentReply" forKey:@"method"];
                [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
                [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
                [hud show:YES];
                [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [hud hide:YES];
                    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    ReplyComment* repcom = [[ReplyComment alloc]initWithDictionary:dic];
                    if ([self.theID isKindOfClass:[Reply class]]) {
                        [((Reply*)self.theID).replyComments addObject:repcom];
                        self.highArray = [[NSMutableArray alloc]init];
                        for (int i = 0; i < self.dynamic.replyViews.count; i++) {
                            Reply* rel = self.dynamic.replyViews[i];
                            [self.highArray addObject:rel];
                            for (int j = 0; j < rel.replyComments.count; j++) {
                                ReplyComment* recom = (ReplyComment*)rel.replyComments[j];
                                [self.highArray addObject:recom];
                            }
                        }
                        [self.tableV reloadData];
                    }
                    if ([self.theID isKindOfClass:[ReplyComment class]]) {
                        Reply* theRep = nil;
                        for (Reply* re  in self.dynamic.replyViews) {
                            for (ReplyComment* rec in re.replyComments) {
                                if ([rec isEqual:self.theID]) {
                                    theRep = re;
                                    break;
                                }
                            }
                        }
                        if (theRep) {
                            [theRep.replyComments addObject:repcom];
                        }
                        self.highArray = [[NSMutableArray alloc]init];
                        for (int i = 0; i < self.dynamic.replyViews.count; i++) {
                            Reply* rel = self.dynamic.replyViews[i];
                            [self.highArray addObject:rel];
                            for (int j = 0; j < rel.replyComments.count; j++) {
                                ReplyComment* recom = (ReplyComment*)rel.replyComments[j];
                                [self.highArray addObject:recom];
                            }
                        }
                        [self.tableV reloadData];
                    }
                    NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
                }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [hud hide:YES];
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                    [alert show];
                }];
            }break;
                
            default:
                break;
        }
        [self keyBoardResign];
    }
}
-(void)keyBoardResign
{
    [_inputTF resignFirstResponder];
}
#pragma mark - Responding to keyboard events
-(void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height
{
    /* Adjust the height of the toolbar when the input component expands */
    float diff = (expandingTextView.frame.size.height - height);
    CGRect r = inPutView.frame;
    CGRect r2 = inputbg.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    r2.size.height-=diff;
    inPutView.frame = r;
    inputbg.frame = r2;
    
}
- (BOOL)expandingTextViewShouldReturn:(UIExpandingTextView *)expandingTextView
{
    [self didInput];
    expandingTextView.text = @"";
    return YES;
}
#pragma mark - Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
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
-(void) autoMovekeyBoard: (float) h{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    if (iPhone5) {
        if (self.view.frame.size.height == 499.0) {
            inPutView.frame = CGRectMake(0.0f, (float)(self.view.frame.size.height-h-inPutView.frame.size.height+49), 320.0f, inPutView.frame.size.height);
        }else{
            inPutView.frame = CGRectMake(0.0f, (float)(self.view.frame.size.height-h-inPutView.frame.size.height), 320.0f, inPutView.frame.size.height);
        }
    }
    else
    {
        if (self.view.frame.size.height == 411.0) {
            inPutView.frame = CGRectMake(0.0f, (float)(self.view.frame.size.height-h-inPutView.frame.size.height+49), 320.0f, inPutView.frame.size.height);
        }else{
            inPutView.frame = CGRectMake(0.0f, (float)(self.view.frame.size.height-h-inPutView.frame.size.height), 320.0f, inPutView.frame.size.height);
        }
    }
    if (h==0) {
        inPutView.frame = CGRectMake(0.0f, (float)(self.view.frame.size.height), 320.0f, inPutView.frame.size.height);
    }
	
    [UIView commitAnimations];
    NSLog(@"%f",self.view.frame.size.height);
}
#pragma mark - cell button action
-(void)showButton:(EasyDynamicCell*)cell
{
    CGRect cellRect=[self.view convertRect:cell.frame fromView:_tableV];
    if (_actionIV == nil) {
        self.actionIV = [[UIImageView alloc]init];
        _actionIV.userInteractionEnabled = YES;
        _actionIV.image = [UIImage imageNamed:@"tanchuanniu_bg"];
        [self.view addSubview:_actionIV];
        
        assessB = [UIButton buttonWithType:UIButtonTypeCustom];
        assessB.frame = CGRectMake(0, 6, 0,31);
        [assessB setBackgroundImage:[UIImage imageNamed:@"tanchuanniu-normal"] forState:UIControlStateNormal];
        [assessB setBackgroundImage:[UIImage imageNamed:@"tanchuanniu-click"] forState:UIControlStateHighlighted];
        [assessB setTitle:@"评论" forState:UIControlStateNormal];
        [assessB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [assessB addTarget:self action:@selector(assess) forControlEvents:UIControlEventTouchUpInside];
        [_actionIV addSubview:assessB];
        
        reprintB = [UIButton buttonWithType:UIButtonTypeCustom];
        reprintB.frame = CGRectMake(0, 6, 0, 31);
        [reprintB setBackgroundImage:[UIImage imageNamed:@"tanchuanniu-normal"] forState:UIControlStateNormal];
        [reprintB setBackgroundImage:[UIImage imageNamed:@"tanchuanniu-click"] forState:UIControlStateHighlighted];
        [reprintB setTitle:@"转载" forState:UIControlStateNormal];
        [reprintB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [reprintB addTarget:self action:@selector(reprint) forControlEvents:UIControlEventTouchUpInside];
        [_actionIV addSubview:reprintB];
    }
    [self removeActionImageView];
    _actionIV.frame = CGRectMake(280, cellRect.origin.y+cell.moveB.frame.origin.y-5, 0, 44);
    [self.view addSubview:_actionIV];
    [UIView animateWithDuration:0.3 animations:^{
        _actionIV.frame = CGRectMake( 158, cellRect.origin.y+cell.moveB.frame.origin.y-5, 127, 44);
        assessB.frame = CGRectMake(6, 6, 53, 31);
        reprintB.frame = CGRectMake(65, 6, 53, 31);
    }];
}
-(void)removeActionImageView
{
    assessB.frame = CGRectMake(0, 6, 0,31);
    reprintB.frame = CGRectMake(0, 6, 0, 31);
    [_actionIV removeFromSuperview];
    
}
-(void)deleteDynamic:(Dynamic*)dyn
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:@"" forKey:@"transmitUrl"];
    [params setObject:dyn.transmitMsg forKey:@"transmitMsg"];
    [params setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"submitTime"];
    [params setObject:[NSString stringWithFormat:@"%d", dyn.ifTransmitMsg] forKey:@"ifTransmitMsg"];
    [params setObject:dyn.msg forKey:@"msg"];
    [params setObject:dyn.imageID forKey:@"imgid"];
    [params setObject:dyn.petUser.userId forKey:@"userid"];
    [params setObject:dyn.dynamicID forKey:@"userStateId"];
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"delUserState" forKey:@"method"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[TempData sharedInstance] Panned:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
-(void)recalledreply:(id)theID cell:(EasyDynamicCell*)cell//回复评论
{
    if ([theID isKindOfClass:[Reply class]]) {
        _inputTF.placeholder = [NSString stringWithFormat:@"回复:%@",((Reply*)theID).petUser.nickName];
    }
    if ([theID isKindOfClass:[ReplyComment class]]) {
        _inputTF.placeholder = [NSString stringWithFormat:@"回复:%@",((ReplyComment*)theID).commentUserView.nickName];
    }
    self.theID = theID;
    [_inputTF becomeFirstResponder];
    assessOrPraise = 3;
    
}
#pragma mark - actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        if (!self.reportView) {
            self.reportView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, self.view.frame.size.height)];
            _reportView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:.01 alpha:0.3];

            [self.view addSubview: _reportView];
            UIView* smallReportView = [[UIView alloc]initWithFrame:CGRectMake(50, 150, 220, 260)];
            smallReportView.backgroundColor = [UIColor whiteColor];
            [_reportView addSubview:smallReportView];
            smallReportView.layer.cornerRadius = 8;
            smallReportView.layer.masksToBounds = YES;
            UIButton *shamB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [shamB setTitle:@"垃圾信息" forState:UIControlStateNormal];
            shamB.frame = CGRectMake(10, 10, 200, 40);
            shamB.tag = 1;
            [shamB addTarget:self action:@selector(report:) forControlEvents:UIControlEventTouchUpInside];
            [smallReportView addSubview:shamB];
            
            UIButton *eroticismB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [eroticismB setTitle:@"色情" forState:UIControlStateNormal];
            eroticismB.frame = CGRectMake(10, 60, 200, 40);
            eroticismB.tag = 2;
            [eroticismB addTarget:self action:@selector(report:) forControlEvents:UIControlEventTouchUpInside];
            [smallReportView addSubview:eroticismB];
            
            UIButton *advertisementB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [advertisementB setTitle:@"广告" forState:UIControlStateNormal];
            advertisementB.frame = CGRectMake(10, 110, 200, 40);
            advertisementB.tag = 3;
            [advertisementB addTarget:self action:@selector(report:) forControlEvents:UIControlEventTouchUpInside];
            [smallReportView addSubview:advertisementB];
            
            UIButton *abuseB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [abuseB setTitle:@"辱骂" forState:UIControlStateNormal];
            abuseB.frame = CGRectMake(10, 160, 200, 40);
            abuseB.tag = 4;
            [abuseB addTarget:self action:@selector(report:) forControlEvents:UIControlEventTouchUpInside];
            [smallReportView addSubview:abuseB];
            
            UIButton *cancelB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [cancelB setTitle:@"取消" forState:UIControlStateNormal];
            [cancelB setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            cancelB.frame = CGRectMake(10, 210, 200, 40);
            [cancelB addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
            [smallReportView addSubview:cancelB];
        }
        [UIView animateWithDuration:0.3 animations:^{
            _reportView.frame = self.view.frame;
        }];

    }
}
#pragma mark - report button act
-(void)cancel
{
    [UIView animateWithDuration:0.3 animations:^{
        _reportView.frame = CGRectMake(0, self.view.frame.size.height, 320, self.view.frame.size.height);
    }];
}
-(void)report:(UIButton *)sender
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:self.dynamic.dynamicID forKey:@"stateid"];
    [params setObject:[NSString stringWithFormat:@"%d",sender.tag] forKey:@"reporttype"];
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"reportContent" forKey:@"method"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [KGStatusBar showSuccessWithStatus:@"举报成功，请等待管理员审核"];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [KGStatusBar showSuccessWithStatus:@"举报失败，可能是网络不好"];
    }];
    [self cancel];
}
#pragma mark - touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeActionImageView];
    [self keyBoardResign];
}
@end
