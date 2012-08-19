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
#import "Material.h"
#import "MaterialParser.h"

@interface OBJParser : DataParser

- (id)initWithFilename:(NSString *)filename;
- (Mesh *)parseAsObject;
- (void)parseAsObjectWithMesh:(Mesh *)mesh;

@end
