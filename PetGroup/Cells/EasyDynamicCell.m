//
//  EasyDynamicCell.m
//  PetGroup
//
//  Created by 阿铛 on 13-9-23.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "EasyDynamicCell.h"
#import "EGOImageButton.h"
#import "PersonDetailViewController.h"
#import "CustomTabBar.h"
#import "FullTextViewController.h"
@interface EasyDynamicCell()
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
}
@property (nonatomic,retain)UIImageView* zanimage;
@property (nonatomic,retain)NSArray* imageViews;
@property (nonatomic,retain)UILabel* msgL;
@property (nonatomic,retain)UILabel* timeL;
@property (nonatomic,retain)UILabel* transmitMsgL;
@property (nonatomic,retain)UILabel* beijingL;
@property (nonatomic,retain)UILabel* zanL;
@property (nonatomic,retain)UIView * waitView;
@property (nonatomic,retain)NSTimer * time;
@property (nonatomic,retain)UILabel* warningL;
@end
@implementation EasyDynamicCell

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
        self.zanL = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 35, 30)];
        _zanL.textAlignment = NSTextAlignmentCenter;
        _zanL.font = [UIFont systemFontOfSize:12];
        _zanL.textColor = [UIColor grayColor];
        [zanB addSubview:_zanL];
        self.zanimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zan"]];
        _zanimage.frame = CGRectMake(0, 0, 30, 30);
        [zanB addSubview:_zanimage];
        
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
        
        self.waitView = [[UIView alloc]initWithFrame:CGRectZero];
        _waitView.backgroundColor = [UIColor clearColor];
        _waitView.hidden = YES;
        [self.contentView addSubview:_waitView];
        for (int i = 0; i<4; i++) {
            UIView* a= [[UIView alloc]initWithFrame:CGRectMake(i*10+7.5, 12.5, 5, 5)];
            a.backgroundColor = [UIColor colorWithRed:0.5+i*0.1 green:0.5+i*0.1 blue:0.5+i*0.1 alpha:1];
            a.tag = 1000+i;
            [_waitView addSubview:a];
        }
        self.warningL = [[UILabel alloc]initWithFrame:CGRectZero];
        _warningL.backgroundColor = [UIColor yellowColor];
        _warningL.alpha = 0.5;
        _warningL.text = @"该动态内容不适合对外公开";
        _warningL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_warningL];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    nameB.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    origin = 40;
    
    if ([self.dynamic.stateType intValue] == 4||[self.dynamic.stateType intValue] == 5) {
        self.warningL.frame = CGRectMake(60, origin, 150, 20);
        origin+=28;
    }
    
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
    _timeL.frame = CGRectMake(60, origin+7, timeSize.width, timeSize.height);
    if ([[[TempData sharedInstance] getMyUserID] intValue] == [self.dynamic.petUser.userId intValue]) {
        delB.frame = CGRectMake(150, origin, 30, 30);
    }
    _zanL.text = [NSString stringWithFormat:@"%d",self.dynamic.countZan];
    if (self.dynamic.ifIZaned) {
        _zanimage.image = [UIImage imageNamed:@"zaned"];
    }else{
        _zanimage.image = [UIImage imageNamed:@"zan"];
    }
    zanB.frame = CGRectMake(220, origin, 50, 30);
    _moveB.frame = CGRectMake(280, origin, 30, 30);
    _waitView.frame = zanB.frame;
    
    origin+=35;
}
#pragma mark - button action
-(void)showButton
{
    [self.viewC performSelector:@selector(showButton:) withObject:self];
}
-(void)deleteDynamic
{
    UIAlertView*delDynamicAlert = [[UIAlertView alloc]initWithTitle:nil message:@"确定删除这条动态?" delegate:self cancelButtonTitle:@"点错啦" otherButtonTitles:@"确定", nil];
    [delDynamicAlert show];
}

-(void)PersonDetail
{
    if ([self.dynamic.petUser.userId integerValue] == [[[TempData sharedInstance] getMyUserID] integerValue]) {
      //  [self.viewC  performSelector:@selector(headAct) withObject:nil];
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
-(void)timerDown
{
    CGRect rect = ((UIView*)_waitView.subviews[0]).frame;
    ((UIView*)_waitView.subviews[0]).frame = ((UIView*)_waitView.subviews[1]).frame;
    ((UIView*)_waitView.subviews[1]).frame = ((UIView*)_waitView.subviews[2]).frame;
    ((UIView*)_waitView.subviews[2]).frame = ((UIView*)_waitView.subviews[3]).frame;
    ((UIView*)_waitView.subviews[3]).frame = rect;
}
-(void)praise//赞
{
    zanB.userInteractionEnabled = NO;
    _waitView.hidden = NO;
    self.time = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(timerDown) userInfo:nil repeats:YES];
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
            self.dynamic.countZan-=1;
            _zanimage.image = [UIImage imageNamed:@"zan"];
            [_time invalidate];
            _waitView.hidden = YES;
            zanB.userInteractionEnabled = YES;
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_time invalidate];
            _waitView.hidden = YES;
            zanB.userInteractionEnabled = YES;
        }];
    }else{
        [body setObject:@"addZan" forKey:@"method"];
        [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self.viewC success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.dynamic.ifIZaned=!self.dynamic.ifIZaned;
            self.dynamic.countZan+=1;
            _zanL.text =[NSString stringWithFormat:@"%d",[_zanL.text intValue]+1 ];
            _zanimage.image = [UIImage imageNamed:@"zaned"];
            [_time invalidate];
            _waitView.hidden = YES;
            zanB.userInteractionEnabled = YES;
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_time invalidate];
            _waitView.hidden = YES;
            zanB.userInteractionEnabled = YES;
        }];
    }
}
-(void)loadBagImage:(UIButton*)button
{
    NSMutableArray* array = [NSMutableArray new];
    for (UIButton* button in self.imageViews) {
        [array addObject:button.currentImage];
    }
    PhotoViewController* vc = [[PhotoViewController alloc]initWithSmallImages:array images:self.dynamic.imgIDArray indext:button.tag-1000];
    [self.viewC presentViewController:vc animated:NO completion:nil];
}
#pragma mark - alert view delegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.viewC performSelector:@selector(deleteDynamic:) withObject:self.dynamic];
    }
}
@end
