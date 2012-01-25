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
}

@property (strong, nonatomic) NSMutableArray *vertices;
@property (strong, nonatomic) NSMutableArray *normals;
@property (strong, nonatomic) NSMutableArray *faces;

- (id)init;

@end
