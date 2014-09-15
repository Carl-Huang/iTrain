//
//  DaiDodgeKeyboard.h
//  DaiDodgeKeyboard
//
//  Created by 啟倫 陳 on 2014/4/25.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol KeyboardDelegate

-(NSArray*)inputArray;
-(Boolean)prev:(UIView *)view;
-(Boolean)next:(UIView *)view;
@end

@interface DaiDodgeKeyboard: NSObject<UITextFieldDelegate, UITextViewDelegate>{
    id<KeyboardDelegate> delegate;
}

+(void) addRegisterTheViewNeedDodgeKeyboard : (UIView*) view inputViewDelegate:(id<KeyboardDelegate>) detegate;
+(void) removeRegisterTheViewNeedDodgeKeyboard;
+(void) textFieldDone;
+(void) nextTextField;
+(UIView*) findFirstResponder:(UIView *)view;
@end

