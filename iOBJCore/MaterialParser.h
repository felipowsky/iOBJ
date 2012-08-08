//
//  MaterialParser.h
//  iOBJ
//
//  Created by felipowsky on 06/08/12.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DataParser.h"
#import "Material.h"

@interface MaterialParser : DataParser

- (NSDictionary *)parseMaterialsAsDictionary;

@end
