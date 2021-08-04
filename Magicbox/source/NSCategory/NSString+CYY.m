//
//  NSString+CYY.m
//  CYYComponent
//
//  Created by michan on 2021/7/30.
//

#import "NSString+CYY.h"
#import <sys/sysctl.h>
#include <CommonCrypto/CommonCrypto.h>

@implementation NSString (CYY)
- (NSString *)encodeURL
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                (CFStringRef) self,
                                                                NULL,
                                                                (CFStringRef) @"!*'\\()+,;:@&=+$,\"/?%#`<>[]{}~ ",
                                                                kCFStringEncodingUTF8));
}
- (NSString *)decodeURL
{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}
- (NSString *)mb_md52
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
