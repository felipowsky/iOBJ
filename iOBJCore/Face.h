//
//  Face.h
//  iOBJ
//
//  Created by Felipe Imianowsky on 08/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Face : NSObject
{
}

@property (strong, nonatomic) NSArray *vertices;

- (id)initWithVertices:(NSArray *)vertices;

@end
