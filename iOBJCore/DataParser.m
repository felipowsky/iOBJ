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
@property (nonatomic, strong) NSString *filename;

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
        
        self.data = [content dataUsingEncoding:NSASCIIStringEncoding];
        self.filename = filename;
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
