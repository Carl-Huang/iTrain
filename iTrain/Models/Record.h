//
//  Record.h
//  iTrain
//
//  Created by Interest on 14-9-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Record : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * starttime;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSString * weekday;
@property (nonatomic, retain) NSString * part;
@property (nonatomic, retain) NSString * year;

@end
