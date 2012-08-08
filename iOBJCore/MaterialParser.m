//
//  MaterialParser.m
//  iOBJ
//
//  Created by felipowsky on 06/08/12.
//
//

#import "MaterialParser.h"

@interface MaterialParser ()

@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSString *filename;

@end

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
        [self parseLine:lineWithoutComments materials:materials currentMaterial:currentMaterial];
    }
    
    return [[NSDictionary alloc] initWithDictionary:materials];
}

- (Material *)parseNewMaterialWithScanner:(const NSScanner *)scanner materials:(NSMutableDictionary *)materials
{
    NSString *name = [self nextWordWithScanner:scanner];

#ifdef DEBUG
    if ([materials objectForKey:name]) {
        NSLog(@"There is already a material called '%@'", name);
    }
#endif
    
    return [[Material alloc] initWithName:name];
}

- (UIColor *)parseColorWithScanner:(NSScanner *)scanner
{
    UIColor *color = nil;
    
    if (![scanner scanString:@"spectral" intoString:NULL] && ![scanner scanString:@"xyz" intoString:NULL]) {
        
        float red = [scanner scanFloat:&red];
        float green = [scanner scanFloat:&green];
        float blue = [scanner scanFloat:&blue];
        
        color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
    }
    
    return color;
}

- (UIColor *)parseIlluminationWithScanner:(NSScanner *)scanner
{
    UIColor *color = nil;
    
    int illum = [scanner scanInt:&illum];
    
    if (illum == 1) {
        color = [UIColor blackColor];
    }
    
    return color;
}

- (float)parseTransparencyWithScanner:(NSScanner *)scanner
{
    float alpha;
    
    [scanner scanFloat:&alpha];
    
    return alpha;
}

- (float)parseSpecularExponentWithScanner:(NSScanner *)scanner
{
    float specularExponent;
    
    [scanner scanFloat:&specularExponent];
    
    return specularExponent;
}

- (void)parseLine:(NSString *)line materials:(NSMutableDictionary *)materials currentMaterial:(Material *)currentMaterial
{
    NSScanner *scanner = [NSScanner scannerWithString:line];
    NSString *word = [self nextWordWithScanner:scanner];
    
    if (word) {
        
        if ([word isEqualToString:@"newmtl"]) {
            Material *material = [self parseNewMaterialWithScanner:scanner materials:materials];
            currentMaterial = material;
        
        } else {
            
            if (currentMaterial == nil) {
#ifdef DEBUG
                NSLog(@"All directives, except for 'newmtl', must come after a valid 'newmtl' directive");
#endif
            } else {
                
                if ([word isEqualToString:@"Ka"]) {
                    UIColor *ambientColor = [self parseColorWithScanner:scanner];
                    
                    if (ambientColor) {
                        currentMaterial.ambientColor = ambientColor;
                    }
                    
                } else if ([word isEqualToString:@"Kd"]) {
                    UIColor *diffuseColor = [self parseColorWithScanner:scanner];
                    
                    if (diffuseColor) {
                        currentMaterial.diffuseColor = diffuseColor;
                    }
                    
                } else if ([word isEqualToString:@"Ks"]) {
                    UIColor *specularColor = [self parseColorWithScanner:scanner];
                    
                    if (specularColor) {
                        currentMaterial.specularColor = specularColor;
                    }
                    
                } else if ([word isEqualToString:@"illum"]) {
                    UIColor *illumination = [self parseIlluminationWithScanner:scanner];
                    
                    if (illumination) {
                        currentMaterial.specularColor = illumination;
                    }
                    
                } else if ([word isEqualToString:@"Tr"] || [word isEqualToString:@"d"]) {
                    currentMaterial.transparency = [self parseTransparencyWithScanner:scanner];
                    
                } else if ([word isEqualToString:@"Ns"]) {
                    currentMaterial.specularExponent = [self parseSpecularExponentWithScanner:scanner];
                }
            }
        }
    }
}

@end
