//
//  QRCodeViewController.m
//  PetGroup
//
//  Created by Tolecen on 14-1-15.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import "QRCodeViewController.h"
#import "QRCustomViewController.h"
#import "AddPetMessageViewController.h"
#import "ShowPetMessageViewController.h"
#import "QRCodeCell.h"
@interface QRCodeViewController ()<CustomViewControllerDelegate,AddRQCodeMessageDelegate>
{
    int QRCustomType;
}

@end

@implementation QRCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        petListArray = [NSMutableArray array];
        QRCustomType = 0;//扫描状态为0添加,为1查看
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1]];
    
    diffH = [Common diffHeight:self];

    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(90, 2+diffH, 140, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text = @"二维码";
    [titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIImageView* imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44+diffH, 320, 160)];
    imageV.image = [UIImage imageNamed:@"saomiao_bg"];
    [self.view addSubview:imageV];
    
    UIButton * addV = [UIButton buttonWithType:UIButtonTypeCustom];
    [addV setFrame:CGRectMake(20, 44+diffH+20, 120, 120)];
    [addV setBackgroundImage:[UIImage imageNamed:@"add_saomiao"] forState:UIControlStateNormal];
    [addV addTarget:self action:@selector(addRQCodeMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addV];
    
    UIButton * scanV = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanV setFrame:CGRectMake(180, 44+diffH+20, 120, 120)];
    [scanV setBackgroundImage:[UIImage imageNamed:@"saomiao"] forState:UIControlStateNormal];
    [scanV addTarget:self action:@selector(pressButton1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanV];
        
    UILabel *sLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,254+diffH, 320, 50)];
    sLabel.textAlignment = NSTextAlignmentCenter;
    [sLabel setTextColor:[UIColor orangeColor]];
    [sLabel setBackgroundColor:[UIColor clearColor]];
    [sLabel setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:sLabel];
    [sLabel setText:@"您尚未绑定挂件!"];
    
    UIImageView* pinImageV =  [[UIImageView alloc]initWithFrame:CGRectMake(53, 324+diffH, 214, 141)];
    pinImageV.image = [UIImage imageNamed:@"QRCodetishi"];
    [self.view addSubview:pinImageV];

    self.profileTableV = [[UITableView alloc] initWithFrame:CGRectMake(0,204+diffH, 320, self.view.frame.size.height-(204+diffH+20)) style:UITableViewStylePlain];
    [self.view addSubview:self.profileTableV];
    self.profileTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.profileTableV.backgroundView = nil;
    self.profileTableV.dataSource = self;
    self.profileTableV.delegate = self;
    self.profileTableV.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    self.profileTableV.hidden = YES;
    [self getPetCardList];
    
    hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.delegate = self;
    hud.labelText = @"加载信息...";
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return petListArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Cell = @"profile";
    
    QRCodeCell *cell = (QRCodeCell *)[tableView dequeueReusableCellWithIdentifier:Cell];
    if (cell == nil) {
        cell = [[QRCodeCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:Cell];
    }
    cell.RQCodeMsg =petListArray[indexPath.row];
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShowPetMessageViewController * addPV = [[ShowPetMessageViewController alloc] init];
    addPV.RQCodeMessage = petListArray[indexPath.row];
    addPV.delegate = self;
    [self.navigationController pushViewController:addPV animated:YES];
}

-(void)getPetCardList
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:@"0" forKey:@"pageNo"];
    [params setObject:@"20" forKey:@"pageSize"];
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getPetCardList" forKey:@"method"];
    [body setObject:@"service.uri.pet_user" forKey:@"service"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [petListArray addObjectsFromArray:responseObject];
        [self.profileTableV reloadData];
        self.profileTableV.hidden = NO;
        if (petListArray.count==0) {
            self.profileTableV.hidden = YES;
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.profileTableV.hidden = YES;
    }];

}

-(void)getInfoByCardID:(NSString *)theID
{
    [hud show:YES];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:theID forKey:@"id"];
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"getPetCardById" forKey:@"method"];
    [body setObject:@"service.uri.pet_user" forKey:@"service"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if (QRCustomType == 0) {
            if (responseObject[@"userId"]) {
                [self.navigationController popToViewController:self animated:NO];
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"该挂件已被绑定" delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
                [alert show];
                return ;
            }
            AddPetMessageViewController*addpetVC = [[AddPetMessageViewController alloc]init];
            addpetVC.delegate = self;
            addpetVC.RQCodeMessage = [NSMutableDictionary dictionaryWithDictionary:responseObject];
            [self.navigationController popToViewController:self animated:NO];
            [self.navigationController pushViewController:addpetVC animated:YES];
        }
        if (QRCustomType == 1) {
            ShowPetMessageViewController * addPV = [[ShowPetMessageViewController alloc] init];
            addPV.RQCodeMessage = [NSMutableDictionary dictionaryWithDictionary:responseObject];
            addPV.delegate = self;
            [self.navigationController popToViewController:self animated:NO];
            [self.navigationController pushViewController:addPV animated:YES];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"加载失败" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        //        self.profileTableV.hidden = YES;
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)addRQCodeMessage
{
    QRCustomType = 0;
    QRCustomViewController *vc = [[QRCustomViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)back
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)pressButton1:(UIButton*)button
{
    QRCustomType = 1;
    QRCustomViewController *vc = [[QRCustomViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - QRCustomViewControllerViewController
- (void)customViewController:(QRCustomViewController *)controller didScanResult:(NSString *)result
{
    NSString * resultStr = result;
    if ([self parseString:resultStr]) {
        resultString = resultStr;
        NSRange range = [resultStr rangeOfString:@"/p.html"];
        if (range.location!=NSNotFound) {
            NSRange range=[resultStr rangeOfString:@"share/"];
            if (range.location!=NSNotFound) {
                NSArray *imageArray = [resultStr componentsSeparatedByString:@"share/"];
                if (imageArray.count>0) {
                    NSString * codeID = imageArray[1];
                    NSString * realCodeID = [codeID substringToIndex:(codeID.length-7)];
                    [self getInfoByCardID:realCodeID];
                }
                else{
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:[NSString stringWithFormat:@"扫描到网址:%@,要打开它吗",resultStr] delegate:self cancelButtonTitle:@"不打开" otherButtonTitles:@"打开", nil];
                    [alert show];
                }
            }
            else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:[NSString stringWithFormat:@"扫描到网址:%@,要打开它吗",resultStr] delegate:self cancelButtonTitle:@"不打开" otherButtonTitles:@"打开", nil];
                [alert show];
            }
        }
        else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:[NSString stringWithFormat:@"扫描到网址:%@,要打开它吗",resultStr] delegate:self cancelButtonTitle:@"不打开" otherButtonTitles:@"打开", nil];
            [alert show];
        }

        NSLog(@"a website");
    }
    else
    {
        ContentDetailViewController * cv = [[ContentDetailViewController alloc] init];
        cv.contentType = contentTypeTextView;
        cv.typeName = @"扫描内容";
        cv.contentStrS = [[NSAttributedString alloc] initWithString:resultStr];
        [self.navigationController popToViewController:self animated:NO];
        [self.navigationController pushViewController:cv animated:YES];
    }

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        ContentDetailViewController * cv = [[ContentDetailViewController alloc] init];
        cv.contentType = contentTypeWebView;
        cv.typeName = @"扫描内容";
        cv.addressURL = [NSURL URLWithString:resultString];
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:NO];
        [self.navigationController pushViewController:cv animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(BOOL)parseString:(NSString *)theStr
{
    //组装一个字符串，需要把里面的网址解析出来
    NSString *urlString=theStr;
    
    NSError *error;
    
    //http+:[^\\s]* 这个表达式是检测一个网址的。[0-9]{3,}
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http+:[^\\s]*"
                                                                           options:0
                                                                             error:&error];
    NSLog( @"regex is %@", regex );
    
    if (regex != nil)
    {
        
        NSArray *array = [regex matchesInString: urlString
                                        options: 0 range: NSMakeRange( 0, [urlString length])];
        if (array.count>0) {
            return YES;
        }
        else
            return NO;
        
        
    }
    else
        return NO;
}

- (void)customViewControllerDidCancel:(QRCustomViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)finishAddRQCodeMessageWithPet:(NSDictionary*)pet
{
    for (NSDictionary* dic in petListArray) {
        if ([pet[@"id"] isEqualToString:dic[@"id"]]) {
            [_profileTableV reloadData];
            _profileTableV.hidden = NO;
            [self.navigationController popToViewController:self animated:YES];
            return;
        }
    }
    [petListArray addObject:pet];
    [_profileTableV reloadData];
    _profileTableV.hidden = NO;
    [self.navigationController popToViewController:self animated:YES];
}
- (void)finishDelRQCodeMessageWithPet:(NSDictionary*)pet
{
    NSArray* arr = [petListArray mutableCopy];
    for (NSDictionary* dic in arr) {
        if ([pet[@"id"] isEqualToString:dic[@"id"]]) {
            [petListArray removeObject:dic];
            [_profileTableV reloadData];
            if (petListArray.count == 0) {
                _profileTableV.hidden = YES;
            }
            [self.navigationController popToViewController:self animated:YES];
            return;
        }
    }
}
@end
