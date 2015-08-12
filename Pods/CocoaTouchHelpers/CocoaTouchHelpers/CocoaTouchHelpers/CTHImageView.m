//
//  CTHImageView.m
//

#import "CTHImageView.h"

@implementation CTHImageView

- (void)circleView:(BOOL)activate
{
    if (activate) {
        float size = MIN(self.frame.size.width, self.frame.size.height);
        
        self.layer.cornerRadius = size / 2;
        self.layer.masksToBounds = YES;
        
    } else {
        self.layer.cornerRadius = 0.f;
    }
}

@end
