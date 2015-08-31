//
//  FileTableViewCell.h
//  iOBJ
//
//  Created by felipowsky on 8/30/15.
//
//

#import <UIKit/UIKit.h>

@interface FileTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *filenameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *checkImageView;

@end
