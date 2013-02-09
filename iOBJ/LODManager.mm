//
//  LODManager.m
//  iOBJ
//
//  Created by felipowsky on 31/01/13.
//
//

#import "LODManager.h"
#import "progmesh.h"

@interface LODManager ()

@property (nonatomic, strong) GraphicObject *originalGraphicObject;
@property (nonatomic, strong) GraphicObject *graphicObjectWithProgressiveMesh;

@end

@implementation LODManager

- (id)initWithGraphicObject:(GraphicObject *)graphicObject
{
    self = [super init];
    
    if (self) {
        self.originalGraphicObject = graphicObject;
        self.type = LODManagerTypeNormal;
        self.graphicObjectWithProgressiveMesh = nil;
    }
    
    return self;
}

List<int> collapseMap;
List<int> permutation;
List<Vector> vert;
List<tridata> tri;

int Map(int a, int mx);

int Map(int a,int mx) {
	if (mx <= 0)
        return 0;
	
    while(a >= mx) {
		a = collapseMap[a];
	}
    
	return a;
}

void PermuteVertices(List<int> &permutation);

void PermuteVertices(List<int> &permutation) {
	// rearrange the vertex list
	List<Vector> tempList;
	
    assert(permutation.num == vert.num);
	
    for (int i = 0; i < vert.num; i++) {
		tempList.Add(vert[i]);
	}
    
	for (int i = 0; i < vert.num; i++) {
		vert[permutation[i]] = tempList[i];
	}
	
    // update the changes in the entries in the triangle list
	for (int i = 0; i < tri.num; i++) {
		for(int j = 0; j < 3; j++) {
			tri[i].v[j] = permutation[tri[i].v[j]];
		}
	}
}

- (void)generateProgressiveMeshWithPercentual:(int)percentual
{
    if (self.originalGraphicObject) {        
        int vertices = self.originalGraphicObject.mesh.pointsLength * (percentual * 0.01);
        GraphicObject *priorGraphicObject = self.graphicObjectWithProgressiveMesh;
        
        if (!priorGraphicObject) {
            while (collapseMap.num > 0) {
                collapseMap.DelIndex(0);
            }
            
            while (permutation.num > 0) {
                permutation.DelIndex(0);
            }
            
            while (vert.num > 0) {
                vert.DelIndex(0);
            }
            
            while (tri.num > 0) {
                tri.DelIndex(0);
            }
            
            Mesh *originalMesh = self.originalGraphicObject.mesh;
            
            for (int i = 0; i < originalMesh.pointsLength; i++) {
                GLKVector3 point = originalMesh.points[i];
                vert.Add(Vector(point.x, point.y, point.z));
            }
            
            for (Face3 *face in originalMesh.faces) {
                tridata td;
                
                for (int i = 0; i < 3; i++) {
                    td.v[i] = face.vertices[i].pointIndex;
                }
                
                tri.Add(td);
            }
            
            ProgressiveMesh(vert, tri, collapseMap, permutation);
            PermuteVertices(permutation);
        }
        
        Mesh *newMesh = [[Mesh alloc] init];
        
        for (int i = 0; i < tri.num; i++) {
            int p0 = Map(tri[i].v[0], vertices);
            int p1 = Map(tri[i].v[1], vertices);
            int p2 = Map(tri[i].v[2], vertices);
            // note: serious optimization opportunity here,
            // by sorting the triangles the following "continue"
            // could have been made into a "break" statement.
            
            if (p0 == p1 || p1 == p2 || p2 == p0) {
                continue;
            }
            
            // if we are not currenly morphing between 2 levels of detail
            // (i.e. if morph=1.0) then q0,q1, and q2 are not necessary.
            
            float lodbase = 0.5f;
            float morph = 1.0f;
            
            int q0 = Map(p0, (int)(vertices * lodbase));
            int q1 = Map(p1, (int)(vertices * lodbase));
            int q2 = Map(p2, (int)(vertices * lodbase));
            
            Vector v0, v1, v2;
            
            v0 = vert[p0] * morph + vert[q0] * (1-morph);
            v1 = vert[p1] * morph + vert[q1] * (1-morph);
            v2 = vert[p2] * morph + vert[q2] * (1-morph);
            
            // the purpose of the demo is to show polygons
            // therefore just use 1 face normal (flat shading)
            Vector nrml = (v1-v0) * (v2-v1);  // cross product
            
            GLKVector3 normal = GLKVector3Make(0.0f, 0.0f, 0.0f);
            
            if (0 < magnitude(nrml)) {
                //glNormal3fv(normalize(nrml));
                normal = GLKVector3Make(nrml.x, nrml.y, nrml.z);
            }
            
            GLKVector3 point0 = GLKVector3Make(v0.x, v0.y, v0.z);
            GLKVector3 point1 = GLKVector3Make(v1.x, v1.y, v1.z);
            GLKVector3 point2 = GLKVector3Make(v2.x, v2.y, v2.z);
            
            Face3 *face = [[Face3 alloc] init];
            
            Vertex vertex0;
            vertex0.point = point0;
            
            vertex0.normal = normal;
            
            face.vertices[0] = vertex0;
            
            Vertex vertex1;
            vertex1.point = point1;
            vertex1.normal = normal;
            
            face.vertices[1] = vertex1;
            
            Vertex vertex2;
            vertex2.point = point2;
            vertex2.normal = normal;
            
            face.vertices[2] = vertex2;
            
            [newMesh addFace:face];
        }
        
        self.graphicObjectWithProgressiveMesh = [[GraphicObject alloc] initWithMesh:newMesh];
    }
}

- (GraphicObject *)currentGraphicObject
{
    GraphicObject *graphicObject = self.originalGraphicObject;
    
    if (self.type == LODManagerTypeProgressiveMesh) {
        graphicObject = self.graphicObjectWithProgressiveMesh;
    
    }
    
    return graphicObject;
}

@end
