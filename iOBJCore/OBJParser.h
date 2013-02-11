//
//  OBJParser.h
//  iOBJ
//
//  Created by felipowsky on 03/01/12.
//
//

#import <Foundation/Foundation.h>
#import "DataParser.h"

@class Mesh;

@interface OBJParser : DataParser

- (id)initWithFilename:(NSString *)filename;
- (Mesh *)parseAsObject;
- (void)parseAsObjectWithMesh:(Mesh *)mesh;

@end
