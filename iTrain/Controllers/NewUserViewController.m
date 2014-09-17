//
//  NewUserViewController.m
//  iTrain
//
//  Created by Interest on 14-8-28.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "NewUserViewController.h"
#import "AppDelegate.h"
@interface NewUserViewController ()<UITextFieldDelegate>

@end
NSInteger orginY;
UITextField *nowField;
NSString *photo;
BOOL iSCreted;
BOOL isEn;
@implementation NewUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        orginY=-1;
        iSCreted=false;
         isEn=[NSLocalizedString(@"laun", nil) isEqual:@"En"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title =NSLocalizedString(@"NewUser", nil);
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];
    [self setRightCustomBarItems:_save];
    [_save addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [_save setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    if(!iSCreted){
        [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view inputViewDelegate:self];
        iSCreted=true;
    }
    photo=nil;
    
}

-(void)save:(id)sender{
    [DaiDodgeKeyboard textFieldDone];
    AppDelegate *myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *user=[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:myAppDelegate.managedObjectContext];
    [user setName:_nameText.text];
    [user setAge:[NSNumber numberWithInteger:[_ageText.text integerValue]]];
    NSString *stt;
    double istt;
    if(isEn){
        double m = [_hightText.text doubleValue]/0.0328;
        stt=[self notRounding:m afterPoint:0];
        istt=[_hightText.text doubleValue];
    }else{
        istt=[_hightText.text floatValue] * 0.0328;
        stt=[self notRounding:[_hightText.text floatValue] afterPoint:0];
    }
    NSString *st;
    double ist;
    if(isEn){
        double m = [_weightText.text doubleValue]/2.2046;
        st=[self notRounding:m afterPoint:0];
        ist=[_weightText.text doubleValue];
    }else{
        ist=[_weightText.text floatValue] * 2.2046;
        st=[self notRounding:[_weightText.text floatValue] afterPoint:0];
    }
    [user setWeight:[NSNumber numberWithInteger:[st floatValue]]];
    [user setPound:[NSNumber numberWithDouble:ist]];
    [user setHeight:[NSNumber numberWithInteger:[stt floatValue]]];
    [user setFeet:[NSNumber numberWithDouble:istt]];
    [user setSex:[NSNumber numberWithBool:[_sexText.text isEqual:@"男"]]];
    if(photo!=nil){
        photo=[self saveImage:_headImg.image withName:photo];
        [user setPhoto:photo];
    }
    [user setUzIndex:[NSNumber numberWithInt:0]];
    [user setHzIndex:[NSNumber numberWithInt:0]];
    [user setSpeedIndex:[NSNumber numberWithInt:0]];
    [user setStrongIndex:[NSNumber numberWithInt:0]];
    NSError *error = nil;
    BOOL isSave =   [myAppDelegate.managedObjectContext save:&error];
    if (!isSave) {
        NSLog(@"error:%@,%@",error,[error userInfo]);
    }
    else{
        NSLog(@"保存成功");
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:NSLocalizedString(@"SaveSu", nil) leftButtonTitle:nil rightButtonTitle:@"OK"];
        [alert show];
        alert.dismissBlock=^(){
            [self.navigationController popViewControllerAnimated:YES];
        };
        
    }
    
}
-(void)initUI{
    //设置圆角
    _userInfoView.layer.cornerRadius = 8;
    _userInfoView.layer.masksToBounds = YES;
    _nameText.delegate=self;
    _ageText.delegate=self;
    _hightText.delegate=self;
    _weightText.delegate=self;
    
    _ageText.keyboardType = UIKeyboardTypeNumberPad;
    _hightText.keyboardType = UIKeyboardTypeNumberPad;
    _weightText.keyboardType = UIKeyboardTypeNumberPad;
    [_sexBtn addTarget:self action:@selector(showSheet:) forControlEvents:UIControlEventTouchUpInside];
    
    [_NameTip setText:[NSLocalizedString(@"Name", nil) stringByAppendingString:@":"]];
    [_SexTip setText:[NSLocalizedString(@"Sex", nil) stringByAppendingString:@":"]];
    [_AgeTip setText:NSLocalizedString(@"NAge", nil)];
    [_HeightTip setText:NSLocalizedString(@"NHeight", nil)];
    [_WeightTip setText:NSLocalizedString(@"NWeight", nil)];
    [_PhotoTip setText:NSLocalizedString(@"Photo", nil)];
    _headImg.userInteractionEnabled=YES;
    UITapGestureRecognizer *gotoUserinfoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoUserinfoView:)];
    [_headImg addGestureRecognizer:gotoUserinfoTap];
    
    
}

- (IBAction)backgroundTap:(id)sender {
    [DaiDodgeKeyboard textFieldDone];
}



#pragma mark -

- (void)showSheet:(id)sender {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"cancle", nil)
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:NSLocalizedString(@"Man", nil), NSLocalizedString(@"WoMan", nil),nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    [actionSheet setTag:1];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet tag]==1) {
        if (buttonIndex == 0) {
            _sexText.text= NSLocalizedString(@"Man", nil);
        }else if (buttonIndex == 1) {
            _sexText.text= NSLocalizedString(@"WoMan", nil);
        }
        
    }else{
        if (buttonIndex == 0) {
            
            [self photoFromCamera];
        }else if (buttonIndex == 1) {
            [self photoFromAlbum];
            
        }
    }
    
}
/*
 选取照片模块
 */
//选取照片
//             - (void)gotoUserinfoView:(id)sender {
- (void)gotoUserinfoView:(id)sender {
    //    userView= [[UserViewController alloc] init];
    //    [self.navigationController pushViewController:userView animated:YES];
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"cancle", nil)
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:NSLocalizedString(@"Take", nil), NSLocalizedString(@"Choose", nil),nil];
    //    [actionSheet add]
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
    //NSLog(@"%@",info);
    //保存原始图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_headImg setImage:image];
    photo=[[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
    //if(photo==nil){
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    photo=[timeSp stringByAppendingString:@".png"];
    //}
}

//保存图片
- (NSString *) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    //将图片保存到disk
    //UIImageWriteToSavedPhotosAlbum(currentImage, nil, nil, nil);
    return fullPath;
}

//取消操作时调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}
/*
 选取照片模块
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
-(NSArray *)inputArray{
    NSArray *array=[[NSArray alloc]initWithObjects:_nameText,_ageText,_hightText,_weightText, nil];
    return array;
}

-(Boolean)prev:(UIView *)view{
    if(view==_ageText){
        [self showSheet:self.sexBtn];
        return false;
    }
    return true;
}

-(Boolean)next:(UIView *)view{
    if(view==_nameText){
        [self showSheet:self.sexBtn];
        return false;
    }
    return true;
}

-(NSString *)notRounding:(float)price afterPoint:(int)position{
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *ouncesDecimal;
    
    NSDecimalNumber *roundedOunces;
    
    
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
    
}
@end
