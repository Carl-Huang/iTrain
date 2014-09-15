//
//  UserInfoViewController.m
//  iTrain
//
//  Created by Interest on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "UserInfoViewController.h"
#import "AppDelegate.h"
#import <AssetsLibrary/ALAsset.h>

#import <AssetsLibrary/ALAssetsLibrary.h>

#import <AssetsLibrary/ALAssetsGroup.h>

#import <AssetsLibrary/ALAssetRepresentation.h>

@implementation UserInfoViewController
bool isEditer;
NSMutableArray *textArray;
UITableViewCell *tcell;
AppDelegate *myAppDelegate;
UITextField *field;
NSString *photo;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        textArray=[[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self initUI];
}


-(void)initUI{
    // 初始化tableView的数据
    NSArray *list = [NSArray arrayWithObjects:@"头像",@"姓名",@"性别",@"年龄",@"身高",@"体重",@"单位", nil];
    NSArray *imagelist = [NSArray arrayWithObjects:@"user_icon",@"user_icon1",@"user_icon2",@"user_icon3",@"user_icon4",@"user_icon5",@"user_icon6", nil];
    self.dataList = list;
    self.imageList=imagelist;
    
   
    
    [self setExtraCellLineHidden:_myTableView];

    
    isEditer=NO;
    [_editBtn addTarget:self action:@selector(editClick)forControlEvents:UIControlEventTouchUpInside];
}
//Itme个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdenifer = @"UserInfoViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenifer];
    if (cell==nil) {
        //导航风格
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdenifer ];
        
        cell.showsReorderControl = YES;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        UITextField *editText=[[UITextField alloc]initWithFrame:CGRectMake(240,12,70,40)];
        [editText setTag:(indexPath.row+1)];
        if(indexPath.row!=0&&indexPath.row!=2){
              [textArray addObject:editText];
        }
        if(indexPath.row==1){
            tcell=cell;
        }
        if(indexPath.row==2){
            field=editText;
        }
        [cell addSubview:editText];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:cell.textLabel];
         cell.imageView.backgroundColor = [UIColor clearColor];
        if (indexPath.row==0) {
            cell.imageView.userInteractionEnabled=YES;
            UITapGestureRecognizer *gotoUserinfoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoUserinfoView:)];
            [cell.imageView addGestureRecognizer:gotoUserinfoTap];
           
            _headImg=cell.imageView;
        }
    }
    
    NSInteger row=[indexPath row];
    if(row==1){
        [(UITextField *)[cell viewWithTag:(indexPath.row+1)] setText:[_user name]];
    }else if(row==2){
        
        [(UITextField *)[cell viewWithTag:(indexPath.row+1)] setText:[[_user sex] boolValue]?@"男":@"女"];
    }else if(row==3){
        
        [(UITextField *)[cell viewWithTag:(indexPath.row+1)] setText:[NSString stringWithFormat:@"%d",[[_user age] integerValue]]];
    }else if(row==4){
        [(UITextField *)[cell viewWithTag:(indexPath.row+1)] setText:[NSString stringWithFormat:@"%d",[[_user height] integerValue]]];
    }else if(row==5){
        [(UITextField *)[cell viewWithTag:(indexPath.row+1)] setText:[NSString stringWithFormat:@"%d",[[_user weight] integerValue]] ];
    }else{
        
    }
    if (row==0) {
        [[cell viewWithTag:(indexPath.row+1)] setHidden:YES];
           cell.imageView.image = [UIImage imageNamed:[_imageList objectAtIndex:0]];
        NSString *st=[_user photo];
        if(st!=nil){
            if([st hasPrefix:@"assets-library"]){
                ALAssetsLibrary* lib = [[ALAssetsLibrary alloc] init];
                [lib assetForURL:[NSURL URLWithString:[_user photo]] resultBlock:^(ALAsset *asset)
                 {
                     // 使用asset来获取本地图片
                     ALAssetRepresentation *assetRep = [asset defaultRepresentation];
                     CGImageRef imgRef = [assetRep fullResolutionImage];
                     UIImage *avatarImage = [UIImage imageWithCGImage:imgRef
                                                                scale:assetRep.scale
                                                          orientation:(UIImageOrientation)assetRep.orientation];
                     if(avatarImage!=nil){
                         [cell.imageView setImage:avatarImage];
                     }
                     
                 }
                    failureBlock:^(NSError *error)
                 {
                 }
                 ];
            }else{
                cell.imageView.image = [UIImage imageWithContentsOfFile:st];
            }
        }
        
    }else{
        [[cell viewWithTag:(indexPath.row+1)] setHidden:NO];
        cell.imageView.image = [UIImage imageNamed:[_imageList objectAtIndex:row]];
    }
   
    if (isEditer) {
        ((UITextField *)[cell viewWithTag:(indexPath.row+1)]).enabled=YES;
    }else{
        ((UITextField *)[cell viewWithTag:(indexPath.row+1)]).enabled=NO;
    }
   
  
    cell.textLabel.text= [NSString stringWithFormat:@"%@", [_dataList objectAtIndex:row]];
   
    
   
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]==0) {
        return 70;
    }
    return 44;
}
//隐藏TabelView下面多余分割线

- (void)setExtraCellLineHidden: (UITableView *)tableView

{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"个人信息";
    [self setLeftCustomBarItem:@"ul_back.png" action:@selector(back)];
    
     _myTableView.dataSource = self;
    // 设置tableView的数据源
    
    // 设置tableView的委托
    _myTableView.delegate = self;
    // 设置tableView的背景图
    _myTableView.scrollEnabled=NO;
    [_myTableView reloadData];
    [DaiDodgeKeyboard textFieldDone];
}

-(void)back{
    if(photo!=nil){
        photo=[self saveImage:_headImg.image withName:photo];
        [_user setPhoto:photo];
    }
    
    NSError *error;
    BOOL isSave =   [myAppDelegate.managedObjectContext save:&error];
    if (!isSave) {
        NSLog(@"error:%@,%@",error,[error userInfo]);
    }
    else{
        NSLog(@"保存成功");
    }

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self photoFromCamera];
    }else if (buttonIndex == 1) {
        [self photoFromAlbum];
    }
    
}
-(void)editClick{
   isEditer=YES;
    for(int i=0;i<textArray.count;i++){
        ((UITextField *)[textArray objectAtIndex:i]).enabled=YES;
    }
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view inputViewDelegate:self];
    [[tcell viewWithTag:2] becomeFirstResponder];
}
/*选取照片模块
 */

//选取照片
- (void)gotoUserinfoView:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"从相册选择",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet setTag:2];
    [actionSheet showInView:self.view];
}



//从相机获取图片
//             - (void)photoFromCamera:(id)sender {
- (void)photoFromCamera {
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;//设置类型为相机
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;//设置代理
        picker.allowsEditing = YES;//设置照片可编辑
        picker.sourceType = sourceType;
        //picker.showsCameraControls = NO;//默认为YES
        //创建叠加层
        UIView *overLayView=[[UIView alloc]initWithFrame:CGRectMake(0, 120, 320, 254)];
        //取景器的背景图片，该图片中间挖掉了一块变成透明，用来显示摄像头获取的图片；
        UIImage *overLayImag=[UIImage imageNamed:@"zhaoxiangdingwei.png"];
        UIImageView *bgImageView=[[UIImageView alloc]initWithImage:overLayImag];
        [overLayView addSubview:bgImageView];
        picker.cameraOverlayView=overLayView;
        picker.cameraDevice=UIImagePickerControllerCameraDeviceFront;//选择前置摄像头或后置摄像头
        [self presentViewController:picker animated:YES completion:^{
        }];
    }
    else {
        NSLog(@"该设备无相机");
    }
}
//从相册获取图片
- (void)photoFromAlbum {
    
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentViewController:pickerImage animated:YES completion:^{
    }];
    
}
//从相册选择图片后操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    //保存原始图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_headImg setImage:image];
    NSString *st=[[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
    //if(st==nil){
        NSDate *datenow = [NSDate date];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
        photo=[timeSp stringByAppendingString:@".png"];
        [self saveImage:image withName:photo];
        //return;
    //}
    
    //[_user setPhoto:st];
}

//保存图片
- (NSString *) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    [_headImg setImage:[UIImage imageWithContentsOfFile:fullPath]];
    //将选择的图片显示出来
    [_user setPhoto:fullPath];
    //将图片保存到disk
   // UIImageWriteToSavedPhotosAlbum(currentImage, nil, nil, nil);
    return fullPath;
}

//取消操作时调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}



#pragma mark -
-(NSArray *)inputArray{
    return textArray;
}

-(Boolean)prev:(UIView *)view{
     [self save:[textArray indexOfObject:view] withView:view];
    if([view tag]==4){
        [self gotoUserinfoView:_headImg];
        return false;
    }
    return true;
}

-(Boolean)next:(UIView *)view{
    [self save:[textArray indexOfObject:view] withView:view];
    if(view==[tcell viewWithTag:2]){
        [self gotoUserinfoView:_headImg];
        return false;
    }
    return true;
}

-(void)save:(NSInteger) row withView:(UIView *)tcell{
    UITextField *cell=(UITextField *)tcell;
    [_user setSex:[NSNumber numberWithBool:[field.text isEqual:@"男"]]];
    if(row==0){
        [_user setName:cell.text];
    }else if(row==1){
        [_user setAge:[NSNumber numberWithInteger:[cell.text integerValue]]];
        
    }else if(row==2){
        [_user setHeight:[NSNumber numberWithInteger:[cell.text integerValue]]];
    }else if(row==3){
         [_user setWeight:[NSNumber numberWithInteger:[cell.text integerValue]]];
    }
   }
@end
