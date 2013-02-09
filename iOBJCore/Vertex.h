//
//  Vertex.h
//  iOBJ
//
//  Created by felipowsky on 09/08/12.
//
//

#import <GLKit/GLKit.h>

typedef struct {
	GLKVector3 point;
    int pointIndex;
    GLKVector2 texture;
    int textureIndex;
	GLKVector3 normal;
    int normalIndex;
} Vertex;
