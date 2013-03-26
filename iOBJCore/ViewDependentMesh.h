//
//  ViewDependentMesh.h
//  iOBJ
//
//  Created by felipowsky on 19/03/13.
//
//

#import <Foundation/Foundation.h>

@class Mesh, Camera, Face3;

@interface ViewDependentBinaryTree : NSObject

@property (nonatomic, weak) ViewDependentBinaryTree *parent;
@property (nonatomic, weak) ViewDependentBinaryTree *left;
@property (nonatomic, weak) ViewDependentBinaryTree *right;
@property (nonatomic) int edge;
@property (nonatomic) float radius; // bounding sphere radius
@property (nonatomic) float sintheta; // sinus of normal cone semi-angle
@property (nonatomic, readonly) BOOL active;

@end

@interface ViewDependentList : NSObject

@property (nonatomic, weak) ViewDependentList *next;
@property (nonatomic, weak) ViewDependentList *previous;
@property (nonatomic, weak) ViewDependentBinaryTree *node; // pointer to active node in hierarchy

@end

@interface ViewDependentHalfEdge : NSObject

@property (nonatomic) int rev;
@property (nonatomic) int vertex;

@end

@interface ViewDependentFace : NSObject

@property (nonatomic, strong) NSString *flag; // nil if not currently used in the mesh
@property (nonatomic, strong) ViewDependentBinaryTree *split; // node that deletes (inserts) this triangle
@property (nonatomic, weak) Face3 *face;

- (id)initWithFace:(Face3 *)face;

@end

@interface ViewDependentMesh : NSObject

- (id)initWithMesh:(Mesh *)mesh;
- (Mesh *)generateMeshWithCamera:(Camera *)camera;

@end
