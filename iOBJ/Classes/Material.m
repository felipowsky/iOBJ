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
        self.ambientColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
        self.diffuseColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
        self.specularColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
        self.specularExponent = 50.0f;
        self.transparency = 1.0f;
        self.diffuseTextureMap = @"";
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    Material *copy = [[Material allocWithZone:zone] init];
    
    copy.name = self.name;
    copy.ambientColor = self.ambientColor;
    copy.diffuseColor = self.diffuseColor;
    copy.specularColor = self.specularColor;
    copy.specularExponent = self.specularExponent;
    copy.transparency = self.transparency;
    copy.diffuseTextureMap = self.diffuseTextureMap;
    
    return copy;
}

- (BOOL)haveTexture
{
    return self.diffuseTextureMap && ![self.diffuseTextureMap isEqualToString:@""];
}

@end
