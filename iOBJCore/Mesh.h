//
//  Mesh.h
//  iOBJ
//
//  Created by Felipe Imianowsky on 03/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Point3D.h"
#import "Vector3D.h"

@interface Mesh : NSObject
{
@private
    NSMutableArray *_vertices;
    NSMutableArray *_normals;
    NSMutableArray *_faces;
}

@property (nonatomic, strong) NSMutableArray *vertices;
@property (nonatomic, strong) NSMutableArray *normals;
@property (nonatomic, strong) NSMutableArray *faces;

- (id)init;

@end
