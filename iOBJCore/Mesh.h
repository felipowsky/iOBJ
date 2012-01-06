//
//  Mesh.h
//  iOBJ
//
//  Created by Felipe Imianowsky on 03/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Point3D.h"

@interface Mesh : NSObject
{
@private
    NSMutableSet *_vertices;
}

@property(nonatomic,retain) NSMutableSet *vertices;

- (id)init;

@end
