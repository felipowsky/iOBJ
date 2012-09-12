//
//  Material.h
//  iOBJ
//
//  Created by felipowsky on 05/08/12.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface Material : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic) GLKVector4 ambientColor;
@property (nonatomic) GLKVector4 diffuseColor;
@property (nonatomic) GLKVector4 specularColor;
@property (nonatomic) GLfloat specularExponent;
@property (nonatomic) GLfloat transparency;
@property (nonatomic) NSString *diffuseTextureMap;
@property (nonatomic, readonly) BOOL haveTexture;

- (id)initWithName:(NSString *)name;

@end
