//
//  GraphicObject.h
//  iOBJ
//
//  Created by Silvio Fragnani da Silva on 08/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mesh.h"
#import "Shader.h"

@interface GraphicObject : NSObject
{
    Shader * _shader;
    Mesh   * _mesh;
}

@property (nonatomic, retain) Shader * shader;
@property (nonatomic, retain) Mesh   * mesh;

- (void)update;
- (void)draw;

@end
