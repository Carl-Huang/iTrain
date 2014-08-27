//
//  Device.h
//  RMControl
//
//  Created by Carl on 14-8-18.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Device : NSManagedObject

@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSString * showName;
@property (nonatomic, retain) NSString * imagePath;

@end
