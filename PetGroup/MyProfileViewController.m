//
//  MyProfileViewController.m
//  PetGroup
//
//  Created by Tolecen on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "MyProfileViewController.h"

@interface MyProfileViewController ()

@end

@implementation MyProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.waitingUploadImgArray = [NSMutableArray array];
        self.waitingUploadStrArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1]];
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
    titleLabel.text = self.hostInfo.nickName;
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    
    self.photoWall = [[HGPhotoWall alloc] initWithFrame:CGRectZero];
    self.photoWall.descriptionType = DescriptionTypeImage;
    [self.photoWall setPhotos:[self imageToURL:self.hostInfo.headImgArray]];
    self.photoWall.delegate = self;
    [self.photoWall setEditModel:YES];
    self.photoWall.tag =1;
    self.photoWall.useCache = YES;
    
    self.hostInfo.age = [NSString stringWithFormat:@"%@岁",self.hostInfo.age];
 
    
    self.titleArray = [NSArray arrayWithObjects:@"昵称",@"性别",@"年龄",@"地区",@"个性签名",@"爱好", nil];
    self.discribeArray = [NSMutableArray arrayWithObjects:self.hostInfo.nickName?self.hostInfo.nickName:PlaceHolder,self.hostInfo.gender?self.hostInfo.gender:PlaceHolder,self.hostInfo.age?self.hostInfo.age:PlaceHolder,self.hostInfo.region?self.hostInfo.region:PlaceHolder,self.hostInfo.signature?self.hostInfo.signature:PlaceHolder,self.hostInfo.hobby?self.hostInfo.hobby:PlaceHolder, nil];
    self.placeHolderArray = [NSMutableArray arrayWithObjects:@"昵称",@"性别",@"年龄",@"选择一个地区",@"写一下签名吧",@"填一下爱好吧", nil];
    [self makeHeight];
    self.profileTableV = [[UITableView alloc] initWithFrame:CGRectMake(0,44, 320, self.view.frame.size.height-44) style:UITableViewStyleGrouped];
    [self.view addSubview:self.profileTableV];
    self.profileTableV.backgroundView = nil;
    self.profileTableV.dataSource = self;
    self.profileTableV.delegate = self;

	// Do any additional setup after loading the view.
}
-(void)reloadViews
{
    [self.photoWall setPhotos:[self imageToURL:self.hostInfo.headImgArray]];
    self.hostInfo.age = [NSString stringWithFormat:@"%@岁",self.hostInfo.age];
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
                cell.describeLabel.text = [self.discribeArray objectAtIndex:indexPath.row];
                cell.describeLabel.frame = CGRectMake(cell.describeLabel.frame.origin.x, cell.describeLabel.frame.origin.y, cell.describeLabel.frame.size.width, [[self.heightArray objectAtIndex:indexPath.row] floatValue]);
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
            if (indexPath.row==0) {
                reportV.maxCount = 16;
            }
            else
                reportV.maxCount = 50;
            [self.navigationController pushViewController:reportV animated:YES];
        }
    }
}

- (void)photoWallPhotoTaped:(NSUInteger)index WithPhotoWall:(UIView *)photoWall
{
    PhotoViewController * photoV = [[PhotoViewController alloc] initWithSmallImages:nil images:self.hostInfo.headBigImgArray indext:index];
    [self presentModalViewController:photoV animated:NO];
}

- (void)photoWallMovePhotoFromIndex:(NSInteger)index toIndex:(NSInteger)newIndex
{
    
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
        [self.waitingUploadStrArray removeObject:tempStr];
        [self.waitingUploadImgArray removeObjectAtIndex:index];
    }
    [tempH removeObjectAtIndex:index];
    [tempHBig removeObjectAtIndex:index];
    self.hostInfo.headImgArray = tempH;
    self.hostInfo.headBigImgArray = tempHBig;
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
    [self.profileTableV reloadData];
    [picker dismissModalViewControllerAnimated:YES];
    
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
