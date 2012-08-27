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
    GLKVector2 texture;
	GLKVector3 normal;
} Vertex;
