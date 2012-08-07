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

@end

@implementation MaterialParser

- (NSDictionary *)parseMaterialsAsDictionary
{
    Material *currentMaterial = nil;
    
    NSString *materialString = [[NSString alloc] initWithData:self.data encoding:NSASCIIStringEncoding];
    NSArray *lines = [materialString componentsSeparatedByString:@"\n"];
    
    NSMutableDictionary *materials = [NSMutableDictionary dictionary];
    
    for (NSString *line in lines) {
        NSString *lineWithoutComments = [[line componentsSeparatedByString:@"#"] objectAtIndex:0];
        [self parseLine:lineWithoutComments];
    }
}

- (void)parseLine:(NSString *)line
{
    NSScanner *scanner = [NSScanner scannerWithString:line];
    NSString *word = [self nextWordWithScanner:scanner];
    
    if (word) {
    }
}

@end
