//
//  NSString+CYY.h
//  CYYComponent
//
//  Created by michan on 2021/7/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CYY)
- (NSString *)encodeURL;
- (NSString *)decodeURL;

//md5 加密
- (NSString *)mb_md52;

@end

NS_ASSUME_NONNULL_END
