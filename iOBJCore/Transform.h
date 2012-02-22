//
//  Transform.h
//  iOBJ
//
//  Created by felipowsky on 10/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Transform : NSObject
{
}

@property (nonatomic, readonly) GLKVector3 position;
@property (nonatomic, readonly) GLKVector3 rotation;
@property (nonatomic, readonly) GLKVector3 scale;

@end
