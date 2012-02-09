//
//  Mesh.m
//  iOBJ
//
//  Created by Felipe Imianowsky on 03/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Mesh.h"

@interface Mesh ()
{
    Point3D *_vertices;
    unsigned int _verticesLength;
    Vector3D *_normals;
    unsigned int _normalsLength;
    Face *_faces;
    unsigned int _facesLength;
    GLKVector3 *_triangleVertices;
    unsigned int _triangleVerticesLength;
}

- (void)addTriangleVertices:(Vertex[3])vertices;

@end

@implementation Mesh

@synthesize vertices = _vertices;
@synthesize verticesLength = _verticesLength;
@synthesize normals = _normals;
@synthesize normalsLength = _normalsLength;
@synthesize faces = _faces;
@synthesize facesLength = _facesLength;
@synthesize triangleVertices = _triangleVertices;
@synthesize triangleVerticesLength = _triangleVerticesLength;

- (id)init
{
    self = [super init];
    
    if (self) {
        _verticesLength = 0;
        _vertices = (Point3D*) malloc(0);
        _normals = (Vector3D*) malloc(0);
        _normalsLength = 0;
        _faces = (Face*) malloc(0);
        _facesLength = 0;
        _triangleVertices = (GLKVector3*) malloc(0);
        _triangleVerticesLength = 0;
    }
    
    return self;
}

- (void)addVertex:(Point3D)vertex
{
    void *newVertices = realloc(self.vertices, (self.verticesLength+1) * sizeof(Point3D));
    
    if (newVertices) {
        _vertices = (Point3D*)newVertices;
        self.vertices[self.verticesLength] = vertex;
        _verticesLength++;
        
    } else {
        NSLog(@"Couldn't realloc memory to vertices");  
    }
}

- (void)addNormal:(Vector3D)normal
{
    void *newNormals = realloc(self.normals, (self.normalsLength+1) * sizeof(Vector3D));
    
    if (newNormals) {
        _normals = (Vector3D*)newNormals;
        self.normals[self.normalsLength] = normal;
        _normalsLength++;
        
    } else {
        NSLog(@"Couldn't realloc memory to normals");  
    }
}

- (void)addFace:(Face)face
{
    void *newFaces = realloc(self.faces, (self.facesLength+1) * sizeof(Face));
    
    if (newFaces) {
        _faces = (Face*)newFaces;
        self.faces[self.facesLength] = face;
        _facesLength++;
        
        [self addTriangleVertices:face.vertices];
        
    } else {
        NSLog(@"Couldn't realloc memory to faces");  
    }
}

- (void)addTriangleVertices:(Vertex[3])vertices
{
    void *newTriangleVertices = realloc(self.triangleVertices, (self.triangleVerticesLength+3) * sizeof(GLKVector3));
    
    if (newTriangleVertices) {
        _triangleVertices = (GLKVector3*)newTriangleVertices;
        Point3D point = vertices[0].point;
        self.triangleVertices[self.triangleVerticesLength] = GLKVector3Make(point.x, point.y, point.z);
        point = vertices[1].point;
        self.triangleVertices[self.triangleVerticesLength+1] = GLKVector3Make(point.x, point.y, point.z);
        point = vertices[2].point;
        self.triangleVertices[self.triangleVerticesLength+2] = GLKVector3Make(point.x, point.y, point.z);
        _triangleVerticesLength += 3;
        
    } else {
        NSLog(@"Couldn't realloc memory to triangle vertices");  
    }
}

- (void)dealloc
{
    free(self.vertices);
    free(self.normals);
    free(self.faces);
    free(self.triangleVertices);
}

@end
