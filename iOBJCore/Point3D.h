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
}

@property(nonatomic) double x;
@property(nonatomic) double y;
@property(nonatomic) double z;

- (id)initWith:(double)x y:(double)y z:(double)z;

@end
