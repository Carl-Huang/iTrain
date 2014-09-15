//
//  DaiDodgeKeyboard.m
//  DaiDodgeKeyboard
//
//  Created by 啟倫 陳 on 2014/4/25.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiDodgeKeyboard.h"

#import "UIView+FirstResponderNotify.h"
#import "DaiDodgeKeyboard+AccessObject.h"
#import "DaiDodgeKeyboard+Animation.h"

@interface DaiDodgeKeyboard ()

+(void) keyboardWillShow : (NSNotification*) notification;
+(void) keyboardWillHide : (NSNotification*) notification;
+(void) addObservers;
+(void) removeObservers;

@end

@implementation DaiDodgeKeyboard
NSArray *inputViews;
UIView *uiview;
id<KeyboardDelegate> tdelegate;
#pragma mark - private
NSInteger orginY;
+(void) keyboardWillShow : (NSNotification*) notification {
    
    [self setIsKeyboardShow:YES];
    
    NSDictionary *userInfo = [notification userInfo];
    [self setKeyboardAnimationDutation:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [self setKeyboardRect:[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]];

    [self dodgeKeyboardAnimation];
    
}

+(void) keyboardWillHide : (NSNotification*) notification {
    
    [self setIsKeyboardShow:NO];
    [self dodgeKeyboardAnimation];
    
}


+(void) addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

+(void) removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - class method

+(void) addRegisterTheViewNeedDodgeKeyboard : (UIView*) view inputViewDelegate:(id<KeyboardDelegate>) detegate{
    [self removeRegisterTheViewNeedDodgeKeyboard];
    uiview=view;
    inputViews=[detegate inputArray];
    UIToolbar *bar=[self createToolbar:view];
    for (UIView *v in inputViews) {
        [v performSelector:@selector(setDelegate:) withObject:self];
        [v performSelector:@selector(setInputAccessoryView:) withObject:bar];
    }
    tdelegate=detegate;
    [self setObserverView:view];
    [self setOriginalViewFrame:view.frame];
    [self setIsKeyboardShow:NO];
    
    [self addObservers];
}

+(void) removeRegisterTheViewNeedDodgeKeyboard {
    
    objc_removeAssociatedObjects(self);
    
    [self removeObservers];
    
}


+(UIToolbar*) createToolbar:(UIView *)uiview {
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, uiview.frame.size.width, 50)];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(nextTextField)];
    
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:@"Prev"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(prevTextField)];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(textFieldDone)];
    toolBar.items = @[prevButton, nextButton, space, done];
    
    return toolBar;
}


+(void) nextTextField {
    
    NSUInteger currentIndex =[inputViews indexOfObject:[self findFirstResponder:uiview]];
    if(currentIndex<inputViews.count&&![tdelegate next:[inputViews objectAtIndex:currentIndex]]){
        return;
    }
    NSUInteger nextIndex = currentIndex + 1;
    nextIndex += [inputViews count];
    nextIndex %= [inputViews count];
    
    UITextField *nextTextField = [inputViews objectAtIndex:nextIndex];
    
    [nextTextField becomeFirstResponder];
    
}

+(void) prevTextField {
    NSUInteger currentIndex = [inputViews indexOfObject:[self findFirstResponder:uiview]];
    if(currentIndex<inputViews.count&&![tdelegate prev:[inputViews objectAtIndex:currentIndex]]){
        return;
    }
    NSUInteger prevIndex = currentIndex - 1;
    prevIndex += [inputViews count];
    prevIndex %= [inputViews count];
    
    UITextField *nextTextField = [inputViews objectAtIndex:prevIndex];
    
    [nextTextField becomeFirstResponder];
    
}

+(UIView*) findFirstResponder:(UIView *)view {
    
    if (view.isFirstResponder) return view;
    for (UIView *subView in view.subviews) {
        UIView *firstResponder = [self findFirstResponder:subView];
        if (firstResponder != nil) return firstResponder;
    }
    return nil;
    
}

+(void) textFieldDone {
    [[self findFirstResponder:uiview] resignFirstResponder];
    
}

#pragma mark - UITextViewDelegate

+(BOOL) textView : (UITextView*) textView shouldChangeTextInRange : (NSRange) range replacementText : (NSString*) text {
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - UITextFieldDelegate

+(BOOL) textFieldShouldReturn : (UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
}




@end
