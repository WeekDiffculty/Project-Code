//
//  SiiderslipVC.h
//  Siderslip
//
//  Created by qingyun on 16/8/25.
//  Copyright © 2016年 qingyun. All rights reserved.
//


//侧滑框架
#import <UIKit/UIKit.h>

@interface SiderslipVC : UIViewController

@property (nonatomic, strong)UIViewController *rearVC;//后面的控制器
@property (nonatomic, strong)UIViewController *frontVC;//前面的控制器

//初始化方法
-(instancetype)initWithRearVC:(UIViewController *)rearVC FrontVC:(UIViewController *)frontVC;

@end
