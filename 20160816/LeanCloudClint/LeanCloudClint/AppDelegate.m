//
//  AppDelegate.m
//  LeanCloudClint
//
//  Created by qingyun on 16/8/16.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //初始化appkey
    [AVOSCloud setApplicationId:@"QRJwvd0YcdbAlX0Qaz7V20mH-gzGzoHsz" clientKey:@"XaKgCXWaNkhPWc2fxE6FxgLD"];
    
    
//    AVObject *person = [AVObject objectWithClassName:@"Person"];
//    [person setObject:@"张三" forKey:@"name"];
//    [person setObject:@"25" forKey:@"age"];
//    [person saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!succeeded) {
//            NSLog(@"%@", error);
//        }else{
//            NSLog(@"保存成功");
//        }
//    }];
    
    
    return YES;
}

-(void)change2HomeVC{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *homeNav = [story instantiateViewControllerWithIdentifier:@"homenav"];
    self.window.rootViewController = homeNav;
    
    //初始化聊天的client
    self.client = [[AVIMClient alloc] initWithClientId:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
    //clint 上线
    [self.client openWithCallback:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }else{
            NSLog(@"client open success");
        }
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
