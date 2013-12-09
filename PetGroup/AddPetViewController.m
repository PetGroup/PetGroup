//
//  AddPetViewController.m
//  NewXMPPTest
//
//  Created by 阿铛 on 13-8-20.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "AddPetViewController.h"
#import "XMLMatcher.h"
#import "MBProgressHUD.h"
#import "DataStoreManager.h"
@interface AddPetViewController ()
{
    UIButton * manB;
    UIButton * womanB;
    UIButton * typeB;
    UIButton * ageB;
    MBProgressHUD *hud;
}
@property (nonatomic,strong) NSString* trait;
@property (nonatomic ,strong) NSMutableArray* ageArray;
@property (nonatomic ,strong) NSArray* typeArray;
@property (nonatomic,strong)UIPickerView* typePV;
@property (nonatomic,strong)UIPickerView* agePV;
@property (nonatomic,strong)UILabel* typeL;
@property (nonatomic,strong)UILabel* ageL;
@property (nonatomic,strong)UITextField* typeTF;
@property (nonatomic,strong)UITextField* ageTF;
@property (nonatomic,strong)NSString* sexS;
@end

@implementation AddPetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.ageArray = [[NSMutableArray alloc]init];
        for (int i = 1; i <= 100; i++) {
            [_ageArray addObject:[NSString stringWithFormat:@"%d",i]];
            self.sexS = nil;
        }
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
    
    float diffH = [Common diffHeight:self];
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:diffH==0?@"topBar1.png":@"topBar2.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44+diffH)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0+diffH, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"backnew.png"] forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    

    UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB.frame = CGRectMake(245, 5+diffH, 70, 34);
    [nextB setTitle:@"下一步" forState:UIControlStateNormal];
//    if (diffH==0) {
//        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_normal"] forState:UIControlStateNormal];
//        [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_click"] forState:UIControlStateHighlighted];
//    }
   
    [nextB addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2+diffH, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"填写宠物信息"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UILabel* tishiL = [[UILabel alloc]initWithFrame:CGRectMake(0, 70+diffH, 320, 20)];
    tishiL.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    tishiL.textAlignment = NSTextAlignmentCenter;
    tishiL.backgroundColor = [UIColor clearColor];
    tishiL.textColor = [UIColor blackColor];
    tishiL.text = @"填写宠物资料";
    [self.view addSubview:tishiL];
    
    UIImageView* petIV = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100+diffH, 120, 120)];
    [self.view addSubview:petIV];
    switch (self.petType) {
        case 1:{
            self.trait = @"一只平凡的狗";
            petIV.image = [UIImage imageNamed:@"xuanzegou"];
            self.typeArray = [XMLMatcher allDogs];
        }break;
        case 2:{
            self.trait = @"一只平凡的猫";
            petIV.image = [UIImage imageNamed:@"xuanzemao"];
            self.typeArray = [XMLMatcher allCats];
        }break;
        case 3:{
            self.trait = @"一只平凡的宠物";
            petIV.image = [UIImage imageNamed:@"xuanzeqita"];
            self.typeArray = [XMLMatcher allother];
        }break;
        default:
            break;
    }
    UIImageView * typeBG = [[UIImageView alloc] initWithFrame:CGRectMake(10, 250+diffH, 300, 123)];
    [typeBG setImage:[UIImage imageNamed:@"newlogbg3"]];
    [self.view addSubview:typeBG];
    
    UILabel* typeL = [[UILabel alloc]initWithFrame:CGRectMake(41.25, 300 + diffH, 40, 20)];
    typeL.text = @"品种";
    typeL.font = [UIFont systemFontOfSize:16];
    typeL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:typeL];
    
    UILabel* ageL = [[UILabel alloc]initWithFrame:CGRectMake(41.25, 342 + diffH, 40, 20)];
    ageL.text = @"年龄";
    ageL.font = [UIFont systemFontOfSize:16];
    ageL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:ageL];
    
    UILabel* sexL = [[UILabel alloc]initWithFrame:CGRectMake(41.25, 260 + diffH, 40, 20)];
    sexL.text = @"性别";
    sexL.font = [UIFont systemFontOfSize:16];
    sexL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sexL];
    
    manB = [UIButton buttonWithType:UIButtonTypeCustom];
    manB.frame = CGRectMake(111.25, 260+diffH, 21, 21);
    [manB setBackgroundImage:[UIImage imageNamed:@"singleSelectBtn-normal"] forState:UIControlStateNormal];
    [manB addTarget:self action:@selector(setSexIsMan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:manB];
    
    womanB = [UIButton buttonWithType:UIButtonTypeCustom];
    womanB.frame = CGRectMake(181.25, 260+diffH, 21, 21);
    [womanB setBackgroundImage:[UIImage imageNamed:@"singleSelectBtn-normal"] forState:UIControlStateNormal];
    [womanB addTarget:self action:@selector(setSexIsWoman) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:womanB];
    
    UILabel* manL = [[UILabel alloc]initWithFrame:CGRectMake(137.25, 260+diffH, 20, 20)];
    manL.text = @"公";
    manL.textColor = [UIColor grayColor];
    manL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:manL];
    
    UILabel* womanL = [[UILabel alloc]initWithFrame:CGRectMake(207.25, 260+diffH, 20, 20)];
    womanL.text = @"母";
    womanL.textColor = [UIColor grayColor];
    womanL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:womanL];
    
    self.typeTF = [[UITextField alloc]initWithFrame:CGRectMake(111.25, 340+diffH, 0, 0)];
    [self.view addSubview:_typeTF];
    [self.typeTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.typePV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0+diffH, 320, 200)];
    _typePV.dataSource = self;
    _typePV.delegate = self;
    _typePV.showsSelectionIndicator = YES;
    _typeTF.inputView = _typePV;
    
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.tintColor = [UIColor blackColor];
    UIBarButtonItem*rb = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(didselectCity)];
    rb.tintColor = [UIColor blackColor];
    toolbar.items = @[rb];
    _typeTF.inputAccessoryView = toolbar;
    
    self.ageTF = [[UITextField alloc]initWithFrame:CGRectMake(111.25, 382+diffH, 0, 0)];
    [self.view addSubview:_ageTF];
    [self.ageTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.agePV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    _agePV.showsSelectionIndicator = YES;
    _agePV.dataSource = self;
    _agePV.delegate = self;
    _ageTF.inputView = _agePV;
    
    UIToolbar* aToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    aToolbar.tintColor = [UIColor blackColor];
    UIBarButtonItem*arb = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(didselectAge)];
    arb.tintColor = [UIColor blackColor];
    aToolbar.items = @[arb];
    _ageTF.inputAccessoryView = aToolbar;
    
    typeB = [UIButton buttonWithType:UIButtonTypeCustom];
    typeB.frame = CGRectMake(31.25, 290+diffH, 257.5, 40);
    [self.view addSubview:typeB];
    [typeB addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
    
    ageB = [UIButton buttonWithType:UIButtonTypeCustom];
    ageB.frame = CGRectMake(31.25, 332+diffH, 257.5, 40);
    [self.view addSubview:ageB];
    [ageB addTarget:self action:@selector(selectAge) forControlEvents:UIControlEventTouchUpInside];
    
    self.typeL = [[UILabel alloc]init];
    _typeL.frame = CGRectMake(111.25, 300+diffH, 175, 20);
    _typeL.backgroundColor = [UIColor clearColor];
    _typeL.textColor = [UIColor grayColor];
    [self.view addSubview:_typeL];
    
    self.ageL = [[UILabel alloc]init];
    _ageL.frame = CGRectMake(111.25, 342+diffH, 175, 20);
    _ageL.backgroundColor = [UIColor clearColor];
    _ageL.textColor = [UIColor grayColor];
    [self.view addSubview:_ageL];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"提交中...";
}

- (void) textFieldDidChange:(UITextField *) textField
{
    NSLog(@"%@",textField.text);
    if (textField.text.length>2&&[[Emoji allEmoji] containsObject:[textField.text substringFromIndex:textField.text.length-2]]) {
        textField.text = [textField.text substringToIndex:textField.text.length-2];
    }
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
    if (self.sexS == nil) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择宠物的性别" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (self.typeL.text.length<=0) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择宠物的品种" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (self.ageL.text.length<=0) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择宠物的年龄" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:_typeL.text forKey:@"nickname"];
    [params setObject:[self fendTypeCodeWithString] forKey:@"type"];
    [params setObject:@""forKey:@"img"];
    [params setObject:self.trait forKey:@"trait"];
    [params setObject:self.sexS forKey:@"gender"];
    [params setObject:self.ageL.text forKey:@"birthdate"];
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"savePetinfo" forKey:@"method"];
    [body setObject:@"service.uri.pet_user" forKey:@"service"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic);
        UpLoadPhotoViewController* upLoadVC = [[UpLoadPhotoViewController alloc]init];
        upLoadVC.petType = self.petType;
        upLoadVC.hostDic = self.hostDic;
        [params setObject:responseObject forKey:@"id"];
        upLoadVC.petDic = params;
        [self.navigationController pushViewController:upLoadVC animated:YES];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
    }];

}
-(void)savePetInFo:(NSDictionary*)dic
{
    NSLog(@"%@",dic);
//    [DataStoreManager storeOnePetInfo:dic];
}
-(NSNumber*)fendTypeCodeWithString
{
    switch (self.petType) {
        case 1:{
            return [XMLMatcher typeWithString1:@"Dog" andString2:_typeL.text];
        }break;
        case 2:{
            return [XMLMatcher typeWithString1:@"Cat" andString2:_typeL.text];
        }break;
        case 3:{
            return [XMLMatcher typeWithString1:@"Other" andString2:_typeL.text];
        }break;
        default:
            return 0;
            break;
    }
}
-(void)setSexIsMan
{
    [manB setBackgroundImage:[UIImage imageNamed:@"singleSelectBtn-click"] forState:UIControlStateNormal];
    [womanB setBackgroundImage:[UIImage imageNamed:@"singleSelectBtn-normal"] forState:UIControlStateNormal];
    self.sexS = @"male";
}
-(void)setSexIsWoman
{
    [womanB setBackgroundImage:[UIImage imageNamed:@"singleSelectBtn-click"] forState:UIControlStateNormal];
    [manB setBackgroundImage:[UIImage imageNamed:@"singleSelectBtn-normal"] forState:UIControlStateNormal];
    self.sexS = @"female";
}
-(void)selectCity
{
    [_typeTF becomeFirstResponder];
}
-(void)selectAge
{
    [_ageTF becomeFirstResponder];
}
-(void)didselectCity
{
    self.typeL.text = _typeArray[[_typePV selectedRowInComponent:0]];
    [_typeTF resignFirstResponder];
}
-(void)didselectAge
{
    self.ageL.text = _ageArray[[_agePV selectedRowInComponent:0]];
    [_ageTF resignFirstResponder];
}
#pragma mark - UIPicker View delegate and data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _typePV) {
        
        return self.typeArray.count;
    }
    return self.ageArray.count;
    
}
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger) row forComponent:(NSInteger) component
{
    if (pickerView == _typePV) {
        return self.typeArray[row];
    }
    return self.ageArray[row];
    
}
#pragma mark - touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self allTextFieldResignFirstResponder];
}
-(void)allTextFieldResignFirstResponder
{
    [_ageTF resignFirstResponder];
    [_typeTF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    }];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if (iPhone5) {
        if (textField == _typeTF) {
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
        if (textField == _typeTF) {
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
