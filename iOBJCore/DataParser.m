//
//  DataParser.m
//  iOBJ
//
//  Created by felipowsky on 07/08/12.
//
//

#import "DataParser.h"

@implementation DataParser

- (id)initWithData:(NSData *)data
{
    self = [super init];
    
    if (self) {
        _data = data;
    }
    
    return self;
}

- (id)initWithFilename:(NSString *)filename ofType:(NSString *)type
{
    self = [super init];
    
    if (self) {
        NSString *pathFile = [[NSBundle mainBundle] pathForResource:filename ofType:type];
        
        NSError *error;
        NSString *content = [NSString stringWithContentsOfFile:pathFile encoding:NSASCIIStringEncoding error:&error];
        
#ifdef DEBUG
        if (error) {
            NSLog(@"Error initializing a data parser: %@", error);
        }
#endif
        
        _data = [content dataUsingEncoding:NSASCIIStringEncoding];
        _filename = filename;
    }
    
    return self;
}

@end
