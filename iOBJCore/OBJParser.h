//
//  OBJParser.h
//  iOBJ
//
//  Created by felipowsky on 03/01/12.
//
//

#import <Foundation/Foundation.h>
#import "Mesh.h"

@interface OBJParser : NSObject

- (id)initWithData:(const NSData *)data;
- (Mesh *)parseAsObject;
- (void)parseAsObjectWithMesh:(const Mesh *)mesh;

@end
