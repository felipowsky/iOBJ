//
//  Material.h
//  iOBJ
//
//  Created by felipowsky on 05/08/12.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Material : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong) UIColor *ambientColor;
@property (nonatomic, strong) UIColor *diffuseColor;
@property (nonatomic, strong) UIColor *specularColor;
@property (nonatomic) GLfloat specularExponent;
@property (nonatomic) GLfloat transparency;
@property (nonatomic) NSString *diffuseTextureMap;
@property (nonatomic, readonly) BOOL haveTexture;

- (id)initWithName:(NSString *)name;

@end
