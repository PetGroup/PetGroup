//
//  NewRegistThreeViewController.m
//  NewXMPPTest
//
//  Created by 阿铛 on 13-8-19.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "NewRegistThreeViewController.h"
#import "DedLoginViewController.h"

@interface NewRegistThreeViewController ()
{
    UIButton * manB;
    UIButton * womanB;
    UIButton * cityB;
    UIButton* ageB;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden =YES;
    
    UIImageView * bgimgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
    [bgimgV setImage:[UIImage imageNamed:@"regBG.png"]];
    [self.view addSubview:bgimgV];
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    //   [backButton setTitle:@" 返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB.frame = CGRectMake(245, 5, 70, 34);
    [nextB setTitle:@"完成" forState:UIControlStateNormal];
    [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_normal"] forState:UIControlStateNormal];
    [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_click"] forState:UIControlStateHighlighted];
    [nextB addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"设置密码资料(3/3)"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIImageView * nameBG = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 80, 257.5, 41)];
    [nameBG setImage:[UIImage imageNamed:@"shurukuang_top"]];
    [self.view addSubview:nameBG];
    
    UIImageView * passWordIV = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 122, 257.5, 41)];
    [passWordIV setImage:[UIImage imageNamed:@"shurukuang_bottom"]];
    [self.view addSubview:passWordIV];
    
    UIImageView * a =  [[UIImageView alloc] initWithFrame:CGRectMake(31.75, 121, 256.5, 1)];
    a.image = [UIImage imageNamed:@"shurukuang_jiangexian"];
    [self.view addSubview:a];
    
    UIImageView * nickNameIV = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 190, 257.5, 41)];
    [nickNameIV setImage:[UIImage imageNamed:@"logininputbg.png"]];
    [self.view addSubview:nickNameIV];

    UIImageView * sexIV = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 260, 257.5, 41)];
    [sexIV setImage:[UIImage imageNamed:@"logininputbg.png"]];
    [self.view addSubview:sexIV];
    
    
    UIImageView * cityBG = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 330, 257.5, 41)];
    [cityBG setImage:[UIImage imageNamed:@"shurukuang_top"]];
    [self.view addSubview:cityBG];
    
    UIImageView * ageIV = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 372, 257.5, 41)];
    [ageIV setImage:[UIImage imageNamed:@"shurukuang_bottom"]];
    [self.view addSubview:ageIV];
    
    UIImageView * b =  [[UIImageView alloc] initWithFrame:CGRectMake(31.75, 371, 256.5, 1)];
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
    
    self.nameTF = [[UITextField alloc]initWithFrame:CGRectMake(111.25, 90, 175, 20)];
    _nameTF.placeholder = @"不少于6位且不要过于简单";
    _nameTF.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_nameTF];
    
    self.passWordTF = [[UITextField alloc]initWithFrame:CGRectMake(111.25, 130, 175, 20)];
    _passWordTF.placeholder = @"再次输入密码";
    _passWordTF.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_passWordTF];
    
    self.nickNameTF = [[UITextField alloc]initWithFrame:CGRectMake(111.25, 200, 175, 20)];
    _nickNameTF.placeholder = @"使用真实姓名方便别人找到你";
    _nickNameTF.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_nickNameTF];
    
    manB = [UIButton buttonWithType:UIButtonTypeCustom];
    manB.frame = CGRectMake(111.25, 270, 21, 21);
    [manB setBackgroundImage:[UIImage imageNamed:@"singleSelectBtn-normal"] forState:UIControlStateNormal];
    [manB addTarget:self action:@selector(setSexIsMan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:manB];
    
    womanB = [UIButton buttonWithType:UIButtonTypeCustom];
    womanB.frame = CGRectMake(181.25, 270, 21, 21);
    [womanB setBackgroundImage:[UIImage imageNamed:@"singleSelectBtn-normal"] forState:UIControlStateNormal];
    [womanB addTarget:self action:@selector(setSexIsWoman) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:womanB];
    
    UILabel* manL = [[UILabel alloc]initWithFrame:CGRectMake(137.25, 270, 20, 20)];
    manL.text = @"男";
    manL.textColor = [UIColor grayColor];
    manL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:manL];
    
    UILabel* womanL = [[UILabel alloc]initWithFrame:CGRectMake(207.25, 270, 20, 20)];
    womanL.text = @"女";
    womanL.textColor = [UIColor grayColor];
    womanL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:womanL];
    
    self.cityTF = [[UITextField alloc]initWithFrame:CGRectMake(111.25, 340, 0, 0)];
    [self.view addSubview:_cityTF];
    
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
    
    self.ageTF = [[UITextField alloc]initWithFrame:CGRectMake(111.25, 382, 0, 0)];
    [self.view addSubview:_ageTF];
    
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
    
    cityB = [UIButton buttonWithType:UIButtonTypeCustom];
    cityB.frame = CGRectMake(31.25, 330, 257.5, 40);
    [self.view addSubview:cityB];
    [cityB addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
    
    ageB = [UIButton buttonWithType:UIButtonTypeCustom];
    ageB.frame = CGRectMake(31.25, 372, 257.5, 40);
    [self.view addSubview:ageB];
    [ageB addTarget:self action:@selector(selectAge) forControlEvents:UIControlEventTouchUpInside];

    self.cityL = [[UILabel alloc]init];
    _cityL.frame = CGRectMake(111.25, 340, 175, 20);
    _cityL.backgroundColor = [UIColor clearColor];
    _cityL.textColor = [UIColor grayColor];
    [self.view addSubview:_cityL];
    
    self.ageL = [[UILabel alloc]init];
    _ageL.frame = CGRectMake(111.25, 382, 175, 20);
    _ageL.backgroundColor = [UIColor clearColor];
    _ageL.textColor = [UIColor grayColor];
    [self.view addSubview:_ageL];
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
    //    if ([self validateMobile:self.phoneTF.text]) {
    //        if (self.request != nil) {
    //            [_request cancelRequest];
    //        }
    //        _request  = [[PetRequest alloc]init];
    //
    //        return;
    //    }
    //    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号" delegate:self cancelButtonTitle:@"了解" otherButtonTitles: nil];
    //    [alert show];
    
    //text
    DedLoginViewController* newReg = [[DedLoginViewController alloc]init];
    [self.navigationController pushViewController:newReg animated:YES];
}
-(void)selectCity
{
    [_cityTF becomeFirstResponder];
}
-(void)selectAge
{
    [_ageTF becomeFirstResponder];
}
-(void)setSexIsMan
{
    [manB setBackgroundImage:[UIImage imageNamed:@"singleSelectBtn-click"] forState:UIControlStateNormal];
    [womanB setBackgroundImage:[UIImage imageNamed:@"singleSelectBtn-normal"] forState:UIControlStateNormal];
    self.sexS = @"男";
}
-(void)setSexIsWoman
{
    [womanB setBackgroundImage:[UIImage imageNamed:@"singleSelectBtn-click"] forState:UIControlStateNormal];
    [manB setBackgroundImage:[UIImage imageNamed:@"singleSelectBtn-normal"] forState:UIControlStateNormal];
    self.sexS = @"女";
}
-(void)didselectCity
{
    self.cityL.text = [NSString stringWithFormat:@"%@\t\t%@",[_ProvinceArray[[_cityPV selectedRowInComponent:0]] objectForKey:@"Province"],_cityArray[[_cityPV selectedRowInComponent:1]]];
    [_cityTF resignFirstResponder];
}
-(void)didselectAge
{
    self.ageL.text = _ageArray[[_agePV selectedRowInComponent:0]];
    [_ageTF resignFirstResponder];
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
    self.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
}
#pragma mark - PetRequest callback

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
@end
