//
//  ViewController.m
//  QRCode
//
//  Created by qingyun on 16/8/15.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

/** 设备 */
@property (nonatomic, strong)AVCaptureDevice *device;
/** 输入 */
@property(nonatomic, strong)AVCaptureDeviceInput *input;
/** 会话 */
@property (nonatomic, strong)AVCaptureSession *session;
/** 输出 */
@property (nonatomic, strong)AVCaptureMetadataOutput *output;
/** 预览内容 */
@property (weak, nonatomic) IBOutlet UIView *preView;
/** 扫描部分 */
@property (weak, nonatomic) IBOutlet UIImageView *boardImageView;
/** 动画的图片 */
@property (weak, nonatomic) IBOutlet UIImageView *inamationView;
/** 计时器 */
@property (nonatomic, strong)NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //配置UI效果
    UIImage *boardimage = [UIImage imageNamed:@"qrcode_border"];
    //调整为大小可变的图片
    
    UIImage *reBoardImage = [boardimage resizableImageWithCapInsets:UIEdgeInsetsMake(25, 25, 26, 26)];
    self.boardImageView.image = reBoardImage;
    
    //添加动画的视图
    [self.boardImageView addSubview:self.inamationView];
    UIImage *inamationImage = [UIImage imageNamed:@"qrcode_scanline_qrcode"];
    [self.inamationView setImage:inamationImage];
    
    
//    self.inamationView.frame = CGRectZero;
//    self.inamationView.bounds = self.boardImageView.bounds;
    //剪切掉子视图,超出区域
    self.boardImageView.clipsToBounds = YES;
    
}


-(void)changeInamation:(NSTimer *)timer{
    //改变ImageVIew的frame
    self.inamationView.frame = CGRectOffset(self.inamationView.frame, 0, 2);
    if (self.inamationView.frame.origin.y >= self.boardImageView.frame.size.height) {
        self.inamationView.frame = CGRectOffset(self.inamationView.bounds, 0, -self.inamationView.bounds.size.height);
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self startReading];
    self.inamationView.frame = self.boardImageView.bounds;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeInamation:) userInfo:nil repeats:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self stopRead];
}

//开启二维码
-(void)startReading{
    
    //首先得到device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建input
    NSError *error;
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    //创建output
    self.output = [[AVCaptureMetadataOutput alloc] init];
    
    dispatch_queue_t queue = dispatch_queue_create("myQuue", NULL);
    [self.output setMetadataObjectsDelegate:self queue:queue];
    //创建session
    self.session = [[AVCaptureSession alloc] init];
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    
    //设置output的选择的输出类型
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    //创建预览layer
    AVCaptureVideoPreviewLayer *layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [layer setFrame:self.view.layer.bounds];
    [self.preView.layer addSublayer:layer];
    //开启扫描
    [self.session startRunning];

}

//结束二维码
-(void)stopRead{
    //结束扫描
    [self.session stopRunning];
}

#pragma mark - metadata delegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count == 0) {
        return;
    }
    //接收到二维码对象
    AVMetadataMachineReadableCodeObject *code = metadataObjects.firstObject;
    NSLog(@"code:%@", code.stringValue);
    //通知主线程,停止扫描
    [self performSelectorOnMainThread:@selector(stopRead) withObject:nil waitUntilDone:NO];
}

@end
