//
//  QRCodeViewController.m
//  PetGroup
//
//  Created by Tolecen on 14-1-15.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import "QRCodeViewController.h"
#import <QRCodeReader.h>
#import "QRCustomViewController.h"
@interface QRCodeViewController ()<CustomViewControllerDelegate>

@end

@implementation QRCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        petListArray = [NSArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:@"jdahsdhkasdj12",@"id",@"哈哈哈哈",@"petNickname", nil]];
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
    
//    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button1 setTitle:@"扫描器" forState:UIControlStateNormal];
//    [button1 setFrame:CGRectMake(10.f, 240.f, 140.f, 50.f)];
//    [button1 addTarget:self action:@selector(pressButton1:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button1];
    
    
    UIButton * addV = [UIButton buttonWithType:UIButtonTypeCustom];
    [addV setFrame:CGRectMake(20, 44+diffH+20, 120, 120)];
    [addV setBackgroundColor:[UIColor purpleColor]];
    [addV setTitle:@"添加" forState:UIControlStateNormal];
    [addV setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addV.titleLabel setFont:[UIFont systemFontOfSize:22]];
    addV.layer.cornerRadius = 8;
    addV.layer.masksToBounds = YES;
    [self.view addSubview:addV];
    
    UIButton * scanV = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanV setFrame:CGRectMake(180, 44+diffH+20, 120, 120)];
    [scanV setBackgroundColor:[UIColor blueColor]];
    [scanV setTitle:@"扫描" forState:UIControlStateNormal];
    [scanV setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scanV.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [scanV addTarget:self action:@selector(pressButton1:) forControlEvents:UIControlEventTouchUpInside];
    scanV.layer.cornerRadius = 8;
    scanV.layer.masksToBounds = YES;
    [self.view addSubview:scanV];

    self.profileTableV = [[UITableView alloc] initWithFrame:CGRectMake(0,204+diffH, 320, self.view.frame.size.height-(204+diffH+20)) style:UITableViewStylePlain];
    [self.view addSubview:self.profileTableV];
    self.profileTableV.backgroundView = nil;
    self.profileTableV.dataSource = self;
    self.profileTableV.delegate = self;
    self.profileTableV.backgroundColor = [UIColor clearColor];
    
    [self getPetCardList];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [self setCardInfoByID:@"1KL35D"];
    [self getInfoByCardID:@"1KL35D"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return petListArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Cell = @"profile";
    
    PetProfileCell *cell = (PetProfileCell *)[tableView dequeueReusableCellWithIdentifier:Cell];
    if (cell == nil) {
        cell = [[PetProfileCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:Cell];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.titleLabel.frame =CGRectMake(20, 10, 130, 20);
    cell.describeLabel.frame =CGRectMake(160, 10, 120, 20);
    cell.titleLabel.textColor = [UIColor grayColor];
    cell.titleLabel.text = [petListArray[indexPath.row] objectForKey:@"id"];
    cell.describeLabel.text = [petListArray[indexPath.row] objectForKey:@"petNickname"];
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        petListArray = responseObject;
        [self.profileTableV reloadData];
        if (petListArray.count==0) {
            self.profileTableV.hidden = YES;
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        self.profileTableV.hidden = YES;
    }];

}

-(void)getInfoByCardID:(NSString *)theID
{
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

        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        self.profileTableV.hidden = YES;
    }];
}
-(void)setCardInfoByID:(NSString *)theID
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:theID forKey:@"id"];
    [params setObject:@"hahahaha" forKey:@"petType"];
    [params setObject:@"数据库类" forKey:@"petNickname"];
    [params setObject:@"kjklkk" forKey:@"petOwner"];
    [params setObject:@"15165333394" forKey:@"petOwnerTel"];
    [params setObject:@"asjklajsdjas" forKey:@"petOwnerMsg"];
    
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"setPetCard" forKey:@"method"];
    [body setObject:@"service.uri.pet_user" forKey:@"service"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        self.profileTableV.hidden = YES;
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)back
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)pressButton1:(UIButton*)button
{
    QRCustomViewController *vc = [[QRCustomViewController alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:^{}];
}
#pragma mark - QRCustomViewControllerViewController
- (void)customViewController:(QRCustomViewController *)controller didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@",result);
    }];

}
- (void)customViewControllerDidCancel:(QRCustomViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
