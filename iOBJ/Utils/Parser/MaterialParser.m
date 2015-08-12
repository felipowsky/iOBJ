//
//  MaterialParser.m
//  iOBJ
//
//  Created by felipowsky on 06/08/12.
//
//

#import "MaterialParser.h"

@implementation MaterialParser

- (id)initWithFilename:(NSString *)filename
{
    self = [super initWithFilename:filename ofType:@"mtl"];
    
    if (self) {
    }
    
    return self;
}

- (NSDictionary *)parseMaterialsAsDictionary
{
    NSMutableDictionary *materials = [[NSMutableDictionary alloc] init];
    Material *currentMaterial = nil;
    
    NSString *materialString = [[NSString alloc] initWithData:self.data encoding:NSASCIIStringEncoding];
    NSArray *lines = [materialString componentsSeparatedByString:@"\n"];
    
    for (NSString *line in lines) {
        NSString *lineWithoutComments = [[line componentsSeparatedByString:@"#"] objectAtIndex:0];
        [self parseLine:lineWithoutComments materials:materials currentMaterial:&currentMaterial];
    }
    
    if (currentMaterial && ![materials objectForKey:currentMaterial.name]) {
        [materials setObject:currentMaterial forKey:currentMaterial.name];
    }
    
    return [[NSDictionary alloc] initWithDictionary:materials];
}

- (Material *)parseNewMaterialWithScanner:(NSScanner *)scanner materials:(NSMutableDictionary *)materials
{
    NSString *name = nil;
    
    [scanner scanWord:&name];
    
    return [[Material alloc] initWithName:name];
}

- (GLKVector4)parseColorWithScanner:(NSScanner *)scanner
{
    GLKVector4 color;
    
    if (![scanner scanString:@"spectral" intoString:nil] && ![scanner scanString:@"xyz" intoString:nil]) {
        
        CGFloat red;
        CGFloat green;
        CGFloat blue;
        
        [scanner scanFloat:&red];
        [scanner scanFloat:&green];
        [scanner scanFloat:&blue];
        
        color = GLKVector4Make(red, green, blue, 1.0f);
    }
    
    return color;
}

- (GLKVector4)parseIlluminationWithScanner:(NSScanner *)scanner currentSpecularColor:(GLKVector4)specularColor
{
    GLKVector4 color = specularColor;
    
    int illum;
    
    [scanner scanInt:&illum];
    
    if (illum == 1) {
        color = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    }
    
    return color;
}

- (GLfloat)parseTransparencyWithScanner:(NSScanner *)scanner
{
    GLfloat alpha;
    
    [scanner scanFloat:&alpha];
    
    return alpha;
}

- (GLfloat)parseSpecularExponentWithScanner:(NSScanner *)scanner
{
    GLfloat specularExponent;
    
    [scanner scanFloat:&specularExponent];
    
    return specularExponent;
}

- (NSString *)parseDiffuseTextureMapWithScanner:(NSScanner *)scanner
{
    NSString *word = nil;
    
    [scanner scanWord:&word];
    
    NSArray *split = [[word lastPathComponent] componentsSeparatedByString:@"\\"];
    
    return [split objectAtIndex:split.count-1];
}

- (void)parseLine:(NSString *)line materials:(NSMutableDictionary *)materials currentMaterial:(Material **)currentMaterial
{
    NSScanner *scanner = [NSScanner scannerWithString:line];
    NSString *word = nil;
    
    if ([scanner scanWord:&word]) {
        
        if ([word isEqualToString:@"newmtl"]) {
            Material *material = [self parseNewMaterialWithScanner:scanner materials:materials];
            
            if (*currentMaterial) {
                [materials setObject:*currentMaterial forKey:(*currentMaterial).name];
            }
            
#ifdef DEBUG
            if ([materials objectForKey:material.name]) {
                NSLog(@"There is already a material called '%@'", material.name);
            }
#endif
            *currentMaterial = material;
        
        } else {
            
            if (!*currentMaterial) {
#ifdef DEBUG
                NSLog(@"All directives, except for 'newmtl', must come after a valid 'newmtl' directive");
#endif
            } else {
                
                if ([word isEqualToString:@"Ka"]) {
                    GLKVector4 ambientColor = [self parseColorWithScanner:scanner];
                    (*currentMaterial).ambientColor = ambientColor;
                    
                } else if ([word isEqualToString:@"Kd"]) {
                    GLKVector4 diffuseColor = [self parseColorWithScanner:scanner];
                    (*currentMaterial).diffuseColor = diffuseColor;
                    
                } else if ([word isEqualToString:@"Ks"]) {
                    GLKVector4 specularColor = [self parseColorWithScanner:scanner];
                    (*currentMaterial).specularColor = specularColor;
                    
                } else if ([word isEqualToString:@"illum"]) {
                    GLKVector4 specularColor = (*currentMaterial).specularColor;
                    GLKVector4 illumination = [self parseIlluminationWithScanner:scanner currentSpecularColor:specularColor];
                    (*currentMaterial).specularColor = illumination;
                
                } else if ([word isEqualToString:@"Tr"] || [word isEqualToString:@"d"]) {
                    (*currentMaterial).transparency = [self parseTransparencyWithScanner:scanner];
                    
                } else if ([word isEqualToString:@"Ns"]) {
                    (*currentMaterial).specularExponent = [self parseSpecularExponentWithScanner:scanner];
                
                } else if ([word isEqualToString:@"map_Kd"]) {
                    (*currentMaterial).diffuseTextureMap = [self parseDiffuseTextureMapWithScanner:scanner];
                }
            }
        }
    }
}

@end
