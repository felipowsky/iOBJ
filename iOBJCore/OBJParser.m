//
//  OBJParser.m
//  iOBJ
//
//  Created by Felipe Imianowsky on 03/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OBJParser.h"

@interface OBJParser ()

@property(retain) NSData *data;

- (void)parseLine:(NSString *)line toMesh:(Mesh **)mesh;
- (NSString *)nextWordFromLine:(NSString *)line withScanner:(NSScanner **)scanner;

@end

@implementation OBJParser

@synthesize data = _data;

- (id)initWithData:(NSData *)data
{
    self = [super init];
    
    if (self) {
        self.data = data;
    }
    
    return self;
}

- (Mesh *)parseAsObject
{
    NSString *objString = [[NSString alloc] initWithData:self.data encoding:NSASCIIStringEncoding];
    NSArray *lines = [objString componentsSeparatedByString:@"\n"];
    
    Mesh *mesh = [[Mesh alloc] init];
    
    for (NSString *line in lines) {
        
        NSString *lineWithoutComments = [[line componentsSeparatedByString:@"#"] objectAtIndex:0];
        [self parseLine:lineWithoutComments toMesh:&mesh];
    }
    
    return mesh;
}

- (void)parseLine:(NSString *)line toMesh:(Mesh **)mesh
{
    NSScanner *scanner = [NSScanner scannerWithString:line];
    NSString *word = [self nextWordFromLine:line withScanner:&scanner];
    
    if (word != nil) {
        
        if ([word isEqualToString:@"v"]) {
            double x = 0.0;
            double y = 0.0;
            double z = 0.0;
            
            [scanner scanDouble:&x];
            [scanner scanDouble:&y];
            [scanner scanDouble:&z];
            
            [(*mesh).vertices addObject:[[Point3D alloc] initWith:x y:y z:z]];
        }
        
    }
}

- (NSString *)nextWordFromLine:(NSString *)line withScanner:(NSScanner **)scanner
{
    NSString *word = nil;
    [*scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&word];
    
    return word;
}

@end
