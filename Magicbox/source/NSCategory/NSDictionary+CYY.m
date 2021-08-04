//
//  NSDictionary+CYY.m
//  CYYComponent
//
//  Created by michan on 2021/7/30.
//

#import "NSDictionary+CYY.h"

@implementation NSDictionary (CYY)
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}

@end
