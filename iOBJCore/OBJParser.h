//
//  OBJParser.h
//  iOBJ
//
//  Created by felipowsky on 03/01/12.
//
//

#import <Foundation/Foundation.h>
#import "DataParser.h"
#import "Mesh.h"

@interface OBJParser : DataParser

- (Mesh *)parseAsObject;
- (void)parseAsObjectWithMesh:(const Mesh *)mesh;

@end
