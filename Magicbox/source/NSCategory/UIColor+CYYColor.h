//
//  UIColor+CYYColor.h
//  CYYComponent
//
//  Created by michan on 2021/7/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (CYYColor)

/**
 *
 *color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 */
+(UIColor*)mb_ColorFromRGB:(NSString *)color;

@end

NS_ASSUME_NONNULL_END
