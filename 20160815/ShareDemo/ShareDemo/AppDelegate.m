//
//  AppDelegate.m
//  ShareDemo
//
//  Created by Xionghaizi on 16/8/15.
//  Copyright © 2016年 Xionghaizi. All rights reserved.
//

#import "AppDelegate.h"
#import <UMSocial.h>
#import <UMSocialSinaSSOHandler.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

//应用程序回调,当被其它应用打开我们自己的应用
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //设置umeng的appkey
    [UMSocialData setAppKey:@"57b128fee0f55afbf50026ab"];
    
    
//    配置微博的app信息
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2932605406"
                                              secret:@"611d8fb40b766af146a51749a08e3c4f"
                                         RedirectURL:@"https://api.weibo.com/oauth2/default.html"];
    
    return YES;
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
