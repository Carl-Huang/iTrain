//
//  Plan.h
//  iTrain
//
//  Created by Interest on 14-9-11.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Plan : NSManagedObject

@property (nonatomic, retain) NSString * part;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSString * eventId;

@end
