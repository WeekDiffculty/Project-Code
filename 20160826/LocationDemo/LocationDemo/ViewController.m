//
//  ViewController.m
//  LocationDemo
//
//  Created by qingyun on 16/8/26.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "QYAnnotation.h"

@interface ViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>

//位置管理器
@property (nonatomic, strong)CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    //申请授权,如果用户没有选择过
    if ([CLLocationManager authorizationStatus]== kCLAuthorizationStatusNotDetermined) {
        //发出当应用在前台使用的时候的授权
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    //更新频率
    self.locationManager.distanceFilter = 10.f;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //定位服务是否可用
    if ([CLLocationManager locationServicesEnabled]) {
        //如果可用ose,就开启定位
        [self.locationManager startUpdatingLocation];
    }else{
        //暂停定位
    }
    
    //设置mapView的delegate
    self.mapView.delegate = self;
    
    //修改地图的类型
//    self.mapView.mapType = MKMapTypeSatellite;
    
    
    
}

#pragma mark - delegate

//授权状态的改变
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"%d", status);
}

//定位到位置
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"%@", locations);
    CLLocation *location = locations.lastObject;
    //如果水平精度过差,则放弃该点
    if (location.horizontalAccuracy > kCLLocationAccuracyHundredMeters) {
        return;
    }
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    //把地图调整到定位的区域
    //定位到的点作为中心点
    //设定一个跨度
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    //构造区域
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    //将地图调整到该区域
    [self.mapView setRegion:region animated:YES];
    
    //添加一个系统标注点
//    
//    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//    point.coordinate = coordinate;
//    
//    //添加被地图的应用
//    [self.mapView addAnnotation:point];
    
    
    //添加一个自定义标注点
    QYAnnotation *anno = [[QYAnnotation alloc] init];
    anno.coordinate = coordinate;
    anno.title = @"香港";
    anno.subtitle = @"就在这";
    
    [self.mapView addAnnotation:anno];
    
}

//发生错误的时候
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@", error);
}

#pragma mark - map delegate

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    MKCoordinateRegion region = self.mapView.region;
    NSLog(@"区域改变");
}

//返回标注视图的delegate
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[QYAnnotation class]]) {
        //判断是我们自己添加的标注数据,则处理对应的视图
        //定义一个复用用的字符串
        static NSString *indentfire = @"qyannotaion";
        //调用复用方法
        MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:indentfire];
        //如果复用队列中没有
        if (!view) {
            view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:indentfire];
        }
        
        view.annotation = annotation;//绑定数据
        view.image = [UIImage imageNamed:@"iconpng"];
        view.centerOffset = CGPointMake(0, -15);//内容的偏移
        view.canShowCallout = YES;//显示 callout;
        return view;
    }
    return nil;
}

//callout delegate

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSLog(@"%@", view);
}

@end
