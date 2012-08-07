//
//  DataParser.h
//  iOBJ
//
//  Created by felipowsky on 07/08/12.
//
//

#import <Foundation/Foundation.h>

@interface DataParser : NSObject

- (id)initWithData:(const NSData *)data;
- (NSString *)nextWordWithScanner:(const NSScanner *)scanner;

@end
