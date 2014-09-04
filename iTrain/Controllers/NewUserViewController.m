//
//  NewUserViewController.m
//  iTrain
//
//  Created by Interest on 14-8-28.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "NewUserViewController.h"

@interface NewUserViewController ()<UITextFieldDelegate>

@end
NSInteger orginY;
@implementation NewUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        orginY=-1;
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
    self.title = @"新建用户";
    [self setLeftCustomBarItem:@"ul_back.png" action:nil];

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
    
    
    _headImg.userInteractionEnabled=YES;
    UITapGestureRecognizer *gotoUserinfoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoUserinfoView:)];
    [_headImg addGestureRecognizer:gotoUserinfoTap];
    ;
    
}

-(IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)backgroundTap:(id)sender {
//    [_t1 resignFirstResponder];
//    [_t2 resignFirstResponder];
//    NSTimeInterval animationDuration = 0.30f;
//    
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    
//    [UIView setAnimationDuration:animationDuration];
//    
//    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
//    
//    self.view.frame = rect;
    
    
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
}

#pragma mark -

#pragma mark 解决虚拟键盘挡住UITextField的方法

- (void)keyboardWillShow:(NSNotification *)noti

{
    
    //键盘输入的界面调整
    
    //键盘的高度
    
    float height = 216.0;
    
    CGRect frame = self.view.frame;
    
    frame.size = CGSizeMake(frame.size.width, frame.size.height - height);
    
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    
    [UIView setAnimationDuration:0.30];
    
    [UIView setAnimationDelegate:self];
    
    [self.view setFrame:frame];
    
    [UIView commitAnimations];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f,orginY, self.view.frame.size.width, self.view.frame.size.height);
    //CGRect rect = CGRectMake(0.0f, 20.0f, self.view.frame.size.width, self.view.frame.size.height);
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
    
    [textField resignFirstResponder];
    
    return YES;
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    if(orginY==-1){
         orginY=self.view.frame.origin.y;
    }
   
    CGRect frame = textField.frame;
    NSLog(@"%f,%f",textField.frame.origin.y,self.view.frame.size.height);
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.view.frame.size.width;
    
    float height = self.view.frame.size.height;
    
    if(offset > 0)
        
    {
        
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
        
    }
    
    [UIView commitAnimations];
    
}

#pragma mark -

- (void)showSheet:(id)sender {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"男", @"女",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    [actionSheet setTag:1];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet tag]==1) {
        if (buttonIndex == 0) {
            _sexText.text=@"男";
        }else if (buttonIndex == 1) {
            _sexText.text=@"女";
        }
    
    }else{
        if (buttonIndex == 0) {
       
            [self photoFromCamera];
        }else if (buttonIndex == 1) {
            [self photoFromAlbum];
            
    }
    }
   
}

//选取照片
//             - (void)gotoUserinfoView:(id)sender {
- (void)gotoUserinfoView:(id)sender {
//    userView= [[UserViewController alloc] init];
//    [self.navigationController pushViewController:userView animated:YES];
    
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
    //NSLog(@"%@",info);
    //保存原始图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self saveImage:image withName:@"currentImage.png"];
    
}

//保存图片
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    //将选择的图片显示出来
    [_headImg setImage:[UIImage imageWithContentsOfFile:fullPath]];
    //将图片保存到disk
    UIImageWriteToSavedPhotosAlbum(currentImage, nil, nil, nil);
}

//取消操作时调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
