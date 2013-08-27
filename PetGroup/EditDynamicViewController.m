//
//  EditDynamicViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-8-23.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "EditDynamicViewController.h"
#import "CustomTabBar.h"

@interface EditDynamicViewController ()
{
    UIButton* PhotoB;
    UIImageView* deleteIV;
}
@property (nonatomic,strong)UITextView* dynamicTV;
@property (nonatomic,strong)UILabel* placeholderL;
@property (nonatomic,strong)UILabel* tishiL;
@property (nonatomic,strong)UIImageView* pictureV;
@property (nonatomic,strong)NSMutableArray* pictureArray;
@property (nonatomic,strong)UIActionSheet* addActionSheet;
@property (nonatomic,strong)UIActionSheet* deleteActionSheet;

@end

@implementation EditDynamicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView * bgimgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
    [bgimgV setImage:[UIImage imageNamed:@"chat_bg"]];
    [self.view addSubview:bgimgV];
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
    [titleLabel setText:@"编辑动态"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB.frame = CGRectMake(245, 5, 70, 34);
    [nextB setTitle:@"完成" forState:UIControlStateNormal];
    [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_normal"] forState:UIControlStateNormal];
    [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_click"] forState:UIControlStateHighlighted];
    [nextB addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    
    UIImageView* dabeijingIV = [[UIImageView alloc]initWithFrame:CGRectMake(6, 50, 308, 168)];
    dabeijingIV.image = [UIImage imageNamed:@"dabeijing"];
    [self.view addSubview:dabeijingIV];
    UIImageView* editIV = [[UIImageView alloc]initWithFrame:CGRectMake(13.75, 57.75, 292.5, 128)];
    editIV.image = [UIImage imageNamed:@"edit_bg"];
    [self.view addSubview:editIV];
    
    self.dynamicTV = [[UITextView alloc]initWithFrame:CGRectMake(13.75, 57.75, 220, 128)];
    _dynamicTV.backgroundColor = [UIColor clearColor];
    _dynamicTV.delegate = self;
    [self.view addSubview:_dynamicTV];
    
    UIButton* addPhotoB = [UIButton buttonWithType:UIButtonTypeCustom];
    addPhotoB.frame = CGRectMake(238.75, 62.5, 62.5, 62.5);
    [addPhotoB setBackgroundImage:[UIImage imageNamed:@"zhaoxiangji"] forState:UIControlStateNormal];
    [addPhotoB addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addPhotoB];
    
    self.placeholderL = [[UILabel alloc]initWithFrame:CGRectMake(23, 57.75, 200, 20)];
    _placeholderL.backgroundColor = [UIColor clearColor];
    _placeholderL.textColor = [UIColor grayColor];
    _placeholderL.text = @"今天想跟别人说点什么……";
    [self.view addSubview:_placeholderL];
    
    self.tishiL = [[UILabel alloc]initWithFrame:CGRectMake(200, 190, 115, 20)];
    _tishiL.text = @"还可以输入200字";
    _tishiL.backgroundColor = [UIColor clearColor];
    _tishiL.font = [UIFont boldSystemFontOfSize:14];
    _tishiL.textColor = [UIColor grayColor];
    [self.view addSubview:_tishiL];
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
    [self.customTabBarController hidesTabBar:NO animated:YES];
}
-(void)next
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.customTabBarController hidesTabBar:NO animated:YES];
}
-(void)addPhoto
{
    if (self.pictureV == nil) {
        self.pictureV = [[UIImageView alloc]initWithFrame:CGRectMake(6, 228, 308, 62.5)];
        _pictureV.image = [UIImage imageNamed:@"xiaobeijing"];
        _pictureV.userInteractionEnabled = YES;
        _pictureV.autoresizesSubviews = YES;
        _pictureV.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:_pictureV];
        
        PhotoB = [UIButton buttonWithType:UIButtonTypeCustom];
        PhotoB.frame = CGRectMake(7, 7, 48.5, 48.5);
        [PhotoB setBackgroundImage:[UIImage imageNamed:@"tianjiazhaopian"] forState:UIControlStateNormal];
        [PhotoB addTarget:self action:@selector(getAnActionSheet) forControlEvents:UIControlEventTouchUpInside];
        [_pictureV addSubview:PhotoB];

    }
}
-(void)getAnActionSheet
{
    self.addActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [_addActionSheet showInView:self.view];
}
-(void)tapImage:(UIGestureRecognizer*)tapGR
{
    deleteIV = (UIImageView*)tapGR.view;
    self.deleteActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
    [_deleteActionSheet showInView:self.view];
}
#pragma mark - text view delegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0) {
        _placeholderL.text = @"";
    }else{
        _placeholderL.text = @"今天想跟别人说点什么……";
    }
    _tishiL.text = [NSString stringWithFormat:@"还可以输入%d字",200-textView.text.length];
    
}
#pragma mark - touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_dynamicTV resignFirstResponder];
}
#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == _addActionSheet) {
        switch (buttonIndex) {
            case 0:
            {
                UIImagePickerController * imagePicker;
                if (imagePicker==nil) {
                    imagePicker=[[UIImagePickerController alloc]init];
                    imagePicker.delegate=self;
                }
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                    [self presentModalViewController:imagePicker animated:YES];
                }
                else {
                    UIAlertView *cameraAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备不支持相机" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
                    [cameraAlert show];
                }
            }break;
            case 1:
            {
                UIImagePickerController * imagePicker;
                if (imagePicker==nil) {
                    imagePicker=[[UIImagePickerController alloc]init];
                    imagePicker.delegate=self;
                }
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                    [self presentModalViewController:imagePicker animated:YES];
                }
                else {
                    UIAlertView *libraryAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备不支持相册" delegate:self cancelButtonTitle:@"了解" otherButtonTitles:nil];
                    [libraryAlert show];
                }
                
            }break;
            default:
                break;
        }
    }else{
        if (buttonIndex == 0) {
            NSUInteger index = [_pictureArray indexOfObject:deleteIV];
            [UIView animateWithDuration:0.3 animations:^{
                PhotoB.frame = ((UIImageView*)[_pictureArray lastObject]).frame;
                for (int i = _pictureArray.count-1; i > index ; i-- ) {
                    ((UIImageView*)_pictureArray[i]).frame = ((UIImageView*)_pictureArray[i-1]).frame;
                }
            }];
            [deleteIV removeFromSuperview];
            [_pictureArray removeObject:deleteIV];
            PhotoB.hidden = NO;
            if (_pictureArray.count < 5) {
                 _pictureV.frame = CGRectMake(_pictureV.frame.origin.x, _pictureV.frame.origin.y, _pictureV.frame.size.width, 60.5);
            }
        }
    }
    
}
#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (self.pictureArray == nil) {
        self.pictureArray = [[NSMutableArray alloc]init];
    }
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage*selectImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageView* imageV = [[UIImageView alloc]initWithFrame:PhotoB.frame];
    imageV.userInteractionEnabled = YES;
    imageV.image = selectImage;
    [_pictureV addSubview:imageV];
    if (PhotoB.frame.origin.x < 250) {
        PhotoB.frame = CGRectMake(PhotoB.frame.origin.x+ PhotoB.frame.size.width +12.875, PhotoB.frame.origin.y, PhotoB.frame.size.width, PhotoB.frame.size.height);
    }else{
        _pictureV.frame = CGRectMake(_pictureV.frame.origin.x, _pictureV.frame.origin.y, _pictureV.frame.size.width, 121);
        PhotoB.frame = CGRectMake(7, 62.5, PhotoB.frame.size.width, PhotoB.frame.size.height);
    }
    if (PhotoB.frame.origin.x > 250 && PhotoB.frame.origin.y > 60) {
        PhotoB.hidden = YES;
    }
    
    [_pictureArray addObject:imageV];
    
    UITapGestureRecognizer*tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    [imageV addGestureRecognizer:tapGR];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}
@end
