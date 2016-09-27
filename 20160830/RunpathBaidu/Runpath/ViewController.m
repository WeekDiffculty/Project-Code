//
//  ViewController.m
//  Runpath
//
//  Created by qingyun on 16/8/29.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "QYAnnotation.h"

@interface ViewController ()<CLLocationManagerDelegate, BMKMapViewDelegate>

@property (nonatomic,strong)CLLocationManager *locationManager;//定位的管理类


@property (nonatomic, strong)CLLocation *nowLocation;
@property (nonatomic, strong)QYAnnotation *nowAnnotation;//当前位置的标注点
@property (nonatomic, strong)NSMutableArray *allLocations;//所经过的所有的点
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //配置location manager
    [self createdLocationManager];

    self.allLocations = [NSMutableArray array];
    
    
    self.mapView.delegate = self;
}

-(void)createdLocationManager{
    //配置locationmanager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    //申请授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    //配置定位的属性
    self.locationManager.distanceFilter = 10.f;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)begin:(id)sender {
    [self.locationManager startUpdatingLocation];
}
- (IBAction)pause:(id)sender {
    //停止定位
    [self.locationManager stopUpdatingLocation];
    //用当前位置,添加一个暂停的标注
    QYAnnotation *anno = [[QYAnnotation alloc] init];
    anno.coordinate = self.nowLocation.coordinate;//当前位置点
    anno.type = kAnnotationPause;//设置点的类型
    [self.mapView addAnnotation:anno];
}
- (IBAction)end:(id)sender {
    
    [self.locationManager stopUpdatingLocation];
    
    //用当前位置添加一个结束的标注
    QYAnnotation *anno = [[QYAnnotation alloc] init];
    anno.coordinate = self.nowLocation.coordinate;
    anno.type = kAnnotationEnd;
    [self.mapView addAnnotation:anno];
    
}

#pragma mark - location delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //取返回数据的最后一个
    CLLocation *location = locations.lastObject;
    //排除一些无效的点
    if (location.horizontalAccuracy > 1000 || location.horizontalAccuracy < 0) {
        //精确度太差
        return;
    }
    
    //如果属性不存在,则之前没有返回过点
    if (!self.nowLocation) {
        //设置地图的显示区域
        BMKCoordinateSpan span;
        span.latitudeDelta = 0.05;
        span.longitudeDelta = 0.05;
        BMKCoordinateRegion rengion;
        rengion.center = location.coordinate;
        rengion.span = span;
        [self.mapView setRegion:rengion animated:YES];
        
        //第一个点为开始点
        QYAnnotation *bengin = [[QYAnnotation alloc] init];
        bengin.coordinate = location.coordinate;
        bengin.type = kAnnotationBegin;
        [self.mapView addAnnotation:bengin];
    }
    
    QYAnnotation *nowAnno = [[QYAnnotation alloc] init];
    nowAnno.coordinate = location.coordinate;
    nowAnno.type = kAnnotationNow;
    [self.mapView addAnnotation:nowAnno];
    
    //删除上一次的当前位置点
    if (self.nowAnnotation) {
        [self.mapView removeAnnotation:self.nowAnnotation];
    }
    //保留用作下一次取消
    self.nowAnnotation = nowAnno;
    
    
    
    NSLog(@"%@", location);
    self.nowLocation = location;
    //将所有的点保存
    [self.allLocations addObject:location];
    
    //初始化覆盖层模型对象
    //声明一个结构体数组
    CLLocationCoordinate2D *coors = malloc(sizeof(CLLocationCoordinate2D) * self.allLocations.count);
    for (NSUInteger index = 0; index < self.allLocations.count; index ++) {
        //填充数组
        coors[index] = [self.allLocations[index] coordinate];
    }
    //曲线覆盖层数据
    BMKPolyline *line = [BMKPolyline polylineWithCoordinates:coors count:self.allLocations.count];
    [self.mapView addOverlay:line];
    
}

#pragma mark - mapkit delegate

//返回标注视图的delegate方法
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[QYAnnotation class]]) {
        //定义复用的标识符
        static NSString *identifier = @"qyAnnotaion";
        QYAnnotation *anno = (QYAnnotation *)annotation;
        BMKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!view) {
            view = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        //绑定数据
        switch (anno.type) {
            case kAnnotationBegin:
            {
                view.image = [UIImage imageNamed:@"map_start_icon"];
                view.centerOffset = CGPointMake(0, -12);
            }
                break;
            case kAnnotationNow:
            {
                view.image = [UIImage imageNamed:@"currentlocation"];
                view.centerOffset = CGPointZero;
            }
                break;
            case kAnnotationPause:
            {
                view.image = [UIImage imageNamed:@"map_susoend_icon"];
                view.centerOffset = CGPointMake(0, -12);
            }
                break;
            case kAnnotationEnd:{
                view.image = [UIImage imageNamed:@"map_stop_icon"];
                view.centerOffset = CGPointMake(0, -12);
                
            }
                
            default:
                break;
        }
        
        return view;
    }
    return nil;
}

//返回覆盖层视图
-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    //判断模型数据的类型
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        //曲线的渲染图层
        //BMKPolyline *renderer = [[BMKPolyline alloc] init];
        //设置曲线的线宽,颜色
//        renderer.lineWidth = 3.0;
//        renderer.strokeColor = [UIColor blueColor];
        //[BMKPolyline polylineWithCoordinates:(__bridge CLLocationCoordinate2D *)(overlay) count:1000000];
        BMKPolylineView *view = [[BMKPolylineView alloc] initWithOverlay:overlay];
        view.lineWidth = 3.f;
        view.strokeColor = [UIColor blueColor];
        
        return view;
    }
    return nil;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.mapView  viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
@end
