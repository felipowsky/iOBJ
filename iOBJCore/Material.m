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
        self.diffuseTextureMap = @"";
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{    
    Material *copy = [[Material allocWithZone:zone] initWithName:self.name];
    copy.ambientColor = self.ambientColor;
    copy.diffuseColor = self.diffuseColor;
    copy.specularColor = self.specularColor;
    copy.specularExponent = self.specularExponent;
    copy.transparency = self.transparency;
    copy.diffuseTextureMap = self.diffuseTextureMap;
    
    return copy;
}

@end
