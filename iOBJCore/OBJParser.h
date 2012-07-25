//
//  OBJParser.h
//  iOBJ
//
//  Created by Felipe Imianowsky on 03/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mesh.h"

@interface OBJParser : NSObject

- (id)initWithData:(const NSData *)data;
- (Mesh *)parseAsObject;
- (void)parseAsObjectWithMesh:(const Mesh *)mesh;

@end
