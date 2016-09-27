//
//  ViewController.m
//  LocalNotificationDemo
//
//  Created by qingyun on 16/8/18.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)addnotification:(id)sender {
    
    //初始化一个通知对象
    UILocalNotification *notifi = [[UILocalNotification alloc] init];
    //通知时间
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:10];
    notifi.fireDate = date;
    
    //时间的结构化的对象
//    NSDateComponents *comp = [[NSDateComponents alloc] init];
//    comp.year = 2016;
//    comp.month = 8;
//    comp.day = 18;
//    comp.hour = 11;
//    comp.minute = 59;
//    
//    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comp];
//    notifi.fireDate = date;
    
    
    //通知的循环周期
    notifi.repeatInterval = NSCalendarUnitDay;
    //循环所依照的日历
    notifi.repeatCalendar = [NSCalendar currentCalendar];
    
    
    //通知的内容
    notifi.alertBody = @"妈妈叫你回家吃饭了!";
    notifi.alertAction = @"回家";
    //icon
    notifi.applicationIconBadgeNumber = 10;
    //声音,使用默认声音
    notifi.soundName = UILocalNotificationDefaultSoundName;
    //自定义的数据,自定义的数据
    notifi.userInfo = @{@"foo":@"bor"};
    
    //告诉系统,添加这个提醒
    [[UIApplication sharedApplication] scheduleLocalNotification:notifi];
    
//    [[UIApplication sharedApplication] cancelLocalNotification:notifi]

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
