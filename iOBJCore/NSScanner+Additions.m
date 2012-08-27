//
//  NSScanner+Additions.m
//  iOBJ
//
//  Created by felipowsky on 26/08/12.
//
//

#import "NSScanner+Additions.h"

@implementation NSScanner (Additions)

- (BOOL)scanWord:(NSString **)word
{
    return [self scanUpToCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:word];;
}

@end
