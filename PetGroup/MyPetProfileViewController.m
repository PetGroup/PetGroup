//
//  MyPetProfileViewController.m
//  PetGroup
//
//  Created by Tolecen on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "MyPetProfileViewController.h"

@interface MyPetProfileViewController ()

@end

@implementation MyPetProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.ageArray = [[NSMutableArray alloc]init];
        for (int i = 1; i <= 100; i++) {
            [_ageArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        self.pageType = PageStyleChange;
        self.waitingUploadImgArray = [NSMutableArray array];
        self.waitingUploadStrArray = [NSMutableArray array];
        self.petTypeArray = [[NSMutableArray alloc]initWithObjects:@"狗狗",@"猫咪",@"其他" ,nil];
        self.petBreedArray = [XMLMatcher allDogs];
        self.genderArray = [NSArray arrayWithObjects:@"公",@"母",@"不限", nil];
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
    [self.photoWall setPhotos:[self imageToURL:self.petInfo.headImgArray]];
    self.photoWall.delegate = self;
    [self.photoWall setEditModel:YES];
    self.photoWall.tag =1;
    


    
    self.petInfo.petType = [XMLMatcher typeStringWithNumber:self.petInfo.petType];
    self.petInfo.petTrait = self.petInfo.petTrait.length>1?self.petInfo.petTrait:@"主人还没有给她填写特点呢";
//    if ([self.petInfo.petGender isEqualToString:@"male"]) {
//        self.petInfo.petGender = @"公";
//    }
//    else if ([self.petInfo.petGender isEqualToString:@"female"]){
//        self.petInfo.petGender = @"母";
//    }
//    else
//        self.petInfo.petGender = @"还不知道呢";
    self.petInfo.petAge = [NSString stringWithFormat:@"%@",self.petInfo.petAge];



    
    self.titleArray = [NSArray arrayWithObjects:@"品种",@"昵称",@"性别",@"年龄",@"特点", nil];
    self.placeHolderArray = [NSMutableArray arrayWithObjects:@"告诉大家宝贝的品种吧",@"给宝贝起个昵称吧",@"请选择宝贝性别",@"请选择宝贝年龄",@"说说宝贝的特点吧", nil];
    self.discribeArray = [NSMutableArray arrayWithObjects:self.petInfo.petType?self.petInfo.petType:PlaceHolder,self.petInfo.petNickname?self.petInfo.petNickname:PlaceHolder,self.petInfo.petGender?self.petInfo.petGender:PlaceHolder,self.petInfo.petAge?self.petInfo.petAge:PlaceHolder,self.petInfo.petTrait?self.petInfo.petTrait:PlaceHolder, nil];
    [self makeHeight];
    self.profileTableV = [[UITableView alloc] initWithFrame:CGRectMake(0,44, 320, self.view.frame.size.height-44) style:UITableViewStyleGrouped];
    [self.view addSubview:self.profileTableV];
    self.profileTableV.backgroundView = nil;
    self.profileTableV.dataSource = self;
    self.profileTableV.delegate = self;
    
    self.petTypeStr = @"Dog";
    if (self.pageType==PageStyleAdd) {
        self.petInfo = [[PetInfo alloc] init];
        self.petInfo.headImgStr = @"";
        self.petInfo.petType = @"";
    }
    
    UIImageView *TopBarBGV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBG.png"]];
    [TopBarBGV setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:TopBarBGV];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 80, 44);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 2, 120, 40)];
    titleLabel.backgroundColor=[UIColor clearColor];
    if (self.pageType==PageStyleAdd) {
        titleLabel.text=@"添加新宠物";
        
    }
    else
        titleLabel.text=self.petInfo.petNickname;
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
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
    
    [chooseRegionV addSubview:self.agePV];
    
    self.genderPV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-180, 320, 200)];
    _genderPV.showsSelectionIndicator = YES;
    _genderPV.dataSource = self;
    _genderPV.delegate = self;
    self.genderPV.hidden = YES;
    
    [chooseRegionV addSubview:self.genderPV];

    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.delegate = self;
    hud.labelText = @"提交中...";
	// Do any additional setup after loading the view.
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
                if (indexPath.row==2) {
                    if ([[self.discribeArray objectAtIndex:indexPath.row] isEqualToString:@"male"]) {
                        cell.describeLabel.text = @"公";
                    }
                    else if ([[self.discribeArray objectAtIndex:indexPath.row] isEqualToString:@"female"])
                        cell.describeLabel.text = @"母";
                    else
                        cell.describeLabel.text = @"还不知道呢";
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
            if (self.pageType==PageStyleAdd) {
                [cell.saveBtn setTitle:@"确认添加" forState:UIControlStateNormal];
            }
            else
                [cell.saveBtn setTitle:@"保存修改" forState:UIControlStateNormal];
            [cell.saveBtn addTarget:self action:@selector(savePetInfo) forControlEvents:UIControlEventTouchUpInside];
            return cell;

        }
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        if (indexPath.row==1||indexPath.row==4) {
            
            ReportViewController * reportV = [[ReportViewController alloc] init];
            reportV.theTitle = [self.titleArray objectAtIndex:indexPath.row];
            reportV.thisIndex = indexPath.row;
            if (indexPath.row==1) {
                reportV.maxCount = 16;
                reportV.defaultContent = self.petInfo.petNickname;
            }
            else {
                reportV.maxCount = 50;
                reportV.defaultContent = self.petInfo.petTrait;
            }
            reportV.textDelegate = self;
            [self.navigationController pushViewController:reportV animated:YES];
        }
        else if (indexPath.row==0){
            [self selectCity];
        }
        else if (indexPath.row==2){
            [self selectGender];
        }
        else if (indexPath.row==3){
            [self selectAge];
        }
    }
}

- (void)photoWallPhotoTaped:(NSUInteger)index WithPhotoWall:(UIView *)photoWall
{
    PhotoViewController * photoV = [[PhotoViewController alloc] initWithSmallImages:nil images:self.petInfo.headBigImgArray indext:index];
    [self presentModalViewController:photoV animated:NO];
}

- (void)photoWallMovePhotoFromIndex:(NSInteger)index toIndex:(NSInteger)newIndex
{
    if (index!=newIndex) {
        NSMutableArray * array1 = [NSMutableArray arrayWithArray:self.petInfo.headImgArray];
        NSMutableArray * array2 = [NSMutableArray arrayWithArray:self.petInfo.headBigImgArray];
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
        
        self.petInfo.headImgArray = array1;
        self.petInfo.headBigImgArray = array2;
        self.petInfo.headImgStr = @"";
        for (int i = 0;i<self.petInfo.headImgArray.count;i++) {
            NSString * temp1 = [self.petInfo.headImgArray objectAtIndex:i];
            NSString * temp2 = [self.petInfo.headBigImgArray objectAtIndex:i];
            self.petInfo.headImgStr = [self.petInfo.headImgStr stringByAppendingFormat:@"%@_%@,",temp1,temp2];
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
    actionSheetTemp.tag = 1;
    [actionSheetTemp showInView:self.view];
}

- (void)photoWallAddFinish
{
    
}
-(void)photoWallDelPhotoAtIndex:(NSInteger)index
{
    NSLog(@"%d",index);
    NSMutableArray * tempH = [NSMutableArray arrayWithArray:self.petInfo.headImgArray];
    NSMutableArray * tempHBig = [NSMutableArray arrayWithArray:self.petInfo.headBigImgArray];
    NSString * tempStr = [tempH objectAtIndex:index];
    if ([self.waitingUploadStrArray containsObject:tempStr]) {
        int tempIndex = [self.waitingUploadStrArray indexOfObject:tempStr];
        [self.waitingUploadStrArray removeObject:tempStr];
        [self.waitingUploadImgArray removeObjectAtIndex:tempIndex];
    }
    [tempH removeObjectAtIndex:index];
    [tempHBig removeObjectAtIndex:index];
    self.petInfo.headImgArray = tempH;
    self.petInfo.headBigImgArray = tempHBig;
    self.petInfo.headImgStr = @"";
    for (int i = 0;i<self.petInfo.headImgArray.count;i++) {
        
        NSString * temp1 = [self.petInfo.headImgArray objectAtIndex:i];
        NSString * temp2 = [self.petInfo.headBigImgArray objectAtIndex:i];
        NSRange range=[temp1 rangeOfString:@"<local>"];
        if (range.location==NSNotFound) {
            self.petInfo.headImgStr = [self.petInfo.headImgStr stringByAppendingFormat:@"%@_%@,",temp1,temp2];
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
    if (actionSheet.tag==1) {
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
    NSTimeInterval nowT = [[NSDate date] timeIntervalSince1970];
    UIImage * upImage = (UIImage *)[info objectForKey:@"UIImagePickerControllerEditedImage"];
    //    UIImage* a = [NetManager compressImageDownToPhoneScreenSize:image targetSizeX:100 targetSizeY:100];
    //    UIImage* upImage = [NetManager image:a centerInSize:CGSizeMake(100, 100)];
    NSString *path = [RootDocPath stringByAppendingPathComponent:@"tempImage"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:path] == NO)
    {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString  *openImgPath = [NSString stringWithFormat:@"%@/%.0f_pet.jpg",path,nowT];
    
    if ([UIImageJPEGRepresentation(upImage, 1.0) writeToFile:openImgPath atomically:YES]) {
        NSLog(@"success///");
    }
    else
    {
        NSLog(@"fail");
    }
    NSMutableArray * tempArray;
    NSMutableArray * tempBigArray;
    if (self.petInfo.headImgArray) {
        tempArray = [NSMutableArray arrayWithArray:self.petInfo.headImgArray];
        tempBigArray = [NSMutableArray arrayWithArray:self.petInfo.headBigImgArray];
    }
    else
    {
        tempArray = [NSMutableArray array];
        tempBigArray = [NSMutableArray array];
    }
    [tempArray addObject:[NSString stringWithFormat:@"<local>%.0f_pet.jpg",nowT]];
    [tempBigArray addObject:[NSString stringWithFormat:@"<local>%.0f_pet.jpg",nowT]];
    [self.waitingUploadImgArray addObject:upImage];
    [self.waitingUploadStrArray addObject:[NSString stringWithFormat:@"<local>%.0f_pet.jpg",nowT]];
    [self.photoWall addPhoto:[NSString stringWithFormat:@"<local>%.0f_pet.jpg",nowT]];
    self.petInfo.headImgArray = tempArray;
    self.petInfo.headBigImgArray = tempBigArray;
    NSLog(@"%f",self.photoWall.frame.size.height);
    self.petInfo.headImgStr = @"";
    for (int i = 0;i<self.petInfo.headImgArray.count;i++) { 
        NSString * temp1 = [self.petInfo.headImgArray objectAtIndex:i];
        NSString * temp2 = [self.petInfo.headBigImgArray objectAtIndex:i];
        NSRange range=[temp1 rangeOfString:@"<local>"];
        if (range.location==NSNotFound) {
            self.petInfo.headImgStr = [self.petInfo.headImgStr stringByAppendingFormat:@"%@_%@,",temp1,temp2];
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
        [self.discribeArray replaceObjectAtIndex:0 withObject:self.petBreedArray[[_cityPV selectedRowInComponent:1]]];
        self.petInfo.petType = [NSString stringWithFormat:@"%@",[XMLMatcher typeWithString1:self.petTypeStr andString2:self.petBreedArray[[_cityPV selectedRowInComponent:1]]]];
        [self makeHeight];
        [self.profileTableV reloadData];
        [UIView animateWithDuration:0.3 animations:^{
            [self.profileTableV setFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
            [chooseRegionV setFrame:CGRectMake(0, self.view.frame.size.height, 320, self.view.frame.size.height)];
        } completion:^(BOOL finished) {
            self.cityPV.hidden = YES;
        }];
    }
    else if (self.agePV.hidden == NO){
        [self.discribeArray replaceObjectAtIndex:3 withObject:_ageArray[[_agePV selectedRowInComponent:0]]];
        [self makeHeight];
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
        NSString * theGender = _genderArray[[_genderPV selectedRowInComponent:0]];
        if ([theGender isEqualToString:@"公"]) {
            theGender = @"male";
        }
        else if ([theGender isEqualToString:@"母"]){
            theGender = @"female";
        }
        else
            theGender = @"anything";
        [self.discribeArray replaceObjectAtIndex:2 withObject:theGender];
        [self makeHeight];
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

-(void)savePetInfo
{
    if (self.petInfo.petType.length<1) {
        [self showAlert:@"给您的宝贝写个品种呗，找不到咱就写个其它嘛"];
        return;
    }
    if ([[self.discribeArray objectAtIndex:1] isEqualToString:PlaceHolder]||[[self.discribeArray objectAtIndex:1] length]<1) {
        [self showAlert:@"给您的宝贝写个昵称呗"];
        return;
    }
    if ([[self.discribeArray objectAtIndex:4] isEqualToString:PlaceHolder]||[[self.discribeArray objectAtIndex:4] length]<1) {
        [self showAlert:@"宝贝有什么特点，写点吧"];
        return;
    }
    if ([[self.discribeArray objectAtIndex:2] isEqualToString:PlaceHolder]||[[self.discribeArray objectAtIndex:2] length]<1) {
        [self showAlert:@"宝贝的性别呢"];
        return;
    }
    if ([[self.discribeArray objectAtIndex:3] isEqualToString:PlaceHolder]||[[self.discribeArray objectAtIndex:3] length]<1) {
        [self showAlert:@"说说宝贝几岁了吧"];
        return;
    }

    if (self.waitingUploadImgArray.count>0) {
        [hud show:YES];
        [NetManager uploadImagesWithCompres:self.waitingUploadImgArray WithURLStr:BaseUploadImageUrl ImageName:self.waitingUploadStrArray Progress:nil Success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            NSDictionary* CompresID = responseObject;
            [NetManager uploadImages:self.waitingUploadImgArray WithURLStr:BaseUploadImageUrl ImageName:self.waitingUploadStrArray Progress:nil Success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                NSMutableArray * a1 = [NSMutableArray arrayWithArray:self.petInfo.headImgArray];
                NSMutableArray * a2 = [NSMutableArray arrayWithArray:self.petInfo.headBigImgArray];
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
                self.petInfo.headImgArray = a1;
                self.petInfo.headBigImgArray = a2;
                self.petInfo.headImgStr = @"";
                for (int i = 0;i<self.petInfo.headImgArray.count;i++) {
                    NSString * temp1 = [self.petInfo.headImgArray objectAtIndex:i];
                    NSString * temp2 = [self.petInfo.headBigImgArray objectAtIndex:i];
                    self.petInfo.headImgStr = [self.petInfo.headImgStr stringByAppendingFormat:@"%@_%@,",temp1,temp2];
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
-(void)showAlert:(NSString *)msg
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
}
-(void)finalUploadInfo
{
    [hud show:YES];
    if (self.pageType==PageStyleAdd) {
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
        long long a = (long long)(cT*1000);
        [params setObject:[self.discribeArray objectAtIndex:1] forKey:@"nickname"];
        [params setObject:self.petInfo.petType forKey:@"type"];
        [params setObject:self.petInfo.headImgStr forKey:@"img"];
        [params setObject:[self.discribeArray objectAtIndex:4] forKey:@"trait"];
        [params setObject:[self.discribeArray objectAtIndex:2] forKey:@"gender"];
        [params setObject:[self.discribeArray objectAtIndex:3] forKey:@"birthdate"];
        NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
        [body setObject:@"1" forKey:@"channel"];
        [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
        [body setObject:@"iphone" forKey:@"imei"];
        [body setObject:params forKey:@"params"];
        [body setObject:@"savePetinfo" forKey:@"method"];
        [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
        [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
        
        [NetManager requestWithURLStr:BaseClientUrl Parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [hud hide:YES];
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            [DataStoreManager storeOnePetInfo:dic];
            [self.navigationController popViewControllerAnimated:YES];
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [hud hide:YES];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
            [alert show];
            [hud hide:YES];
        }];

    }
    else
    {   
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
        long long a = (long long)(cT*1000);
        [params setObject:[self.discribeArray objectAtIndex:1] forKey:@"nickname"];
        [params setObject:self.petInfo.petType forKey:@"type"];
        [params setObject:self.petInfo.headImgStr forKey:@"img"];
        [params setObject:[self.discribeArray objectAtIndex:4] forKey:@"trait"];
        [params setObject:[self.discribeArray objectAtIndex:2] forKey:@"gender"];
        [params setObject:[self.discribeArray objectAtIndex:3] forKey:@"birthdate"];
        [params setObject:self.petInfo.petID forKey:@"id"];
        NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
        [body setObject:@"1" forKey:@"channel"];
        [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
        [body setObject:@"iphone" forKey:@"imei"];
        [body setObject:params forKey:@"params"];
        [body setObject:@"updatePetinfo" forKey:@"method"];
        [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
        [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
        
        [NetManager requestWithURLStr:BaseClientUrl Parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [hud hide:YES];
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            [DataStoreManager storeOnePetInfo:dic];
            [self.navigationController popViewControllerAnimated:YES];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [hud hide:YES];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络请求异常，请确认网络连接正常" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
            [alert show];
            [hud hide:YES];
        }];
    }
    
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
            return self.petTypeArray.count;
        }
        return self.petBreedArray.count;
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
            return self.petTypeArray[row];
        }
        return self.petBreedArray[row];
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
            switch (row) {
                case 0:
                {
                    self.petBreedArray = [XMLMatcher allDogs];
                    self.petTypeStr = @"Dog";
                }
                    break;
                case 1:
                {
                    self.petBreedArray = [XMLMatcher allCats];
                    self.petTypeStr = @"Cat";
                }
                    break;
                    
                default:
                {
                    self.petBreedArray = [XMLMatcher allother];
                    self.petTypeStr = @"Other";
                }
                    break;
            }
            [_cityPV reloadComponent:1];
        }
    }
}
//switch (self.petType) {
//    case 1:{
//        return 
//    }break;
//    case 2:{
//        return [XMLMatcher typeWithString1:@"Cat" andString2:_typeL.text];
//    }break;
//    case 3:{
//        return [XMLMatcher typeWithString1:@"Other" andString2:_typeL.text];
//    }break;
//    default:
//        return 0;
//        break;
//}
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
