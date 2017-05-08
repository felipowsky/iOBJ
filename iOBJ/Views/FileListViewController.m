//
//  FileListViewController.m
//  iOBJ
//
//  Created by felipowsky on 26/09/12.
//
//

#import "FileListViewController.h"

#import "FileTableViewCell.h"

@interface FileListViewController ()

@property (nonatomic, strong) NSArray *files;

@end

@implementation FileListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.files = [NSArray new];
    self.selectedFile = nil;
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSError *error;
    
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:&error];
    
    if (!error) {
        NSMutableArray *newFiles = [[NSMutableArray alloc] init];
        
        for (NSString *file in contents) {
            NSString *extension = [file pathExtension];
            
            if ([[extension lowercaseString] isEqualToString:@"obj"]) {
                [newFiles addObject:file];
            }
        }
        
        self.files = newFiles;
        
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't load resources from '%@'", documentsPath);
    }
#endif
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self setBackBarButtonItemTitle:@"" style:UIBarButtonItemStylePlain];
    
    [UIApplication setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [self.filesTableView reloadData];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = self.files.count;
    
    if (rows < 1) {
        rows = 1;
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoResults"];
    
    if (self.files.count > 0 && indexPath.row < self.files.count) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"File"];
        
        FileTableViewCell *cellFile = (FileTableViewCell *) cell;
        
        NSString *filename = [self.files objectAtIndex:indexPath.row];
        
        cellFile.filenameLabel.text = filename;
        
        BOOL checkHidden = YES;
        
        if (!object_is_empty(self.selectedFile) && [self.selectedFile isEqualToString:filename]) {
            checkHidden = NO;
        }
        
        cellFile.checkImageView.hidden = checkHidden;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.files.count > 0 && indexPath.row < self.files.count) {
        NSString *file = [self.files objectAtIndex:indexPath.row];
        
        self.selectedFile = file;
        
        [self.filesTableView reloadData];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(fileList:selectedFile:)]) {
            [self.delegate fileList:self selectedFile:file];
        }
        
        [self closeViewController];
    }
}

@end
