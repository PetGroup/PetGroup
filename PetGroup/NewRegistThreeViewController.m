//
//  NewRegistThreeViewController.m
//  NewXMPPTest
//
//  Created by 阿铛 on 13-8-19.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "NewRegistThreeViewController.h"
#import "DedLoginViewController.h"
#import "IdentifyingString.h"
#import <CoreLocation/CoreLocation.h>
#import "TempData.h"
#import "MBProgressHUD.h"
#import "DataStoreManager.h"

@interface NewRegistThreeViewController ()<UITextFieldDelegate>
{
    UIButton * manB;
    UIButton * womanB;
    UIButton * cityB;
    UIButton* ageB;
    MBProgressHUD *hud;
}
@property (nonatomic ,strong) NSMutableArray* ageArray;
@property (nonatomic ,strong) NSArray* ProvinceArray;
@property (nonatomic ,strong) NSArray* cityArray;
@property (nonatomic ,strong) UIPickerView* cityPV;
@property (nonatomic ,strong) UIPickerView* agePV;
@property (nonatomic ,strong) UITextField* nameTF;
@property (nonatomic ,strong) UITextField* passWordTF;
@property (nonatomic ,strong) UITextField* nickNameTF;
@property (nonatomic ,strong) UITextField* cityTF;
@property (nonatomic ,strong) UITextField* ageTF;
@property (nonatomic ,strong) NSString* sexS;
@property (nonatomic ,strong) UILabel* cityL;
@property (nonatomic ,strong) UILabel* ageL;

@end

@implementation NewRegistThreeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.ageArray = [[NSMutableArray alloc]init];
        for (int i = 1; i <= 100; i++) {
            [_ageArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        NSString *path =[[NSString alloc]initWithString:[[NSBundle mainBundle]pathForResource:@"city"ofType:@"txt"]];
        NSData* data = [[NSData alloc]initWithContentsOfFile:path];
        self.ProvinceArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.cityArray = [_ProvinceArray[0] objectForKey:@"city"];
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden =YES;
    self.view.backgroundColor = [UIColor orangeColor];
    
    float diffH = [Common diffHeight:self];
    UIImageView * bgimgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44+diffH, 320, self.view.frame.size.height+150)];
    [bgimgV setImage:[UIImage imageNamed:@"regBG.png"]];
    [self.view addSubview:bgimgV];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:diffH==0.0f?[UIImage imageNamed:@"back2.png"]:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    //   [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB.frame = CGRectMake(245, 5+diffH, 70, 34);
    [nextB setTitle:@"完成" forState:UIControlStateNormal];
    if (diffH==0) {
        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_normal"] forState:UIControlStateNormal];
        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_click"] forState:UIControlStateHighlighted];
    }

    [nextB addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"设置密码资料(3/3)"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIImageView * nameBG = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 80+diffH, 257.5, 41)];
    [nameBG setImage:[UIImage imageNamed:@"shurukuang_top"]];
    [self.view addSubview:nameBG];
    
    UIImageView * passWordIV = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 122+diffH, 257.5, 41)];
    [passWordIV setImage:[UIImage imageNamed:@"shurukuang_bottom"]];
    [self.view addSubview:passWordIV];
    
    UIImageView * a =  [[UIImageView alloc] initWithFrame:CGRectMake(31.75, 121+diffH, 256.5, 1)];
    a.image = [UIImage imageNamed:@"shurukuang_jiangexian"];
    [self.view addSubview:a];
    
    UIImageView * nickNameIV = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 190+diffH, 257.5, 41)];
    [nickNameIV setImage:[UIImage imageNamed:@"logininputbg.png"]];
    [self.view addSubview:nickNameIV];

    UIImageView * sexIV = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 260+diffH, 257.5, 41)];
    [sexIV setImage:[UIImage imageNamed:@"logininputbg.png"]];
    [self.view addSubview:sexIV];
    
    
    UIImageView * cityBG = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 330+diffH, 257.5, 41)];
    [cityBG setImage:[UIImage imageNamed:@"shurukuang_top"]];
    [self.view addSubview:cityBG];
    
    UIImageView * ageIV = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 372+diffH, 257.5, 41)];
    [ageIV setImage:[UIImage imageNamed:@"shurukuang_bottom"]];
    [self.view addSubview:ageIV];
    
    UIImageView * b =  [[UIImageView alloc] initWithFrame:CGRectMake(31.75, 371+diffH, 256.5, 1)];
    b.image = [UIImage imageNamed:@"shurukuang_jiangexian"];
    [self.view addSubview:b];
    
    UILabel* nameL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 20)];
    nameL.text = @"输入密码";
    nameL.font = [UIFont systemFontOfSize:13];
    nameL.backgroundColor = [UIColor clearColor];
    [nameBG addSubview:nameL];
    
    UILabel* passWordL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 20)];
    passWordL.text = @"重复密码";
    passWordL.font = [UIFont systemFontOfSize:13];
    passWordL.backgroundColor = [UIColor clearColor];
    [passWordIV addSubview:passWordL];
    
    UILabel* nickNameL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 20)];
    nickNameL.text = @"昵称";
    nickNameL.font = [UIFont systemFontOfSize:13];
    nickNameL.backgroundColor = [UIColor clearColor];
    [nickNameIV addSubview:nickNameL];
    
    UILabel* sexL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 20)];
    sexL.text = @"性别";
    sexL.font = [UIFont systemFontOfSize:13];
    sexL.backgroundColor = [UIColor clearColor];
    [sexIV addSubview:sexL];
    
    UILabel* cityL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 20)];
    cityL.text = @"城市";
    cityL.font = [UIFont systemFontOfSize:13];
    cityL.backgroundColor = [UIColor clearColor];
    [cityBG addSubview:cityL];
    
    UILabel* ageL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 20)];
    ageL.text = @"年龄";
    ageL.font = [UIFont systemFontOfSize:13];
    ageL.backgroundColor = [UIColor clearColor];
    [ageIV addSubview:ageL];
    
    self.nameTF = [[UITextField alloc]initWithFrame:CGRectMake(111.25, 85+diffH, 175, 30)];
    _nameTF.placeholder = @"不少于6位且不要过于简单";
    _nameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _nameTF.font = [UIFont systemFontOfSize:13];
    _nameTF.delegate = self;
    _nameTF.secureTextEntry = YES;
    [self.view addSubview:_nameTF];
    
    self.passWordTF = [[UITextField alloc]initWithFrame:CGRectMake(111.25, 125+diffH, 175, 30)];
    _passWordTF.placeholder = @"再次输入密码";
    _passWordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passWordTF.font = [UIFont systemFontOfSize:13];
    _passWordTF.delegate = self;
    _passWordTF.secureTextEntry = YES;
    [self.view addSubview:_passWordTF];
    
    self.nickNameTF = [[UITextField alloc]initWithFrame:CGRectMake(111.25, 195+diffH, 175, 30)];
    _nickNameTF.placeholder = @"使用真实姓名方便别人找到你";
    _nickNameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _nickNameTF.font = [UIFont systemFontOfSize:13];
    _nickNameTF.delegate = self;
    [self.view addSubview:_nickNameTF];
    
    manB = [UIButton buttonWithType:UIButtonTypeCustom];
    manB.frame = CGRectMake(111.25, 270+diffH, 21, 21);
    [manB setBackgroundImage:[UIImage imageNamed:@"singleSelectBtn-normal"] forState:UIControlStateNormal];
    [manB addTarget:self action:@selector(setSexIsMan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:manB];
    
    womanB = [UIButton buttonWithType:UIButtonTypeCustom];
    womanB.frame = CGRectMake(181.25, 270+diffH, 21, 21);
    [womanB setBackgroundImage:[UIImage imageNamed:@"singleSelectBtn-normal"] forState:UIControlStateNormal];
    [womanB addTarget:self action:@selector(setSexIsWoman) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:womanB];
    
    UILabel* manL = [[UILabel alloc]initWithFrame:CGRectMake(137.25, 270+diffH, 20, 20)];
    manL.text = @"男";
    manL.textColor = [UIColor grayColor];
    manL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:manL];
    
    UILabel* womanL = [[UILabel alloc]initWithFrame:CGRectMake(207.25, 270+diffH, 20, 20)];
    womanL.text = @"女";
    womanL.textColor = [UIColor grayColor];
    womanL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:womanL];
    
    self.cityTF = [[UITextField alloc]initWithFrame:CGRectMake(111.25, 340+diffH, 0, 0)];
    [self.view addSubview:_cityTF];
    _cityTF.delegate = self;
    self.cityPV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    _cityPV.dataSource = self;
    _cityPV.delegate = self;
    _cityPV.showsSelectionIndicator = YES;
    _cityTF.inputView = _cityPV;
    
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.tintColor = [UIColor blackColor];
    UIBarButtonItem*rb = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(didselectCity)];
    rb.tintColor = [UIColor blackColor];
    toolbar.items = @[rb];
    _cityTF.inputAccessoryView = toolbar;
    
    self.ageTF = [[UITextField alloc]initWithFrame:CGRectMake(111.25, 382+diffH, 0, 0)];
    [self.view addSubview:_ageTF];
    _ageTF.delegate = self;
    
    self.agePV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    _agePV.showsSelectionIndicator = YES; 
    _agePV.dataSource = self;
    _agePV.delegate = self;
    _ageTF.inputView = _agePV;
    [_agePV selectRow:19 inComponent:0 animated:NO];
    
    UIToolbar* aToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    aToolbar.tintColor = [UIColor blackColor];
    UIBarButtonItem*arb = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(didselectAge)];
    arb.tintColor = [UIColor blackColor];
    aToolbar.items = @[arb];
    _ageTF.inputAccessoryView = aToolbar;
    
    cityB = [UIButton buttonWithType:UIButtonTypeCustom];
    cityB.frame = CGRectMake(31.25, 330+diffH, 257.5, 40);
    [self.view addSubview:cityB];
    [cityB addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
    
    ageB = [UIButton buttonWithType:UIButtonTypeCustom];
    ageB.frame = CGRectMake(31.25, 372+diffH, 257.5, 40);
    [self.view addSubview:ageB];
    [ageB addTarget:self action:@selector(selectAge) forControlEvents:UIControlEventTouchUpInside];

    self.cityL = [[UILabel alloc]init];
    _cityL.frame = CGRectMake(111.25, 340+diffH, 175, 20);
    _cityL.backgroundColor = [UIColor clearColor];
    _cityL.textColor = [UIColor grayColor];
    [self.view addSubview:_cityL];
    
    self.ageL = [[UILabel alloc]init];
    _ageL.frame = CGRectMake(111.25, 382+diffH, 175, 20);
    _ageL.backgroundColor = [UIColor clearColor];
    _ageL.textColor = [UIColor grayColor];
    [self.view addSubview:_ageL];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"提交中...";
    
    [self analysisRegion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)backButton:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)next
{
    if (_nameTF.text.length<=0) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入密码" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (![IdentifyingString isValidatePassWord:_nameTF.text]) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的密码格式" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (![_passWordTF.text isEqualToString:_nameTF.text]) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请确保两次密码输入一致" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (_nickNameTF.text.length<=1||_nickNameTF.text.length>16) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"昵称需在2到16个字之间" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (self.sexS == nil) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择你的性别" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (_cityL.text.length<=0) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择您所在的城市" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (_ageL.text.length<=0) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择您的年龄" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:self.nickNameTF.text forKey:@"nickname"];
//    [params setObject:self.phoneNo forKey:@"username"];
    [params setObject:_passWordTF.text forKey:@"password"];
//    [params setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"createTime"];
    [params setObject:self.phoneNo forKey:@"phonenumber"];
//    [params setObject:@"" forKey:@"email"];
//    [params setObject:@"" forKey:@"deviceId"];
    [params setObject:self.sexS forKey:@"gender"];
    [params setObject:self.ageL.text forKey:@"birthdate"];
    [params setObject:self.cityL.text forKey:@"city"];
    [params setObject:@"" forKey:@"img"];
    [params setObject:@"该用户还未设置爱好" forKey:@"hobby"];
    [params setObject:@"该用户还未填写签名" forKey:@"signature"];
    NSString * deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:PushDeviceToken];
    [params setObject:deviceToken?deviceToken:@"" forKey:@"deviceToken"];
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"register" forKey:@"method"];
    [body setObject:@"service.uri.pet_sso" forKey:@"service"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
//        NSString * dede = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSRange range=[dede rangeOfString:@"token"];
//        if (range.location!=NSNotFound) {
            [self saveSelfUserInFo:responseObject];
            [SFHFKeychainUtils storeUsername:ACCOUNT andPassword:self.phoneNo forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
            [SFHFKeychainUtils storeUsername:PASSWORD andPassword:_passWordTF.text forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
            
            [DataStoreManager setDefaultDataBase:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] AndDefaultModel:@"LocalStore"];
            
            DedLoginViewController* newReg = [[DedLoginViewController alloc]init];
            newReg.dic = params;
            [self.navigationController pushViewController:newReg animated:YES];
//        }
//        else
//        {
//            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
//            [alert show];
//            [hud hide:YES];
//        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        [hud hide:YES];
    }];
}
-(void)saveSelfUserInFo:(NSDictionary*)dic 
{
    NSLog(@"%@",dic);
    [SFHFKeychainUtils storeUsername:LOCALTOKEN andPassword:[dic objectForKey:@"token"] forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
    [self upLoadUserLocationWithLat:[[TempData sharedInstance] returnLat] Lon:[[TempData sharedInstance] returnLon]];
}
-(void)upLoadUserLocationWithLat:(double)userLatitude Lon:(double)userLongitude
{
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    NSDictionary * locationDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",userLongitude],@"longitude",[NSString stringWithFormat:@"%f",userLatitude],@"latitude", nil];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"updateUserLocation" forKey:@"method"];
    [postDict setObject:@"service.uri.pet_user" forKey:@"service"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:locationDict forKey:@"params"];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)selectCity
{
    [_cityTF becomeFirstResponder];
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    CLLocation* location = [[CLLocation alloc]initWithLatitude:[[TempData sharedInstance] returnLat] longitude:[[TempData sharedInstance] returnLon]];
//    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarks,NSError *error)
//     {
//         if (placemarks.count >0   )
//         {
//             CLPlacemark * plmark = [placemarks objectAtIndex:0];
//             NSString* state = plmark.subAdministrativeArea;
//             for (int i = 0; i<self.ProvinceArray.count; i++) {
//                 if ([state isEqualToString:[self.ProvinceArray[i] objectForKey:@"Province"]]) {
//                     [_cityPV selectRow:i inComponent:0 animated:YES];
//                     break;
//                 }
//             }
//             
//         }
//     }];
}
-(void)analysisRegion
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation* location = [[CLLocation alloc]initWithLatitude:[[TempData sharedInstance] returnLat] longitude:[[TempData sharedInstance] returnLon]];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarks,NSError *error)
     {
         if (placemarks.count >0)
         {
             CLPlacemark * plmark = [placemarks objectAtIndex:0];
             NSString* state = plmark.administrativeArea;
             for (int i = 0; i<self.ProvinceArray.count; i++) {
                 if ([state isEqualToString:[self.ProvinceArray[i] objectForKey:@"Province"]]) {
                     [_cityPV selectRow:i inComponent:0 animated:YES];
                     self.cityArray = [self.ProvinceArray[i] objectForKey:@"city"];
                     [_cityPV reloadComponent:1];
                     break;
                 }
                 [_cityPV selectRow:self.ProvinceArray.count-1 inComponent:0 animated:YES];
                 self.cityArray = [self.ProvinceArray[self.ProvinceArray.count-1] objectForKey:@"city"];
                 [_cityPV reloadComponent:1];
             }

             
         }
         else
         {
             [_cityPV selectRow:self.ProvinceArray.count-1 inComponent:0 animated:YES];
             self.cityArray = [self.ProvinceArray[self.ProvinceArray.count-1] objectForKey:@"city"];
             [_cityPV reloadComponent:1];
         }
     }];
    
}

-(void)selectAge
{
    [_ageTF becomeFirstResponder];
}
-(void)setSexIsMan
{
    [manB setBackgroundImage:[UIImage imageNamed:@"singleSelectBtn-click"] forState:UIControlStateNormal];
    [womanB setBackgroundImage:[UIImage imageNamed:@"singleSelectBtn-normal"] forState:UIControlStateNormal];
    self.sexS = @"male";
    [self allTextFieldResignFirstResponder];
}
-(void)setSexIsWoman
{
    [womanB setBackgroundImage:[UIImage imageNamed:@"singleSelectBtn-click"] forState:UIControlStateNormal];
    [manB setBackgroundImage:[UIImage imageNamed:@"singleSelectBtn-normal"] forState:UIControlStateNormal];
    self.sexS = @"female";
    [self allTextFieldResignFirstResponder];
}
-(void)didselectCity
{
    self.cityL.text = [NSString stringWithFormat:@"%@ %@",[_ProvinceArray[[_cityPV selectedRowInComponent:0]] objectForKey:@"Province"],_cityArray[[_cityPV selectedRowInComponent:1]]];
    [_cityTF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    }];
}
-(void)didselectAge
{
    self.ageL.text = _ageArray[[_agePV selectedRowInComponent:0]];
    [_ageTF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    }];
}
#pragma mark - touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self allTextFieldResignFirstResponder];
}
-(void)allTextFieldResignFirstResponder
{
    [_ageTF resignFirstResponder];
    [_cityTF resignFirstResponder];
    [_nameTF resignFirstResponder];
    [_passWordTF resignFirstResponder];
    [_nickNameTF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    }];
}
#pragma mark - UIPicker View delegate and data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == _cityPV) {
        return 2;
    }
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _cityPV) {
        if (component == 0) {
            return self.ProvinceArray.count;
        }
        return self.cityArray.count;
    }
    return self.ageArray.count;
}
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger) row forComponent:(NSInteger) component
{
    if (pickerView == _cityPV) {
        if (component == 0) {
            return [self.ProvinceArray[row] objectForKey:@"Province"];
        }
        return self.cityArray[row];
    }
    return self.ageArray[row];
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == _cityPV) {
        if (component == 0) {
            self.cityArray = [self.ProvinceArray[row] objectForKey:@"city"];
            [_cityPV reloadComponent:1];
        }
    }
}
#pragma mark - UITextField dele
- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if (iPhone5) {
        if (textField == _nickNameTF) {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = CGRectMake(0, -60, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
        if (textField == _cityTF) {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = CGRectMake(0, -140, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
        if (textField == _ageTF) {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = CGRectMake(0, -140, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
    }else{
        if (textField == _nickNameTF) {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = CGRectMake(0, -160, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
        if (textField == _cityTF) {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = CGRectMake(0, -200, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
        if (textField == _ageTF) {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = CGRectMake(0, -200, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
    }
}
@end
