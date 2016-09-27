//
//  QYAnnotation.h
//  LocationDemo
//
//  Created by qingyun on 16/8/26.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface QYAnnotation : NSObject<MKAnnotation>

//位置点方法
@property (nonatomic)CLLocationCoordinate2D coordinate;

//标题和子标题
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *subtitle;

@end
