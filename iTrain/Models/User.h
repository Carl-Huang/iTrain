//
//  User.h
//  iTrain
//
//  Created by Interest on 14-9-16.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * hzIndex;
@property (nonatomic, retain) NSNumber * isChoose;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSNumber * speedIndex;
@property (nonatomic, retain) NSNumber * strongIndex;
@property (nonatomic, retain) NSNumber * uzIndex;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * unit;
@property (nonatomic, retain) NSNumber * feet;
@property (nonatomic, retain) NSNumber * pound;

@end
