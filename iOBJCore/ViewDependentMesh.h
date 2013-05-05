//
//  ViewDependentMesh.h
//  iOBJ
//
//  Created by felipowsky on 19/03/13.
//
//

#import <Foundation/Foundation.h>

@class GraphicObject, Mesh, Camera;

@interface ViewDependentMesh : NSObject

- (id)initWithGraphicObject:(GraphicObject *)graphicObject;
- (Mesh *)generateMeshWithCamera:(Camera *)camera;

@end
