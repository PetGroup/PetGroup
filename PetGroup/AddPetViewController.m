//
//  AddPetViewController.m
//  NewXMPPTest
//
//  Created by 阿铛 on 13-8-20.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "AddPetViewController.h"
#import "XMLMatcher.h"

@interface AddPetViewController ()
{
    UIButton * manB;
    UIButton * womanB;
    UIButton * typeB;
    UIButton * ageB;
}
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
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    [nextB setTitle:@"下一步" forState:UIControlStateNormal];
    [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_normal"] forState:UIControlStateNormal];
    [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_click"] forState:UIControlStateHighlighted];
    [nextB addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    UILabel *  titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 2, 220, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setText:@"填写宠物信息"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UILabel* tishiL = [[UILabel alloc]initWithFrame:CGRectMake(100, 70, 120, 20)];
    tishiL.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    tishiL.backgroundColor = [UIColor clearColor];
    tishiL.textColor = [UIColor whiteColor];
    tishiL.text = @"填写宠物资料";
    [self.view addSubview:tishiL];
    
    UIImageView* petIV = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 120, 120)];
    [self.view addSubview:petIV];
    switch (self.petType) {
        case 1:{
            petIV.image = [UIImage imageNamed:@"xuanzegou"];
            self.typeArray = [XMLMatcher allDogs];
        }break;
        case 2:{
            petIV.image = [UIImage imageNamed:@"xuanzemao"];
            self.typeArray = [XMLMatcher allCats];
        }break;
        case 3:{
            petIV.image = [UIImage imageNamed:@"xuanzeqita"];
            self.typeArray = [XMLMatcher allother];
        }break;
        default:
            break;
    }
    UIImageView * typeBG = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 290, 257.5, 41)];
    [typeBG setImage:[UIImage imageNamed:@"shurukuang_top"]];
    [self.view addSubview:typeBG];
    
    UIImageView * ageIV = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 332, 257.5, 41)];
    [ageIV setImage:[UIImage imageNamed:@"shurukuang_bottom"]];
    [self.view addSubview:ageIV];
    
    UIImageView * a =  [[UIImageView alloc] initWithFrame:CGRectMake(31.75, 331, 256.5, 1)];
    a.image = [UIImage imageNamed:@"shurukuang_jiangexian"];
    [self.view addSubview:a];
    
    UIImageView * sexIV = [[UIImageView alloc] initWithFrame:CGRectMake(31.25, 240, 257.5, 41)];
    [sexIV setImage:[UIImage imageNamed:@"logininputbg.png"]];
    [self.view addSubview:sexIV];
    
    UILabel* typeL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 40, 20)];
    typeL.text = @"品种";
    typeL.font = [UIFont systemFontOfSize:13];
    typeL.backgroundColor = [UIColor clearColor];
    [typeBG addSubview:typeL];
    
    UILabel* ageL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 40, 20)];
    ageL.text = @"年龄";
    ageL.font = [UIFont systemFontOfSize:13];
    ageL.backgroundColor = [UIColor clearColor];
    [ageIV addSubview:ageL];
    
    UILabel* sexL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 40, 20)];
    sexL.text = @"性别";
    sexL.font = [UIFont systemFontOfSize:13];
    sexL.backgroundColor = [UIColor clearColor];
    [sexIV addSubview:sexL];
    
    manB = [UIButton buttonWithType:UIButtonTypeCustom];
    manB.frame = CGRectMake(111.25, 250, 21, 21);
    [manB setBackgroundImage:[UIImage imageNamed:@"singleSelectBtn-normal"] forState:UIControlStateNormal];
    [manB addTarget:self action:@selector(setSexIsMan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:manB];
    
    womanB = [UIButton buttonWithType:UIButtonTypeCustom];
    womanB.frame = CGRectMake(181.25, 250, 21, 21);
    [womanB setBackgroundImage:[UIImage imageNamed:@"singleSelectBtn-normal"] forState:UIControlStateNormal];
    [womanB addTarget:self action:@selector(setSexIsWoman) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:womanB];
    
    UILabel* manL = [[UILabel alloc]initWithFrame:CGRectMake(137.25, 250, 20, 20)];
    manL.text = @"男";
    manL.textColor = [UIColor grayColor];
    manL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:manL];
    
    UILabel* womanL = [[UILabel alloc]initWithFrame:CGRectMake(207.25, 250, 20, 20)];
    womanL.text = @"女";
    womanL.textColor = [UIColor grayColor];
    womanL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:womanL];
    
    self.typeTF = [[UITextField alloc]initWithFrame:CGRectMake(111.25, 340, 0, 0)];
    [self.view addSubview:_typeTF];
    
    self.typePV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
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
    
    typeB = [UIButton buttonWithType:UIButtonTypeCustom];
    typeB.frame = CGRectMake(31.25, 290, 257.5, 40);
    [self.view addSubview:typeB];
    [typeB addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
    
    ageB = [UIButton buttonWithType:UIButtonTypeCustom];
    ageB.frame = CGRectMake(31.25, 332, 257.5, 40);
    [self.view addSubview:ageB];
    [ageB addTarget:self action:@selector(selectAge) forControlEvents:UIControlEventTouchUpInside];
    
    self.typeL = [[UILabel alloc]init];
    _typeL.frame = CGRectMake(111.25, 300, 175, 20);
    _typeL.backgroundColor = [UIColor clearColor];
    _typeL.textColor = [UIColor grayColor];
    [self.view addSubview:_typeL];
    
    self.ageL = [[UILabel alloc]init];
    _ageL.frame = CGRectMake(111.25, 342, 175, 20);
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
    UpLoadPhotoViewController* upLoadVC = [[UpLoadPhotoViewController alloc]init];
    upLoadVC.petType = self.petType;
    [self.navigationController pushViewController:upLoadVC animated:YES];
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
    self.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
}
@end
