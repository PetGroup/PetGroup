//
//  EditDynamicViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-8-23.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "EditDynamicViewController.h"
#import "MBProgressHUD.h"
#import "TempData.h"
@interface EditDynamicViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate>
{
    UIButton* PhotoB;
    UIImageView* deleteIV;
    MBProgressHUD * hud;
}
@property (nonatomic,strong)UITextView* dynamicTV;
@property (nonatomic,strong)UILabel* placeholderL;
@property (nonatomic,strong)NSMutableArray* pictureArray;
@property (nonatomic,strong)UIActionSheet* addActionSheet;
@property (nonatomic,strong)UIActionSheet* deleteActionSheet;
@property (nonatomic,strong)NSMutableString* imageId;
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
    [titleLabel setText:@"新动态"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
    nextB.frame = CGRectMake(245, 5, 70, 34);
    [nextB setTitle:@"完成" forState:UIControlStateNormal];
    [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_normal"] forState:UIControlStateNormal];
    [nextB setBackgroundImage:[UIImage imageNamed:@"youshangjiao_click"] forState:UIControlStateHighlighted];
    [nextB addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextB];
    
    UIImageView* editIV = [[UIImageView alloc]initWithFrame:CGRectMake(13.75, 55.75, 292.5, 128)];
    editIV.image = [UIImage imageNamed:@"shurukuang"] ;
    [self.view addSubview:editIV];
    
    self.dynamicTV = [[UITextView alloc]initWithFrame:CGRectMake(13.75, 55.75, 292.5,128)];
    _dynamicTV.backgroundColor = [UIColor clearColor];
    _dynamicTV.font = [UIFont systemFontOfSize:17];
    _dynamicTV.delegate = self;
    [self.view addSubview:_dynamicTV];
    
    UIImageView* tool = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    tool.image = [UIImage imageNamed:@"table_bg"];
    tool.userInteractionEnabled = YES;
    _dynamicTV.inputAccessoryView = tool;
    
    UIButton* imageB = [UIButton buttonWithType:UIButtonTypeCustom];
    imageB.frame = CGRectMake(270, 2, 40, 40);
    [imageB addTarget:self action:@selector(getAnActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [imageB setBackgroundImage:[UIImage imageNamed:@"picBtn"] forState:UIControlStateNormal];
    [tool addSubview:imageB];
    
    self.placeholderL = [[UILabel alloc]initWithFrame:CGRectMake(23, 57.75, 200, 20)];
    _placeholderL.backgroundColor = [UIColor clearColor];
    _placeholderL.textColor = [UIColor grayColor];
    _placeholderL.text = @"今天想跟别人说点什么……";
    [self.view addSubview:_placeholderL];
    
    
    PhotoB = [UIButton buttonWithType:UIButtonTypeCustom];
    PhotoB.frame = CGRectMake(13, 195, 48.5, 48.5);
    [PhotoB setBackgroundImage:[UIImage imageNamed:@"tianjiazhaopian"] forState:UIControlStateNormal];
    [PhotoB addTarget:self action:@selector(getAnActionSheet) forControlEvents:UIControlEventTouchUpInside];
    PhotoB.hidden = YES;
    [self.view addSubview:PhotoB];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.delegate = self;
    hud.labelText = @"正在发送，请稍后";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - button action
-(void)backButton:(UIButton*)button
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)next
{
    if (_dynamicTV.text.length<=0) {
        return;
    }
    if (self.pictureArray.count>0) {
        NSMutableArray* imageArray = [[NSMutableArray alloc]init];
        NSMutableArray* nameArray = [[NSMutableArray alloc]init];
        for (int i = 0;i< self.pictureArray.count;i++) {
            [imageArray addObject:((UIImageView*)self.pictureArray[i]).image];
            [nameArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [NetManager uploadImagesWithCompres:imageArray WithURLStr:BaseUploadImageUrl ImageName:nameArray TheController:self Progress:nil Success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            NSDictionary* CompresID = responseObject;
            [NetManager uploadImages:imageArray WithURLStr:BaseUploadImageUrl ImageName:nameArray TheController:self Progress:nil Success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                self.imageId = [[NSMutableString alloc]init];
                for (NSString*a in responseObject) {
                    [_imageId appendFormat:@"%@_%@,",[CompresID objectForKey:a],[responseObject objectForKey:a]];
                }
             [self publishWithImageString:_imageId];
             
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }else
    {
        [self publishWithImageString:@""];
    }
}
-(void)publishWithImageString:(NSString*)imageID
{
//    body={"method":"addUserState","token":"XXX","channel":"","mac":"","imei":"","params":{"msg":"","imgid":"","ifTransmitMsg":"","transmitUrl":"","transmitMsg":""}}
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [params setObject:@"" forKey:@"transmitUrl"];
    [params setObject:@"" forKey:@"transmitMsg"];
    [params setObject:@"0" forKey:@"ifTransmitMsg"];
    [params setObject:self.dynamicTV.text forKey:@"msg"];
    [params setObject:imageID forKey:@"imgid"];
    [params setObject:[[TempData sharedInstance] getMyUserID] forKey:@"userid"];
    [params setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLon]] forKey:@"longitude"];
    [params setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLat]] forKey:@"latitude"];
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"addUserState" forKey:@"method"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
}
-(void)getAnActionSheet
{
    if (_pictureArray.count<=9) {
        self.addActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [_addActionSheet showInView:self.view];
    }
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
        }
    }
    
}
#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (self.pictureArray == nil) {
        self.pictureArray = [[NSMutableArray alloc]init];
    }
    PhotoB.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage*selectImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageView* imageV = [[UIImageView alloc]initWithFrame:PhotoB.frame];
    imageV.userInteractionEnabled = YES;
    imageV.image = selectImage;
    [self.view addSubview:imageV];
    if (PhotoB.frame.origin.x < 250) {
        PhotoB.frame = CGRectMake(PhotoB.frame.origin.x+ PhotoB.frame.size.width +12.875, PhotoB.frame.origin.y, PhotoB.frame.size.width, PhotoB.frame.size.height);
    }else{
        PhotoB.frame = CGRectMake(13, 250.5, PhotoB.frame.size.width, PhotoB.frame.size.height);
    }
    [_pictureArray addObject:imageV];
    if (_pictureArray.count == 9) {
        PhotoB.hidden = YES;
    }
    UITapGestureRecognizer*tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    [imageV addGestureRecognizer:tapGR];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}
@end
