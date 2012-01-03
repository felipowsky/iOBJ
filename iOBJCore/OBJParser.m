//
//  OBJParser.m
//  iOBJ
//
//  Created by Felipe Imianowsky on 03/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OBJParser.h"

@interface OBJParser ()
{
}
@property(retain) NSData *data;
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
    return [[Mesh alloc] init];
}

@end
