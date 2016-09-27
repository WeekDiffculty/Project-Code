 //
//  SiiderslipVC.m
//  Siderslip
//
//  Created by qingyun on 16/8/25.
//  Copyright © 2016年 qingyun. All rights reserved.
//
#import "SiderslipVC.h"

typedef enum : NSUInteger {
    kFrontPositionLeft,
    kFrontPositionRight
} FrontPosition;


@interface SiderslipVC ()

@property (nonatomic)FrontPosition position;//前面控制器所在的位置
@property (nonatomic)CGFloat rightWidth;//右边的宽度
@property (nonatomic, strong)UITapGestureRecognizer *tap;//点击手势
@property (nonatomic, strong)UIPanGestureRecognizer *pan;//滑动手势

@end

@implementation SiderslipVC

-(instancetype)initWithRearVC:(UIViewController *)rearVC FrontVC:(UIViewController *)frontVC{
    if (self = [super init]) {
        _rearVC  = rearVC;
        _frontVC = frontVC;
        
        //添加子控制器关系
        [self addChildViewController:_rearVC];
        [self addChildViewController:_frontVC];
    }
    return self;
}

-(void)loadView{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //前面控制器默认的位置
    self.position = kFrontPositionLeft;
    self.rightWidth = 60;//控制器滑动到右边,剩余的宽度
    //操作的手势
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    //添加子VCview
    [self addChildView];
}

-(void)addChildView{
    [self.view addSubview:self.rearVC.view];
    [self.view addSubview:self.frontVC.view];
    
    //添加手势
    [self.frontVC.view addGestureRecognizer:self.tap];
    [self.frontVC.view addGestureRecognizer:self.pan];
}

//当view大小调整完成后,调整子控制器View
-(void)viewDidLayoutSubviews{
    [self layoutChildView];
}

//调整子控制器的View
-(void)layoutChildView{
    //调整后面控制器
    self.rearVC.view.frame = self.view.bounds;
    
    //调整前面的控制器
    if (self.position == kFrontPositionLeft) {
        self.frontVC.view.frame = self.view.bounds;
    }else {
        CGFloat left = self.view.frame.size.width - 60;
        //偏移
        self.frontVC.view.frame = CGRectOffset(self.view.bounds, left, 0);
    }
    
}

//手势事件
-(void)tapAction:(UITapGestureRecognizer *)gesture{
    if (self.position == kFrontPositionRight) {
        self.position = kFrontPositionLeft;
        
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutChildView];
        }];
    }
}

//滑动手势
-(void)panAction:(UIPanGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        //相对该View,拖拽了多少
        CGPoint point = [gesture translationInView:self.view];
        //计算出开始位置
        if (self.position == kFrontPositionLeft) {
            _frontVC.view.frame = CGRectOffset(self.view.bounds, point.x, 0);
        }else{
            
            CGFloat left = self.view.frame.size.width - 60;
            //右边的起始位置
            CGRect frame = CGRectOffset(self.view.bounds, left, 0);
            
            _frontVC.view.frame = CGRectOffset(frame, point.x, 0);
            
        }

    }else if (gesture.state == UIGestureRecognizerStateEnded){
        CGFloat left = self.view.frame.size.width - 60;
        CGFloat center = left/2;
        if (_frontVC.view.frame.origin.x > center) {
            //将前面控制器条整到右面
            self.position = kFrontPositionRight;
        }else{
            self.position = kFrontPositionLeft;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutChildView];
        }];
        
        
    }else{
        
    };
   
    
}


@end
