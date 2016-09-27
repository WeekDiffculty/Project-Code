//
//  AppDelegate.h
//  LeanCloudClint
//
//  Created by qingyun on 16/8/16.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloudIM/AVOSCloudIM.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AVIMClient *client;


//切换到首页
-(void)change2HomeVC;

@end

