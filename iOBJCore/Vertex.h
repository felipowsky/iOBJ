//
//  Vertex.h
//  iOBJ
//
//  Created by Felipe Imianowsky on 08/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Point3D.h"
#import "Vector3D.h"

@interface Vertex : NSObject
{
@private
    Point3D *_point;
    Vector3D *_normal;
}

@property(nonatomic,retain) Point3D *point;
@property(nonatomic,retain) Vector3D *normal;

- (id)initWithPoint:(Point3D *)point normal:(Vector3D *)normal;

@end
