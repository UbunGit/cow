//
//  UIImage+CYY.h
//  CYYComponent
//
//  Created by michan on 2021/7/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, CYYGradientType) {
    
    GradientTypeTopToBottom = 0,//从上到小
    GradientTypeLeftToRight = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
};

@interface UIImage (CYY)

/**
 设置图片渐变色
 */
+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(CYYGradientType)gradientType imgSize:(CGSize)imgSize;



@end

NS_ASSUME_NONNULL_END
