//
//  AppDelegate.h
//  CoreDataDemo
//
//  Created by qingyun on 16/9/1.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//core data 对象上下文
@property (strong, nonatomic) NSManagedObjectContext *context;


@end

