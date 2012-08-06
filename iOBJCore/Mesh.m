//
//  Mesh.m
//  iOBJ
//
//  Created by felipowsky on 03/01/12.
//
//

#import "Mesh.h"

@implementation Mesh

- (id)init
{
    self = [super init];
    
    if (self) {
        _verticesLength = 0;
        _vertices = NULL;
        _normals = NULL;
        _normalsLength = 0;
        _faces = NULL;
        _facesLength = 0;
        _triangleVertices = NULL;
        _triangleVerticesLength = 0;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    Mesh *copy = [[Mesh allocWithZone:zone] init];
    
    if (self.verticesLength > 0) {
        for (int i = 0; i < self.verticesLength; i++) {
            [copy addVertex:self.vertices[i]];
        }
    }
    
    if (self.normalsLength > 0) {
        for (int i = 0; i < self.normalsLength; i++) {
            [copy addNormal:self.normals[i]];
        }
    }
    
    if (self.facesLength > 0) {
        for (int i = 0; i < self.facesLength; i++) {
            [copy addFace:self.faces[i]];
        }
    }
    
    if (self.triangleVerticesLength > 0) {
        for (int i = 0; i < self.triangleVerticesLength; i += 3) {
            GLKVector3 triangleVertex[3];
            
            triangleVertex[0] = self.triangleVertices[i];
            triangleVertex[1] = self.triangleVertices[i+1];
            triangleVertex[2] = self.triangleVertices[i+2];
            
            [copy addTriangleVerticesWithGLKVector:triangleVertex];
        }
    }
    
    return copy;
}

- (void)addVertex:(Point3D)vertex
{
    void *newVertices = NULL;
    
    if (self.vertices == NULL) {
        newVertices = malloc(sizeof(Point3D));
    
    } else {
        newVertices = realloc(self.vertices, (self.verticesLength+1) * sizeof(Point3D));
    }
    
    if (newVertices) {
        _vertices = (Point3D*)newVertices;
        self.vertices[self.verticesLength] = vertex;
        _verticesLength++;
        
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't realloc memory to vertices");  
    }
#endif
    
}

- (void)addNormal:(Vector3D)normal
{
    void *newNormals = NULL;
    
    if (self.normals == NULL) {
        newNormals = malloc(sizeof(Vector3D));
        
    } else {
        newNormals = realloc(self.normals, (self.normalsLength+1) * sizeof(Vector3D));
    }
    
    if (newNormals) {
        _normals = (Vector3D*)newNormals;
        self.normals[self.normalsLength] = normal;
        _normalsLength++;
        
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't realloc memory to normals");  
    }
#endif
}

- (void)addFace:(Face)face
{
    void *newFaces = NULL;
    
    if (self.faces == NULL) {
        newFaces = malloc(sizeof(Face));
        
    } else {
        newFaces = realloc(self.faces, (self.facesLength+1) * sizeof(Face));
    }
    
    if (newFaces) {
        _faces = (Face*)newFaces;
        self.faces[self.facesLength] = face;
        _facesLength++;
        
        [self addTriangleVertices:face.vertices];
        
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't realloc memory to faces");  
    }
#endif
}

- (void)addTriangleVertices:(Vertex[3])vertices
{
    void *newTriangleVertices = NULL;
    
    if (self.triangleVertices == NULL) {
        newTriangleVertices = malloc(sizeof(GLKVector3) * 3);
        
    } else {
        newTriangleVertices = realloc(self.triangleVertices, (self.triangleVerticesLength+3) * sizeof(GLKVector3));
    }
    
    if (newTriangleVertices) {
        _triangleVertices = (GLKVector3*)newTriangleVertices;
        Point3D point = vertices[0].point;
        self.triangleVertices[self.triangleVerticesLength] = GLKVector3Make(point.x, point.y, point.z);
        point = vertices[1].point;
        self.triangleVertices[self.triangleVerticesLength+1] = GLKVector3Make(point.x, point.y, point.z);
        point = vertices[2].point;
        self.triangleVertices[self.triangleVerticesLength+2] = GLKVector3Make(point.x, point.y, point.z);
        _triangleVerticesLength += 3;
        
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't realloc memory to triangle vertices");  
    }
#endif
}

- (void)addTriangleVerticesWithGLKVector:(GLKVector3[3])vertices
{
    void *newTriangleVertices = NULL;
    
    if (self.triangleVertices == NULL) {
        newTriangleVertices = malloc(sizeof(GLKVector3) * 3);
        
    } else {
        newTriangleVertices = realloc(self.triangleVertices, (self.triangleVerticesLength+3) * sizeof(GLKVector3));
    }
    
    if (newTriangleVertices) {
        _triangleVertices = (GLKVector3*)newTriangleVertices;
        self.triangleVertices[self.triangleVerticesLength] = vertices[0];
        self.triangleVertices[self.triangleVerticesLength+1] = vertices[1];
        self.triangleVertices[self.triangleVerticesLength+2] = vertices[2];
        _triangleVerticesLength += 3;
        
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't realloc memory to triangle vertices");  
    }
#endif
}

+ (Vector3D)flatNormalsWithFace:(Face)face
{
    Vector3D side1 = {
        face.vertices[1].point.x - face.vertices[0].point.x,
        face.vertices[1].point.y - face.vertices[0].point.y,
        face.vertices[1].point.z - face.vertices[0].point.z
    };
    
    Vector3D side2 = {
        face.vertices[2].point.x - face.vertices[0].point.x,
        face.vertices[2].point.y - face.vertices[0].point.y,
        face.vertices[2].point.z - face.vertices[0].point.z
    };
    
    Vector3D normal = {
        side1.y * side2.z - side2.y * side1.z,
        side1.z * side2.x - side2.z * side1.x,
        side1.x * side2.y - side2.x * side1.y
    };
    
    return normal;
}

- (void)dealloc
{
    free(self.vertices);
    free(self.normals);
    free(self.faces);
    free(self.triangleVertices);
}

@end
