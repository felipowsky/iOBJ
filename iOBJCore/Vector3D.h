//
//  Vector3D.h
//  iOBJ
//
//  Created by Felipe Imianowsky on 08/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vector3D : NSObject
{
@private
    double _x;
    double _y;
    double _z;
}

@property(nonatomic) double x;
@property(nonatomic) double y;
@property(nonatomic) double z;

- (id)initWith:(double)x y:(double)y z:(double)z;

@end
