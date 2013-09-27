//
//  MyProfileViewController.m
//  PetGroup
//
//  Created by Tolecen on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "MyProfileViewController.h"
#import "JSON.h"
@interface MyProfileViewController ()

@end

@implementation MyProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.needGetInfo = NO;
        self.ageArray = [[NSMutableArray alloc]init];
        for (int i = 1; i <= 100; i++) {
            [_ageArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        self.genderArray = [NSArray arrayWithObjects:@"男",@"女", nil];
        NSString *path =[[NSString alloc]initWithString:[[NSBundle mainBundle]pathForResource:@"city"ofType:@"txt"]];
        NSData* data = [[NSData alloc]initWithContentsOfFile:path];
        self.ProvinceArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.cityArray = [_ProvinceArray[0] objectForKey:@"city"];
        self.waitingUploadImgArray = [NSMutableArray array];
        self.waitingUploadStrArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1]];

    
    
    self.photoWall = [[HGPhotoWall alloc] initWithFrame:CGRectZero];
    self.photoWall.descriptionType = DescriptionTypeImage;
    self.photoWall.useCache = YES;
    [self.photoWall setPhotos:[self imageToURL:self.hostInfo.headImgArray]];
    self.photoWall.delegate = self;
    [self.photoWall setEditModel:YES];
    self.photoWall.tag =1;
    
    
    self.hostInfo.age = [NSString stringWithFormat:@"%@",self.hostInfo.age];
 
    
    self.titleArray = [NSArray arrayWithObjects:@"昵称",@"性别",@"年龄",@"地区",@"个性签名",@"爱好", nil];
    self.discribeArray = [NSMutableArray arrayWithObjects:self.hostInfo.nickName?self.hostInfo.nickName:PlaceHolder,self.hostInfo.gender?self.hostInfo.gender:PlaceHolder,self.hostInfo.age?self.hostInfo.age:PlaceHolder,self.hostInfo.region?self.hostInfo.region:PlaceHolder,self.hostInfo.signature?self.hostInfo.signature:PlaceHolder,self.hostInfo.hobby?self.hostInfo.hobby:PlaceHolder, nil];
    self.placeHolderArray = [NSMutableArray arrayWithObjects:@"昵称",@"性别",@"年龄",@"选择一个地区",@"写一下签名吧",@"填一下爱好吧", nil];
    [self makeHeight];
    self.profileTableV = [[UITableView alloc] initWithFrame:CGRectMake(0,44, 320, self.view.frame.size.height-44) style:UITableViewStyleGrouped];
    [self.view addSubview:self.profileTableV];
    self.profileTableV.backgroundView = nil;
    self.profileTableV.dataSource = self;
    self.profileTableV.delegate = self;
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(90, 2, 140, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text = self.hostInfo.nickName;
    [titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    self.cityPV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-180, 320, 200)];
    _cityPV.dataSource = self;
    _cityPV.delegate = self;
    _cityPV.showsSelectionIndicator = YES;
    self.cityPV.hidden = YES;

    
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-180-44, 320, 44)];
    toolbar.tintColor = [UIColor blackColor];
    UIBarButtonItem*rb = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(didselectCity)];
    rb.tintColor = [UIColor blackColor];
    toolbar.items = @[rb];
    
    chooseRegionV = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, self.view.frame.size.height)];
    chooseRegionV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:chooseRegionV];
    [chooseRegionV addSubview:self.cityPV];
    [chooseRegionV addSubview:toolbar];
    
    
    self.agePV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-180, 320, 200)];
    _agePV.showsSelectionIndicator = YES;
    _agePV.dataSource = self;
    _agePV.delegate = self;
    self.agePV.hidden = YES;
    if (self.hostInfo.age) {
        [self.agePV selectRow:[self.hostInfo.age integerValue]-1 inComponent:0 animated:NO];
    }
    
    [chooseRegionV addSubview:self.agePV];
    
    self.genderPV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-180, 320, 200)];
    _genderPV.showsSelectionIndicator = YES;
    _genderPV.dataSource = self;
    _genderPV.delegate = self;
    self.genderPV.hidden = YES;
    
    [chooseRegionV addSubview:self.genderPV];
//    UIToolbar* aToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//    aToolbar.tintColor = [UIColor blackColor];
//    UIBarButtonItem*arb = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(didselectAge)];
//    arb.tintColor = [UIColor blackColor];
//    aToolbar.items = @[arb];
    
//    chooseAgeV = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 224)];
//    chooseAgeV.backgroundColor = [UIColor clearColor];
//    [chooseAgeV addSubview:self.agePV];
//    [chooseAgeV addSubview:aToolbar];
//    [self.view addSubview:chooseAgeV];

    [self analysisRegion];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.delegate = self;
    hud.labelText = @"修改中...";
	// Do any additional setup after loading the view.
}
-(void)reloadViews
{
    [self.photoWall setPhotos:[self imageToURL:self.hostInfo.headImgArray]];
    self.hostInfo.age = [NSString stringWithFormat:@"%@",self.hostInfo.age];
    self.discribeArray = [NSMutableArray arrayWithObjects:self.hostInfo.nickName?self.hostInfo.nickName:PlaceHolder,self.hostInfo.gender?self.hostInfo.gender:PlaceHolder,self.hostInfo.age?self.hostInfo.age:PlaceHolder,self.hostInfo.region?self.hostInfo.region:PlaceHolder,self.hostInfo.signature?self.hostInfo.signature:PlaceHolder,self.hostInfo.hobby?self.hostInfo.hobby:PlaceHolder, nil];
    [self makeHeight];
    [self.profileTableV reloadData];
}
-(void)makeHeight
{
    self.heightArray = [NSMutableArray array];
    for (NSString * it in self.discribeArray) {
        NSString * tempStr = it;
        if (it.length<1) {
            tempStr = @"temp";
        }
        CGSize size1 = [tempStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 300) lineBreakMode:NSLineBreakByWordWrapping];
        NSNumber * height1 = [NSNumber numberWithFloat:size1.height];
        [self.heightArray addObject:height1];
    }
}
-(NSArray *)imageToURL:(NSArray *)imageArray;
{
    NSMutableArray * temp = [NSMutableArray array];
    for (id headID in imageArray) {
        NSRange range=[headID rangeOfString:@"<local>"];
        if (range.location!=NSNotFound) {
            [temp addObject:headID];
        }
        else
            [temp addObject:[NSString stringWithFormat:@"%@%@",BaseImageUrl,headID]];
    }
    return temp;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return self.photoWall.frame.size.height;
    }
    else if (indexPath.section==2){
        return 40;
    }
    else
        return [[self.heightArray objectAtIndex:indexPath.row] floatValue]+20<40?40:[[self.heightArray objectAtIndex:indexPath.row] floatValue]+20;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return self.heightArray.count;
        }
            break;
        default:
        {
            return 1;
        }
            break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            static NSString *Cell = @"Cellsa";
            
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:Cell];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:Cell];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            for (UIView * view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
            [cell.contentView addSubview:self.photoWall];
            return cell;
        }
            break;
        case 1:
        {
            static NSString *Cell = @"profile";
            
            PetProfileCell *cell = (PetProfileCell *)[tableView dequeueReusableCellWithIdentifier:Cell];
            if (cell == nil) {
                cell = [[PetProfileCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:Cell];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.titleLabel.text = [self.titleArray objectAtIndex:indexPath.row];
            
            cell.describeLabel.textAlignment = NSTextAlignmentRight;
            if (![[self.discribeArray objectAtIndex:indexPath.row] isEqualToString:PlaceHolder]) {
                cell.describeLabel.textColor = [UIColor blackColor];
                cell.describeLabel.text = [self.discribeArray objectAtIndex:indexPath.row];
                cell.describeLabel.frame = CGRectMake(cell.describeLabel.frame.origin.x, cell.describeLabel.frame.origin.y, cell.describeLabel.frame.size.width, [[self.heightArray objectAtIndex:indexPath.row] floatValue]);
                if (indexPath.row==1) {
                    if ([[self.discribeArray objectAtIndex:indexPath.row] isEqualToString:@"male"]) {
                        cell.describeLabel.text = @"男";
                    }
                    else
                        cell.describeLabel.text = @"女";
                }

            }
            else
            {
                cell.describeLabel.text = [self.placeHolderArray objectAtIndex:indexPath.row];
                cell.describeLabel.textColor = [UIColor grayColor];
            }
            
            return cell;
        }
            break;
        default:
        {
            static NSString *Cell = @"buttton";
            
            ButtonCell *cell = (ButtonCell *)[tableView dequeueReusableCellWithIdentifier:Cell];
            if (cell == nil) {
                cell = [[ButtonCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:Cell];
            }
            [cell.saveBtn setTitle:@"保存修改" forState:UIControlStateNormal];
            [cell.saveBtn addTarget:self action:@selector(saveMyInfo) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
        }
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        if (indexPath.row==0||indexPath.row==4||indexPath.row==5) {
            ReportViewController * reportV = [[ReportViewController alloc] init];
            reportV.theTitle = [self.titleArray objectAtIndex:indexPath.row];
            reportV.defaultContent = [self.discribeArray objectAtIndex:indexPath.row];
            reportV.textDelegate = self;
            reportV.thisIndex = indexPath.row;
            if (indexPath.row==0) {
                reportV.maxCount = 16;
            }
            else
                reportV.maxCount = 50;
            [self.navigationController pushViewController:reportV animated:YES];
        }
        else if(indexPath.row==3){
            [self selectCity];
        }
        else if(indexPath.row==2){
            [self selectAge];
        }
        else if (indexPath.row==1){
            [self selectGender];
        }
    }
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
- (void)photoWallPhotoTaped:(NSUInteger)index WithPhotoWall:(UIView *)photoWall
{
    PhotoViewController * photoV = [[PhotoViewController alloc] initWithSmallImages:nil images:self.hostInfo.headBigImgArray indext:index];
    [self presentModalViewController:photoV animated:NO];
}

- (void)photoWallMovePhotoFromIndex:(NSInteger)index toIndex:(NSInteger)newIndex
{
    if (index!=newIndex) {
        NSMutableArray * array1 = [NSMutableArray arrayWithArray:self.hostInfo.headImgArray];
        NSMutableArray * array2 = [NSMutableArray arrayWithArray:self.hostInfo.headBigImgArray];
        NSString * tempStr = [array1 objectAtIndex:index];
        NSString * tempStr2 = [array2 objectAtIndex:index];
        

        
        if (newIndex<index) {
            [array1 insertObject:tempStr atIndex:newIndex];
            [array2 insertObject:tempStr2 atIndex:newIndex];
            [array1 removeObjectAtIndex:index+1];
            [array2 removeObjectAtIndex:index+1];
        }
        else{
            [array1 removeObjectAtIndex:index];
            [array2 removeObjectAtIndex:index];
            [array1 insertObject:tempStr atIndex:newIndex];
            [array2 insertObject:tempStr2 atIndex:newIndex];
        }
        
        self.hostInfo.headImgArray = array1;
        self.hostInfo.headBigImgArray = array2;
        self.hostInfo.headImgStr = @"";
        for (int i = 0;i<self.hostInfo.headImgArray.count;i++) {
            NSString * temp1 = [self.hostInfo.headImgArray objectAtIndex:i];
            NSString * temp2 = [self.hostInfo.headBigImgArray objectAtIndex:i];
            self.hostInfo.headImgStr = [self.hostInfo.headImgStr stringByAppendingFormat:@"%@_%@,",temp1,temp2];
        }
    }

}

- (void)photoWallAddAction
{
    UIActionSheet *actionSheetTemp = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"相册选择",@"拍照", nil];
    actionSheetTemp.tag = ActionSheetTypeChoosePic;
    [actionSheetTemp showInView:self.view];
}

- (void)photoWallAddFinish
{
    
}
-(void)photoWallDelPhotoAtIndex:(NSInteger)index
{
    NSLog(@"%d",index);
    NSMutableArray * tempH = [NSMutableArray arrayWithArray:self.hostInfo.headImgArray];
    NSMutableArray * tempHBig = [NSMutableArray arrayWithArray:self.hostInfo.headBigImgArray];
    NSString * tempStr = [tempH objectAtIndex:index];
    if ([self.waitingUploadStrArray containsObject:tempStr]) {
        int tempIndex = [self.waitingUploadStrArray indexOfObject:tempStr];
        [self.waitingUploadStrArray removeObject:tempStr];
        [self.waitingUploadImgArray removeObjectAtIndex:tempIndex];
    }
    [tempH removeObjectAtIndex:index];
    [tempHBig removeObjectAtIndex:index];
    self.hostInfo.headImgArray = tempH;
    self.hostInfo.headBigImgArray = tempHBig;
    self.hostInfo.headImgStr = @"";
    for (int i = 0;i<self.hostInfo.headImgArray.count;i++) {
        
        NSString * temp1 = [self.hostInfo.headImgArray objectAtIndex:i];
        NSString * temp2 = [self.hostInfo.headBigImgArray objectAtIndex:i];
        NSRange range=[temp1 rangeOfString:@"<local>"];
        if (range.location==NSNotFound) {
            self.hostInfo.headImgStr = [self.hostInfo.headImgStr stringByAppendingFormat:@"%@_%@,",temp1,temp2];
        }
    }
//    [self.photoWall reloadPhotos:YES];
    [self.profileTableV reloadData];
    
    
    
}
- (void)photoWallDeleteFinish
{
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.photoWall setAnimationNO];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==ActionSheetTypeChoosePic) {
        UIImagePickerController * imagePicker;
        if (buttonIndex==1)
            //这里捕捉“毁灭键”,其实该键的index是0，从上到下从0开始，称之为毁灭是因为是红的
        {
            if (imagePicker==nil) {
                imagePicker=[[UIImagePickerController alloc]init];
                imagePicker.delegate=self;
                imagePicker.allowsEditing = YES;
            }
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                [self presentModalViewController:imagePicker animated:YES];
            }
            else {
                UIAlertView *cameraAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备不支持相机" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
                [cameraAlert show];
            }
        }
        else if (buttonIndex==0) {
            if (imagePicker==nil) {
                imagePicker=[[UIImagePickerController alloc]init];
                imagePicker.delegate=self;
                imagePicker.allowsEditing = YES;
            }
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentModalViewController:imagePicker animated:YES];
            }
            else {
                UIAlertView *libraryAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备不支持相册" delegate:self cancelButtonTitle:@"了解" otherButtonTitles:nil];
                [libraryAlert show];
            }
        }
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@",info);
    UIImage * upImage = (UIImage *)[info objectForKey:@"UIImagePickerControllerEditedImage"];
//    UIImage* a = [NetManager compressImageDownToPhoneScreenSize:image targetSizeX:100 targetSizeY:100];
//    UIImage* upImage = [NetManager image:a centerInSize:CGSizeMake(100, 100)];
    NSString *path = [RootDocPath stringByAppendingPathComponent:@"tempImage"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:path] == NO)
    {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString  *openImgPath = [NSString stringWithFormat:@"%@/%d_me.jpg",path,self.hostInfo.headImgArray.count];
    
    if ([UIImageJPEGRepresentation(upImage, 1.0) writeToFile:openImgPath atomically:YES]) {
        NSLog(@"success///");
    }
    else
    {
        NSLog(@"fail");
    }
    NSMutableArray * tempArray;
    NSMutableArray * tempBigArray;
    if (self.hostInfo.headImgArray) {
        tempArray = [NSMutableArray arrayWithArray:self.hostInfo.headImgArray];
        tempBigArray = [NSMutableArray arrayWithArray:self.hostInfo.headBigImgArray];
    }
    else
    {
        tempArray = [NSMutableArray array];
        tempBigArray = [NSMutableArray array];
    }
    [tempArray addObject:[NSString stringWithFormat:@"<local>%d_me.jpg",self.hostInfo.headImgArray.count]];
    [tempBigArray addObject:[NSString stringWithFormat:@"<local>%d_me.jpg",self.hostInfo.headImgArray.count]];
    [self.waitingUploadImgArray addObject:upImage];
    [self.waitingUploadStrArray addObject:[NSString stringWithFormat:@"<local>%d_me.jpg",self.hostInfo.headImgArray.count]];
    [self.photoWall addPhoto:[NSString stringWithFormat:@"<local>%d_me.jpg",self.hostInfo.headImgArray.count]];
    self.hostInfo.headImgArray = tempArray;
    self.hostInfo.headBigImgArray = tempBigArray;
    NSLog(@"%f",self.photoWall.frame.size.height);
    self.hostInfo.headImgStr = @"";
    for (int i = 0;i<self.hostInfo.headImgArray.count;i++) {
        
        NSString * temp1 = [self.hostInfo.headImgArray objectAtIndex:i];
        NSString * temp2 = [self.hostInfo.headBigImgArray objectAtIndex:i];
        NSRange range=[temp1 rangeOfString:@"<local>"];
        if (range.location==NSNotFound) {
            self.hostInfo.headImgStr = [self.hostInfo.headImgStr stringByAppendingFormat:@"%@_%@,",temp1,temp2];
        }
    }
    [self.profileTableV reloadData];
    [picker dismissModalViewControllerAnimated:YES];
    
}
-(void)selectCity
{
    self.cityPV.hidden = NO;
    self.genderPV.hidden = YES;
    self.agePV.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        if (iPhone5) {
            [self.profileTableV setFrame:CGRectMake(0, -70, 320, self.view.frame.size.height-44)];
        }
        else
            [self.profileTableV setFrame:CGRectMake(0, -150, 320, self.view.frame.size.height-44)];
        [chooseRegionV setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    } completion:^(BOOL finished) {
        
    }];
    
}
-(void)selectAge
{
    self.agePV.hidden = NO;
    self.cityPV.hidden = YES;
    self.genderPV.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        if (iPhone5) {
            [self.profileTableV setFrame:CGRectMake(0, -50, 320, self.view.frame.size.height-44)];
        }
        else
            [self.profileTableV setFrame:CGRectMake(0, -100, 320, self.view.frame.size.height-44)];
        [chooseRegionV setFrame:CGRectMake(0, 0, 300, self.view.frame.size.height)];
    } completion:^(BOOL finished) {
        
    }];
    
}
-(void)selectGender
{
    self.genderPV.hidden = NO;
    self.agePV.hidden = YES;
    self.cityPV.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        if (iPhone5) {
            [self.profileTableV setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44)];
        }
        else
            [self.profileTableV setFrame:CGRectMake(0, -60, 320, self.view.frame.size.height-44)];
        [chooseRegionV setFrame:CGRectMake(0, 0, 300, self.view.frame.size.height)];
    } completion:^(BOOL finished) {
        
    }];
}
-(void)changeText:(NSString *)textinfo WithIndex:(int)theIndex
{
    [self.discribeArray replaceObjectAtIndex:theIndex withObject:textinfo];
    [self makeHeight];
    [self.profileTableV reloadData];
}
-(void)didselectCity
{
    if (self.cityPV.hidden==NO) {
        [self.discribeArray replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%@ %@",[_ProvinceArray[[_cityPV selectedRowInComponent:0]] objectForKey:@"Province"],_cityArray[[_cityPV selectedRowInComponent:1]]]];
        [self.profileTableV reloadData];
        [UIView animateWithDuration:0.3 animations:^{
            [self.profileTableV setFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
            [chooseRegionV setFrame:CGRectMake(0, self.view.frame.size.height, 320, self.view.frame.size.height)];
        } completion:^(BOOL finished) {
            self.cityPV.hidden = YES;
        }];
    }
    else if (self.agePV.hidden == NO){
        [self.discribeArray replaceObjectAtIndex:2 withObject:_ageArray[[_agePV selectedRowInComponent:0]]];
        [self.profileTableV reloadData];
        [UIView animateWithDuration:0.3 animations:^{
            [self.profileTableV setFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
            [chooseRegionV setFrame:CGRectMake(0, self.view.frame.size.height, 320, self.view.frame.size.height)];
        } completion:^(BOOL finished) {
            self.agePV.hidden = YES;
        }];
    }
    else
    {
        [self.discribeArray replaceObjectAtIndex:1 withObject:[_genderArray[[_genderPV selectedRowInComponent:0]] isEqualToString:@"男"]?@"male":@"female"];
        [self.profileTableV reloadData];
        [UIView animateWithDuration:0.3 animations:^{
            [self.profileTableV setFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
            [chooseRegionV setFrame:CGRectMake(0, self.view.frame.size.height, 320, self.view.frame.size.height)];
        } completion:^(BOOL finished) {
            self.genderPV.hidden = YES;
        }];
    }

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.profileTableV setFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
        [chooseRegionV setFrame:CGRectMake(0, self.view.frame.size.height, 320, self.view.frame.size.height)];
    } completion:^(BOOL finished) {
        self.genderPV.hidden = YES;
        self.agePV.hidden = YES;
        self.cityPV.hidden = YES;
    }];
}
-(void)didselectAge
{
    [self.discribeArray replaceObjectAtIndex:2 withObject:_ageArray[[_agePV selectedRowInComponent:0]]];
    [self.profileTableV reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        [chooseAgeV setFrame:CGRectMake(0, self.view.frame.size.height, 300, 224)];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)saveMyInfo
{
    [hud show:YES];
    if (self.waitingUploadImgArray.count>0) {
        [NetManager uploadImagesWithCompres:self.waitingUploadImgArray WithURLStr:BaseUploadImageUrl ImageName:self.waitingUploadStrArray TheController:self Progress:nil Success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            NSDictionary* CompresID = responseObject;
            [NetManager uploadImages:self.waitingUploadImgArray WithURLStr:BaseUploadImageUrl ImageName:self.waitingUploadStrArray TheController:self Progress:nil Success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                NSMutableArray * a1 = [NSMutableArray arrayWithArray:self.hostInfo.headImgArray];
                NSMutableArray * a2 = [NSMutableArray arrayWithArray:self.hostInfo.headBigImgArray];
                for (NSString*a in responseObject) {
                    //                    self.petInfo.headImgStr = [self.petInfo.headImgStr stringByAppendingFormat:@"%@_%@,",[CompresID objectForKey:a],[responseObject objectForKey:a]];
                    
                    for (int i = 0;i<a1.count;i++) {
                        if ([[a1 objectAtIndex:i] isEqualToString:a]) {
                            [a1 replaceObjectAtIndex:i withObject:[CompresID objectForKey:a]];
                        }
                        if ([[a2 objectAtIndex:i] isEqualToString:a]) {
                            [a2 replaceObjectAtIndex:i withObject:[responseObject objectForKey:a]];
                        }
                    }
                }
                self.hostInfo.headImgArray = a1;
                self.hostInfo.headBigImgArray = a2;
                self.hostInfo.headImgStr = @"";
                for (int i = 0;i<self.hostInfo.headImgArray.count;i++) {
                    NSString * temp1 = [self.hostInfo.headImgArray objectAtIndex:i];
                    NSString * temp2 = [self.hostInfo.headBigImgArray objectAtIndex:i];
                    self.hostInfo.headImgStr = [self.hostInfo.headImgStr stringByAppendingFormat:@"%@_%@,",temp1,temp2];
                }
                

                [self finalUploadInfo];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];

    }
    else
        [self finalUploadInfo];
}
-(void)finalUploadInfo
{
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body setObject:@"1" forKey:@"channel"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [body setObject:@"iphone" forKey:@"imei"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:[self.discribeArray objectAtIndex:0] forKey:@"nickname"];
    [params setObject:[self.discribeArray objectAtIndex:1] forKey:@"gender"];
    [params setObject:[self.discribeArray objectAtIndex:2] forKey:@"birthdate"];
    [params setObject:[self.discribeArray objectAtIndex:3] forKey:@"city"];
    [params setObject:self.hostInfo.headImgStr forKey:@"img"];
    [params setObject:[self.discribeArray objectAtIndex:4] forKey:@"signature"];
    [params setObject:[self.discribeArray objectAtIndex:5] forKey:@"hobby"];
    [body setObject:params forKey:@"params"];
    [body setObject:@"saveUserinfo2" forKey:@"method"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * recDict = [receiveStr JSONValue];
        [DataStoreManager saveUserInfo:recDict];
        [hud hide:YES];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [hud hide:YES];
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
    else if (pickerView == _agePV)
        return self.ageArray.count;
    else
        return self.genderArray.count;
}
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger) row forComponent:(NSInteger) component
{
    if (pickerView == _cityPV) {
        if (component == 0) {
            return [self.ProvinceArray[row] objectForKey:@"Province"];
        }
        return self.cityArray[row];
    }
    else if (pickerView == _agePV)
        return self.ageArray[row];
    else
        return self.genderArray[row];
    
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

-(void)back
{
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
