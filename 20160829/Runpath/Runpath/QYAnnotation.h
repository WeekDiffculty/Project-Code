//
//  QYAnnotation.h
//  Runpath
//
//  Created by qingyun on 16/8/29.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum : NSUInteger {
    kAnnotationBegin,
    kAnnotationNow,
    kAnnotationPause,
    kAnnotationEnd
} AnnotationType;

@interface QYAnnotation : NSObject<MKAnnotation>

//遵守的annotation协议
@property (nonatomic)CLLocationCoordinate2D coordinate;
@property (nonatomic)AnnotationType type;

@end
