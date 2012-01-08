//
//  OBJParser.h
//  iOBJ
//
//  Created by Felipe Imianowsky on 03/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mesh.h"
#import "Point3D.h"
#import "Face.h"
#import "Vertex.h"

@interface OBJParser : NSObject
{
@private
    NSData *_data;
}

- (id)initWithData:(NSData *)data;
- (Mesh *)parseAsObject;

@end
