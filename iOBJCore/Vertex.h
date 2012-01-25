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
}

@property (strong, nonatomic) Point3D *point;
@property (strong, nonatomic) Vector3D *normal;

- (id)initWithPoint:(Point3D *)point normal:(Vector3D *)normal;

@end
