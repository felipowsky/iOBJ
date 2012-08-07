//
//  DataParser.m
//  iOBJ
//
//  Created by felipowsky on 07/08/12.
//
//

#import "DataParser.h"

@interface DataParser ()

@property (nonatomic, strong) NSData *data;

@end

@implementation DataParser

- (id)initWithData:(const NSData *)data
{
    self = [super init];
    
    if (self) {
        self.data = [data copy];
    }
    
    return self;
}

- (NSString *)nextWordWithScanner:(const NSScanner *)scanner
{
    NSString *word = nil;
    [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&word];
    
    return word;
}

@end
