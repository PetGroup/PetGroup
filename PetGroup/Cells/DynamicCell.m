//
//  DynamicCell.m
//  PetGroup
//
//  Created by 阿铛 on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DynamicCell.h"
#import "Common.h"
#import "EGOImageButton.h"
#import "EGOImageView.h"
#import "PersonDetailViewController.h"
#import "CustomTabBar.h"
#import "FullTextViewController.h"
#import "PhotoViewController.h"
#import "OHAttributedLabel.h"
#import "HeightCalculate.h"
#import "ReplyComment.h"

@interface DynamicCell ()<OHAttributedLabelDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

{
    UIButton* nameB;
    UIButton* zanB;
    UIButton* delB;
    EGOImageButton* headB;
    UIButton * quanwenB;
    UIButton * pushB;
    CGSize msgSize;
    CGSize msgMinSize;
    float origin;
    
    UIAlertView * delDynamicAlert;
    UIAlertView * delReplyAlert;
}
@property (nonatomic,retain)UIImageView* zanimage;
@property (nonatomic,retain)NSArray* imageViews;
@property (nonatomic,retain)UILabel* msgL;
@property (nonatomic,retain)UILabel* timeL;
@property (nonatomic,retain)UILabel* transmitMsgL;
@property (nonatomic,retain)UILabel* beijingL;
@property (nonatomic,retain)UILabel* zanL;
@property (nonatomic,retain)UILabel* distancevL;
@property (nonatomic,retain)NSMutableArray* OHALabelArray;
@property (nonatomic,assign)id deleteObject;
@end
@implementation DynamicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.beijingL = [[UILabel alloc]init];
        _beijingL.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];;
        [self.contentView addSubview:_beijingL];
        
        nameB = [UIButton buttonWithType:UIButtonTypeCustom];
        [nameB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [nameB addTarget:self action:@selector(PersonDetail) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:nameB];
        nameB.titleLabel.font = [UIFont systemFontOfSize:16];
        headB = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"moren_people.png"]];
        [headB addTarget:self action:@selector(PersonDetail) forControlEvents:UIControlEventTouchUpInside];
        headB.tintColor = [UIColor grayColor];
        [self.contentView addSubview:headB];
        
        self.distancevL = [[UILabel alloc]init];
        _distancevL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_distancevL];
        
        self.transmitMsgL = [[UILabel alloc]init];
        [self.contentView addSubview:_transmitMsgL];
        _transmitMsgL.numberOfLines = 0;
        _transmitMsgL.font = [UIFont systemFontOfSize:14];
        
        self.msgL = [[UILabel alloc]init];
        _msgL.numberOfLines = 0;
        [self.contentView addSubview:_msgL];
        _msgL.font = [UIFont systemFontOfSize:14];
        
        quanwenB = [UIButton buttonWithType:UIButtonTypeCustom];
        [quanwenB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        quanwenB.titleLabel.font = [UIFont systemFontOfSize:12];
        [quanwenB addTarget:self action:@selector(quanwen) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:quanwenB];
        
        pushB = [UIButton buttonWithType:UIButtonTypeCustom];
        [pushB addTarget:self action:@selector(pushQuanwen) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:pushB];
        
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        for (int i = 0; i < 9; i++) {
            EGOImageButton * a = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
            [self.contentView addSubview:a];
            a.tag = 1000+i;
            [a addTarget:self action:@selector(loadBagImage:)  forControlEvents:UIControlEventTouchUpInside];
            [arr addObject:a];
        }
        self.imageViews = arr;
        
        self.timeL = [[UILabel alloc]init];
        _timeL.textColor = [UIColor grayColor];
        _timeL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeL];
        
        zanB = [UIButton buttonWithType:UIButtonTypeCustom];
        [zanB addTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:zanB];
        self.zanimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zan"]];
        _zanimage.frame = CGRectMake(0, 0, 25, 25);
        [zanB addSubview:_zanimage];
        self.zanL = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 35, 25)];
        _zanL.textAlignment = NSTextAlignmentCenter;
        _zanL.font = [UIFont systemFontOfSize:12];
        _zanL.textColor = [UIColor grayColor];
        [zanB addSubview:_zanL];
        
        delB = [UIButton buttonWithType:UIButtonTypeCustom];
        [delB addTarget:self action:@selector(deleteDynamic) forControlEvents:UIControlEventTouchUpInside];
        [delB setTitle:@"删除" forState:UIControlStateNormal];
        delB.titleLabel.font = [UIFont systemFontOfSize:12];
        [delB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.contentView addSubview:delB];
        
        _moveB = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moveB setBackgroundImage:[UIImage imageNamed:@"liuyan"] forState:UIControlStateNormal];
        [self.contentView addSubview:_moveB];
        [_moveB addTarget:self action:@selector(showButton) forControlEvents:UIControlEventTouchUpInside];
        
        self.OHALabelArray = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView* a in self.contentView.subviews) {
        a.frame = CGRectZero;
    }
    if (self.dynamic.petUser.headImgArray.count>0) {
        headB.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.petUser.headImgArray[0]]];
    }else
    {
       headB.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl]]; 
    }
    headB.frame = CGRectMake(10, 10, 40, 40);
    [nameB setTitle:self.dynamic.petUser.nickName forState:UIControlStateNormal];
    CGSize nameSize = [self.dynamic.petUser.nickName sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(170, 20) lineBreakMode:NSLineBreakByWordWrapping];
    nameB.frame = CGRectMake(60, 10, nameSize.width, nameSize.height);
    nameB.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    _distancevL.text = self.dynamic.distance;
    _distancevL.textAlignment = NSTextAlignmentRight;
    _distancevL.frame = CGRectMake(230, 10, 80, 15);
    
    origin = 40;
    
    if (self.dynamic.ifTransmitMsg != 0) {
        CGSize size = [self.dynamic.transmitMsg sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240, 90) lineBreakMode:NSLineBreakByWordWrapping];
        self.transmitMsgL.text = self.dynamic.transmitMsg;
        self.transmitMsgL.frame = CGRectMake(60, origin, size.width, size.height);
        origin += (size.height+10);
        
        msgSize = [self.dynamic.msg sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240, 200) lineBreakMode:NSLineBreakByWordWrapping];
        self.msgL.backgroundColor = [UIColor clearColor];
        if (msgSize.height<=90) {
            self.msgL.frame =CGRectMake(60, origin, msgSize.width, msgSize.height);
            origin+=(msgSize.height+10);
        }else{
            self.msgL.frame =CGRectMake(60, origin, 240, 18);
            origin+=28;
            pushB.frame = _msgL.frame;
        }
        self.msgL.text = self.dynamic.msg;
        if (self.dynamic.smallImage.count>=1&&self.dynamic.smallImage.count<=3) {
            int originX = 60;
            for (int i = 0; i<self.dynamic.smallImage.count; i++) {
                EGOImageButton * a = self.imageViews[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin, 75, 75);
                originX+=80;
            }
            origin+=85;
        }else if(self.dynamic.smallImage.count>3&&self.dynamic.smallImage.count<=6){
            int originX = 60;
            for (int i = 0; i<3; i++) {
                EGOImageButton * a = self.imageViews[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin, 75, 75);
                originX+=80;
            }
            originX = 60;
            for (int i = 3; i<self.dynamic.smallImage.count; i++) {
                EGOImageButton * a = self.imageViews[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin+80, 75, 75);
                originX+=80;
            }
            origin+=165;
        }else if(self.dynamic.smallImage.count>6){
            int originX = 60;
            for (int i = 0; i<3; i++) {
                EGOImageButton * a = self.imageViews[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin, 75, 75);
                originX+=80;
            }
            originX = 60;
            for (int i = 3; i<6; i++) {
                EGOImageButton * a = self.imageViews[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin+80, 75, 75);
                originX+=80;
            }
            originX = 60;
            for (int i = 6; i<self.dynamic.smallImage.count; i++) {
                EGOImageButton * a = self.imageViews[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin+160, 75, 75);
                originX+=80;
            }
            origin+=245;
        }
        self.beijingL.frame = CGRectMake(self.msgL.frame.origin.x-10, self.msgL.frame.origin.y-5, 260, origin-self.msgL.frame.origin.y);
    }else{
        _msgL.backgroundColor= [UIColor whiteColor];
        msgMinSize = [self.dynamic.msg sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240, 90) lineBreakMode:NSLineBreakByWordWrapping];
        msgSize = [self.dynamic.msg sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240, 200) lineBreakMode:NSLineBreakByWordWrapping];
        _msgL.text = self.dynamic.msg;
        _msgL.backgroundColor = [UIColor whiteColor];
        if (msgMinSize.height==msgSize.height){
            _msgL.frame = CGRectMake(60, origin, msgMinSize.width, msgMinSize.height);
            origin+=(msgMinSize.height+10);
        }
        if (msgMinSize.height<msgSize.height) {
            if (msgSize.height<180) {
                if(self.dynamic.ifZhankaied == 0)
                {
                    [quanwenB setTitle:@"展开" forState:UIControlStateNormal];
                    _msgL.frame = CGRectMake(60, origin, msgMinSize.width, msgMinSize.height);
                    origin+=(msgMinSize.height+10);
                    quanwenB.frame = CGRectMake(60, origin, 30, 15);
                    origin+=25;
                }else{
                    [quanwenB setTitle:@"收起" forState:UIControlStateNormal];
                     _msgL.frame = CGRectMake(60, origin, msgSize.width, msgSize.height);
                    origin+=(msgSize.height+10);
                    quanwenB.frame = CGRectMake(60, origin, 30, 15);
                    origin+=25;
                }
                
            }else{
                _msgL.backgroundColor= [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
                _msgL.frame = CGRectMake(60, 40, 240, 18);
                pushB.frame = _msgL.frame;
                origin+=28;
            }
        }
        if (self.dynamic.smallImage.count>=1&&self.dynamic.smallImage.count<=3) {
            int originX = 60;
            for (int i = 0; i<self.dynamic.smallImage.count; i++) {
                EGOImageButton * a = self.imageViews[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin, 75, 75);
                originX+=80;
            }
            origin+=85;
        }else if(self.dynamic.smallImage.count>3&&self.dynamic.smallImage.count<=6){
            int originX = 60;
            for (int i = 0; i<3; i++) {
                EGOImageButton * a = self.imageViews[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin, 75, 75);
                originX+=80;
            }
            originX = 60;
            for (int i = 3; i<self.dynamic.smallImage.count; i++) {
                EGOImageButton * a = self.imageViews[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin+80, 75, 75);
                originX+=80;
            }
            origin+=165;
        }else if(self.dynamic.smallImage.count>6){
            int originX = 60;
            for (int i = 0; i<3; i++) {
                EGOImageButton * a = self.imageViews[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin, 75, 75);
                originX+=80;
            }
            originX = 60;
            for (int i = 3; i<6; i++) {
                EGOImageButton * a = self.imageViews[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin+80, 75, 75);
                originX+=80;
            }
            originX = 60;
            for (int i = 6; i<self.dynamic.smallImage.count; i++) {
                EGOImageButton * a = self.imageViews[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin+160, 75, 75);
                originX+=80;
            }
            origin+=245;
        }
    }
    CGSize timeSize = [self.dynamic.submitTime sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(200, 20) lineBreakMode:NSLineBreakByWordWrapping];
    _timeL.text = self.dynamic.submitTime;
    _timeL.frame = CGRectMake(60, origin+5, timeSize.width, timeSize.height);
    if ([[DataStoreManager getMyUserID] intValue] == [self.dynamic.petUser.userId intValue]) {
        delB.frame = CGRectMake(150, origin, 30, 25);
    }
    _zanL.text = [NSString stringWithFormat:@"%d",self.dynamic.countZan];
    if (self.dynamic.ifIZaned) {
        _zanimage.image = [UIImage imageNamed:@"zaned"];
    }else{
        _zanimage.image = [UIImage imageNamed:@"zan"];
    }
    zanB.frame = CGRectMake(220, origin, 50, 25);
    _moveB.frame = CGRectMake(280, origin, 30, 25);
    
    origin+=35;
    
    int count = 0;
    for (Reply* reply in self.dynamic.replyViews) {
        count++;
        for (id a in reply.replyComments) {
            count++;
        }
    }
    if (self.OHALabelArray.count<count) {
        int a = count - self.OHALabelArray.count;
        for (int i = 0; i < a; i++) {
            OHAttributedLabel* ohaL = [[OHAttributedLabel alloc]initWithFrame:CGRectZero];
            ohaL.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
            ohaL.delegate = self;
            [self.OHALabelArray addObject:ohaL];
            [self.contentView addSubview:ohaL];
        }
    }
    int number = 0;
    for (int i = 0; i < self.dynamic.replyViews.count; i++) {
        OHAttributedLabel* ohaL = (OHAttributedLabel*)self.OHALabelArray[number];
        number++;
        Reply* rel = (Reply*)self.dynamic.replyViews[i];
        NSString* repS = [NSString stringWithFormat:@"%@:%@",rel.petUser.nickName,rel.msg];
        [ohaL setDisplayText:repS WithCommentArray:@[@{@"nickName": rel.petUser.nickName,@"petUser":rel}] MaxWidth:240];
        CGSize size = [HeightCalculate calSizeWithString:repS WithMaxWidth:240];
        [ohaL setFrame:CGRectMake(60 , origin, 250, size.height)];
        origin += (size.height+5);
        for (int j = 0; j < rel.replyComments.count; j++) {
            OHAttributedLabel* ohaL = (OHAttributedLabel*)self.OHALabelArray[number];
            number++;
            ReplyComment* recom = (ReplyComment*)rel.replyComments[j];
            NSString* repS = [NSString stringWithFormat:@"%@回复%@:%@",recom.commentUserView.nickName,recom.replyUserView.nickName,recom.commentsMsg];
            [ohaL setDisplayText:repS WithCommentArray:@[@{@"nickName": recom.commentUserView.nickName,@"petUser":recom},@{@"nickName": recom.replyUserView.nickName,@"petUser":recom}] MaxWidth:240];
            CGSize size = [HeightCalculate calSizeWithString:repS WithMaxWidth:240];
            [ohaL setFrame:CGRectMake(60 , origin, 260, size.height)];
            origin += (size.height+5);
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - button action
-(void)showButton
{
    [self.viewC performSelector:@selector(showButton:) withObject:self];
}
-(void)deleteDynamic
{
    delDynamicAlert = [[UIAlertView alloc]initWithTitle:nil message:@"确定删除这条动态?" delegate:self cancelButtonTitle:@"点错啦" otherButtonTitles:@"确定", nil];
    [delDynamicAlert show];
}

-(void)PersonDetail
{
    if ([self.dynamic.petUser.userId integerValue] == [[DataStoreManager getMyUserID] integerValue]) {
        [self.viewC  performSelector:@selector(headAct) withObject:nil];
        return;
    }
    PersonDetailViewController*personVC = [[PersonDetailViewController alloc]init];
    personVC.hostInfo = self.dynamic.petUser;
    [self.viewC.navigationController pushViewController:personVC animated:YES];
    [self.viewC.customTabBarController hidesTabBar:YES animated:YES];
}
-(void)quanwen
{
    if (_msgL.frame.size.height<msgSize.height) {
        _msgL.frame = CGRectMake(70, 40, msgSize.width, msgSize.height);
        self.dynamic.rowHigh+=(msgSize.height-msgMinSize.height);
        self.dynamic.ifZhankaied = 1;
        [quanwenB setTitle:@"收起" forState:UIControlStateNormal];
    }else{
        _msgL.frame = CGRectMake(70, 40, msgMinSize.width, msgMinSize.height);
        self.dynamic.ifZhankaied = 0;
        self.dynamic.rowHigh-=(msgSize.height-msgMinSize.height);
        [quanwenB setTitle:@"展开" forState:UIControlStateNormal];
    }
    [(UITableView*)self.superview reloadData];
}
-(void)pushQuanwen
{
    FullTextViewController* fullTextVC = [[FullTextViewController alloc]init];
    fullTextVC.text = _msgL.text;
    [self.viewC.navigationController pushViewController:fullTextVC animated:YES];
    [self.viewC.customTabBarController hidesTabBar:YES animated:YES];
}
-(void)praise//赞
{
    zanB.userInteractionEnabled = NO;
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:@"0" forKey:@"zanType"];
    [params setObject:@"" forKey:@"petid"];
    [params setObject:self.dynamic.petUser.userId forKey:@"zanUserid"];
    [params setObject:self.dynamic.dynamicID forKey:@"userStateid"];
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    if (self.dynamic.ifIZaned) {
        [body setObject:@"delZan" forKey:@"method"];
        [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self.viewC success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.dynamic.ifIZaned=!self.dynamic.ifIZaned;
            if ([_zanL.text intValue]>0) {
                _zanL.text =[NSString stringWithFormat:@"%d",[_zanL.text intValue]-1 ];
            }
            _zanimage.image = [UIImage imageNamed:@"zan"];
            zanB.userInteractionEnabled = YES;
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            zanB.userInteractionEnabled = YES;
        }];
    }else{
        [body setObject:@"addZan" forKey:@"method"];
        [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self.viewC success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.dynamic.ifIZaned=!self.dynamic.ifIZaned;
            _zanL.text =[NSString stringWithFormat:@"%d",[_zanL.text intValue]+1 ];
            _zanimage.image = [UIImage imageNamed:@"zaned"];
            zanB.userInteractionEnabled = YES;
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            zanB.userInteractionEnabled = YES;
        }];
    }
}
-(void)loadBagImage:(UIButton*)button
{
    PhotoViewController* vc = [[PhotoViewController alloc]initWithSmallImages:self.dynamic.smallImage images:self.dynamic.imgIDArray indext:button.tag-1000];
    [self.viewC presentViewController:vc animated:NO completion:nil];
}
#pragma mark - OHAttributedLabel Delegate
-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
    return YES;
}
-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldUserName:(NSString *)userName TheID:(id)theid theIndex:(int)theIndex
{
    HostInfo* hostInfo = nil;
    if (theIndex == 0) {
        if ([theid isKindOfClass:[Reply class]]) {
            hostInfo = ((Reply*)theid).petUser;
        }
        if ([theid isKindOfClass:[ReplyComment class]]) {
            hostInfo = ((ReplyComment*)theid).commentUserView;
        }
    }else{
        hostInfo = ((ReplyComment*)theid).replyUserView;
    }
    if ([hostInfo.userId integerValue] == [[DataStoreManager getMyUserID] integerValue]) {
        [self.viewC  performSelector:@selector(headAct) withObject:nil];
        return YES;
    }
    PersonDetailViewController*personVC = [[PersonDetailViewController alloc]init];
    personVC.hostInfo = hostInfo;
    [self.viewC.navigationController pushViewController:personVC animated:YES];
    [self.viewC.customTabBarController hidesTabBar:YES animated:YES];

    return YES;
}

-(void)labelTouchedWithNickName:(NSString *)nickName TheID:(id)theID
{
    if ([theID isKindOfClass:[Reply class]]) {
        if ([self.dynamic.petUser.userId integerValue] == [[DataStoreManager getMyUserID] integerValue]||[((Reply*)theID).petUser.userId integerValue] == [[DataStoreManager getMyUserID] integerValue]) {
            UIActionSheet* action = [[UIActionSheet alloc]initWithTitle:@"你要做什么" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"回复", nil];
            [action showInView:self.superview];
            self.deleteObject = theID;
            return;
        }
    }
    if ([theID isKindOfClass:[ReplyComment class]]) {
        if ([self.dynamic.petUser.userId integerValue] == [[DataStoreManager getMyUserID] integerValue]||[((ReplyComment*)theID).commentUserView.userId integerValue] == [[DataStoreManager getMyUserID] integerValue]) {
            UIActionSheet* action = [[UIActionSheet alloc]initWithTitle:@"你要做什么" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"回复", nil];
            [action showInView:self.superview];
            self.deleteObject = theID;
            return;
        }
    }
    [self.viewC performSelector:@selector(recalledreply: cell:) withObject:self.deleteObject withObject:self];
}
#pragma mark - OHAttributedLabel Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        delReplyAlert = [[UIAlertView alloc]initWithTitle:nil message:@"确定删除该评论?" delegate:self cancelButtonTitle:@"点错啦" otherButtonTitles:@"确定", nil];
        [delReplyAlert show];
    }
    if (buttonIndex == 1) {
        [self.viewC performSelector:@selector(recalledreply: cell:) withObject:self.deleteObject withObject:self];
    }
}
#pragma mark - alert view delegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == delDynamicAlert) {
        if (buttonIndex == 1) {
            [self.viewC performSelector:@selector(deleteDynamic:) withObject:self.dynamic];
        }
    }
    if (alertView == delReplyAlert) {
        if (buttonIndex == 1) {
            if ([self.deleteObject isKindOfClass:[Reply class]]) {
                NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
                NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
                long long a = (long long)(cT*1000);
                [params setObject:((Reply*)self.deleteObject).replyID forKey:@"replyId"];
                NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
                [body setObject:@"1" forKey:@"channel"];
                [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
                [body setObject:@"iphone" forKey:@"imei"];
                [body setObject:params forKey:@"params"];
                [body setObject:@"delReply" forKey:@"method"];
                [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
                [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
                [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self.viewC success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self.dynamic.replyViews removeObject:self.deleteObject];
                    self.dynamic.rowHigh-=((((Reply*)self.deleteObject).replyComments.count+1)*28);
                    [(UITableView*)self.superview reloadData];
                }];
                [self.dynamic.replyViews removeObject:self.deleteObject];
            }
            if ([self.deleteObject isKindOfClass:[ReplyComment class]]) {
                Reply* theReply = nil;
                for (Reply* rep in self.dynamic.replyViews) {
                    for (ReplyComment * repcom in rep.replyComments) {
                        if ([self.deleteObject isEqual:repcom]) {
                            theReply = rep;
                        }
                    }
                }
                if (theReply) {
                    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
                    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
                    long long a = (long long)(cT*1000);
                    [params setObject:((ReplyComment*)self.deleteObject).replyCommentID forKey:@"replyCommonid"];
                    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
                    [body setObject:@"1" forKey:@"channel"];
                    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
                    [body setObject:@"iphone" forKey:@"imei"];
                    [body setObject:params forKey:@"params"];
                    [body setObject:@"delCommentReply" forKey:@"method"];
                    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
                    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
                    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self.viewC success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [theReply.replyComments removeObject:self.deleteObject];
                        self.dynamic.rowHigh-=28;
                        [(UITableView*)self.superview reloadData];
                    }];
                }
                
            }
        }
    }
    
}
@end
