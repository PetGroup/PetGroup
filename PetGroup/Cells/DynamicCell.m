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

@interface DynamicCell ()<OHAttributedLabelDelegate>

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
@property (nonatomic,retain)UILabel* distancevL;
@property (nonatomic,retain)NSMutableArray* OHALabelArray;
@end
@implementation DynamicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.beijingL = [[UILabel alloc]init];
        _beijingL.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];;
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
            EGOImageButton * a = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"moren_people.png"]];
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
        _zanimage.frame = CGRectMake(0, 0, 15, 15);
        [zanB addSubview:_zanimage];
        self.zanL = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 35, 15)];
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
        [_moveB setBackgroundImage:[UIImage imageNamed:@"pinglun"] forState:UIControlStateNormal];
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

    headB.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.petUser.headImgArray[0]]];
    headB.frame = CGRectMake(10, 10, 40, 40);
    [nameB setTitle:self.dynamic.petUser.nickName forState:UIControlStateNormal];
    CGSize nameSize = [self.dynamic.petUser.nickName sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(240, 20) lineBreakMode:NSLineBreakByWordWrapping];
    nameB.frame = CGRectMake(60, 10, nameSize.width, nameSize.height);
    _distancevL.text = self.dynamic.distance;
    _distancevL.frame = CGRectMake(150, 10, 50, 15);
    
    origin = 40;
    
    if (self.dynamic.ifTransmitMsg != 0) {
        CGSize size = [self.dynamic.transmitMsg sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240, 50) lineBreakMode:NSLineBreakByWordWrapping];
        self.transmitMsgL.text = self.dynamic.transmitMsg;
        self.transmitMsgL.frame = CGRectMake(60, origin, size.width, size.height);
        origin += (size.height+10);
        
        msgSize = [self.dynamic.msg sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(240, 200) lineBreakMode:NSLineBreakByWordWrapping];
        self.msgL.backgroundColor = [UIColor clearColor];
        if (msgSize.height<90) {
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
            origin+=170;
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
            origin+=255;
        }
        self.beijingL.frame = CGRectMake(self.msgL.frame.origin.x-10, self.msgL.frame.origin.y, 260, origin-self.msgL.frame.origin.x-10);
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
                     _msgL.frame = CGRectMake(60, origin, msgSize.width, msgSize.height);
                    origin+=(msgSize.height+10);
                    quanwenB.frame = CGRectMake(60, origin, 30, 15);
                    origin+=25;
                }
                
            }else{
                _msgL.backgroundColor= [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
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
            origin+=170;
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
            origin+=255;
        }
    }
    CGSize timeSize = [self.dynamic.submitTime sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(200, 20) lineBreakMode:NSLineBreakByWordWrapping];
    _timeL.text = self.dynamic.submitTime;
    _timeL.frame = CGRectMake(60, origin, timeSize.width, timeSize.height);
    if ([[DataStoreManager getMyUserID] intValue] == [self.dynamic.petUser.userId intValue]) {
        delB.frame = CGRectMake(150, origin, 30, 15);
    }
    _zanL.text = [NSString stringWithFormat:@"%d",self.dynamic.countZan];
    if (self.dynamic.ifIZaned) {
        _zanimage.image = [UIImage imageNamed:@"zaned"];
    }else{
        _zanimage.image = [UIImage imageNamed:@"zan"];
    }
    zanB.frame = CGRectMake(220, origin, 50, 15);
    _moveB.frame = CGRectMake(280, origin, 30, 15);
    
    origin+=25;
    
    if (self.OHALabelArray.count<self.dynamic.replyViews.count) {
        int a = self.dynamic.replyViews.count - self.OHALabelArray.count;
        for (int i = 0; i < a; i++) {
            OHAttributedLabel* ohaL = [[OHAttributedLabel alloc]initWithFrame:CGRectZero];
            [self.OHALabelArray addObject:ohaL];
            [self.contentView addSubview:ohaL];
        }
    }
    for (int i = 0; i < self.dynamic.replyViews.count; i++) {
        OHAttributedLabel* ohaL = (OHAttributedLabel*)self.OHALabelArray[i];
        Reply* rel = (Reply*)self.dynamic.replyViews[i];
        NSString* repS = [NSString stringWithFormat:@"%@:%@",rel.petUser.nickName,rel.msg];
        [ohaL setDisplayText:repS WithCommentArray:@[[NSString stringWithFormat:@"%@;%@",rel.petUser.nickName,rel.petUser.userId]] MaxWidth:200];
        ohaL.delegate = self;
        CGSize size = [HeightCalculate calSizeWithString:repS WithMaxWidth:200];
        [ohaL setFrame:CGRectMake(60 , origin, 250, size.height)];
        
        origin += (size.height+10);
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
    [self.viewC performSelector:@selector(deleteDynamic:) withObject:self.dynamic];
}

-(void)PersonDetail
{
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
        [NetManager requestWithURLStr:BaseClientUrl Parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            self.dynamic.ifIZaned=!self.dynamic.ifIZaned;
            _zanL.text =[NSString stringWithFormat:@"%d",[_zanL.text intValue]-1 ];
            _zanimage.image = [UIImage imageNamed:@"zan"];
        }];
    }else{
        [body setObject:@"addZan" forKey:@"method"];
        [NetManager requestWithURLStr:BaseClientUrl Parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            self.dynamic.ifIZaned=!self.dynamic.ifIZaned;
            _zanL.text =[NSString stringWithFormat:@"%d",[_zanL.text intValue]+1 ];
            _zanimage.image = [UIImage imageNamed:@"zaned"];
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
-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldUserName:(NSString *)userName TheID:(NSString *)theid
{
    NSLog(@"点击了%@,%@",userName,theid);
    
    return YES;
}

-(void)labelTouchedWithNickName:(NSString *)nickName TheID:(NSString *)theID
{
    NSLog(@"回复：%@,%@",nickName,theID);
}

@end
