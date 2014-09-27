//
//  UIViewController+BarItem.m
//  HWSDK
//
//  Created by Carl_Huang on 13-11-19.
//  Copyright (c) 2013年 HelloWorld. All rights reserved.
//

#import "UIViewController+BarItem.h"

@implementation UIViewController (BarItem)

- (void)setLeftCustomBarItem:(NSString *)imageName action:(SEL)selector
{
    self.navigationItem.leftBarButtonItem = [self customBarItem:imageName action:selector];
    self.navigationItem.title=@"";
    
    UIBarButtonItem *item=self.navigationItem.leftBarButtonItem;
    UIButton *barButton=(UIButton *)[item customView];
    [barButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [barButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
     [barButton setTitle:self.title forState:UIControlStateNormal];
    
    [barButton setFrame:CGRectMake(0, 0, 200, 32)];

}

- (void)setLeftCustomBarItem:(NSString *)imageName action:(SEL)selector imageEdgeInsets:(UIEdgeInsets)sets
{
    self.navigationItem.leftBarButtonItem = [self customBarItem:imageName action:selector size:CGSizeMake(60, 32) imageEdgeInsets:sets];
}

-(void)setRightCustomBarItems:(UIView*)sview{
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]initWithCustomView:sview];
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:bar, nil];
    
}
- (void)setRightCustomBarItem:(NSString *)imageName action:(SEL)selector
{
    self.navigationItem.rightBarButtonItem = [self customBarItem:imageName action:selector];
}

-(void)setRightCustomBarItemState:(BOOL)isHide{
     [self.navigationItem.rightBarButtonItem.customView setHidden:isHide];
}
- (void)setRightCustomBarItem:(NSString *)imageName action:(SEL)selector imageEdgeInsets:(UIEdgeInsets)sets
{
    self.navigationItem.rightBarButtonItem = [self customBarItem:imageName action:selector size:CGSizeMake(60, 32) imageEdgeInsets:sets];
}

- (UIBarButtonItem *)customBarItem:(NSString *)imageName action:(SEL)selector
{
    return [self customBarItem:imageName action:selector size:CGSizeMake(32, 22)];
}

- (UIBarButtonItem *)customBarItem:(NSString *)imageName action:(SEL)selector size:(CGSize)itemSize
{
    UIImage * image = [UIImage imageNamed:imageName];
    UIButton * barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.exclusiveTouch = YES;
    [barButton setFrame:CGRectMake(0, 0, itemSize.width, itemSize.height)];
    [barButton setImage:image forState:UIControlStateNormal];
    
    //[barButton setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    if(selector)
    {
        [barButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [barButton addTarget:self action:@selector(pushBack) forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    barButton = nil;
    return item;
}

- (UIBarButtonItem *)customBarItem:(NSString *)imageName action:(SEL)selector size:(CGSize)itemSize imageEdgeInsets:(UIEdgeInsets)sets
{
    UIImage * image = [UIImage imageNamed:imageName];
    UIButton * barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.exclusiveTouch = YES;
    [barButton setFrame:CGRectMake(0, 0, itemSize.width, itemSize.height)];
    [barButton setImage:image forState:UIControlStateNormal];
    //[barButton setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    [barButton setImageEdgeInsets:sets];
    if(selector)
    {
        [barButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [barButton addTarget:self action:@selector(pushBack) forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    barButton = nil;
    return item;
}


- (void)popVIewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popToRoot
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)push:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Private Methods
- (void)pushBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
