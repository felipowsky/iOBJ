//
//  DataParser.h
//  iOBJ
//
//  Created by felipowsky on 07/08/12.
//
//

#import <Foundation/Foundation.h>

@interface DataParser : NSObject

@property (nonatomic, strong, readonly) NSData *data;
@property (nonatomic, strong, readonly) NSString *filename;

- (id)initWithData:(NSData *)data;
- (id)initWithFilename:(NSString *)filename ofType:(NSString *)type;
- (NSString *)nextWordWithScanner:(NSScanner *)scanner;

@end
