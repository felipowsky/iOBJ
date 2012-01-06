//
//  Point3D.h
//  iOBJ
//
//  Created by Felipe Imianowsky on 05/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Point3D : NSObject
{
@private
    double _x;
    double _y;
    double _z;
}

- (id)initWith:(double)x y:(double)y z:(double)z;

@end
