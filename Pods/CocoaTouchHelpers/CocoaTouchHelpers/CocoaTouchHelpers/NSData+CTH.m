//
//  NSData+CTH.m
//

#import "NSData+CTH.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSData (CTHData)

- (NSString *)md5
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG) self.length, result);
    
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

- (NSString *)hexadecimalString
{
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    
    if (!dataBuffer) {
        return [NSString string];
    }
    
    NSUInteger dataLength = [self length];
    NSMutableString *hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i) {
        [hexString appendFormat:@"%02lx", (unsigned long)dataBuffer[i]];
    }
    
    return hexString;
}

@end
