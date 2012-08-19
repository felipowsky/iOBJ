//
//  Material.m
//  iOBJ
//
//  Created by felipowsky on 05/08/12.
//
//

#import "Material.h"

@implementation Material

- (id)initWithName:(NSString *)name
{
    self = [super init];
    
    if (self) {
        _name = name;
        self.ambientColor = [UIColor grayColor];
        self.diffuseColor = [UIColor grayColor];
        self.specularColor = [UIColor blackColor];
        self.specularExponent = 50.0f;
        self.transparency = 1.0f;
    }
    
    return self;
}

@end
