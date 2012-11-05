//
//  FileListViewController.m
//  iOBJ
//
//  Created by felipowsky on 26/09/12.
//
//

#import "FileListViewController.h"

@interface FileListViewController ()

@property (nonatomic, strong) NSArray *files;

@end

@implementation FileListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    self.files = [[NSArray alloc] init];
    self.selectedFile = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    
    NSError *error;
    
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resourcePath error:&error];
    
    if (!error) {
        NSMutableArray *newFiles = [[NSMutableArray alloc] init];
        
        for (NSString *file in contents) {
            NSString *extension = [file pathExtension];
            
            if ([[extension lowercaseString] isEqualToString:@"obj"]) {
                [newFiles addObject:file];
            }
        }
        
        self.files = newFiles;
        
        [self.filesTableView reloadData];
    }
#ifdef DEBUG
    else {
        NSLog(@"Couldn't load resources from '%@'", resourcePath);
    }
#endif
    
}

- (void)close
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fileListWillClose:)]) {
        [self.delegate fileListWillClose:self];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(fileListDidClose:)]) {
        [self.delegate fileListDidClose:self];
    }
}

- (IBAction)cancel:(id)sender
{
    [self close];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.filesTableView && indexPath.row < self.files.count) {
        NSString *file = [self.files objectAtIndex:indexPath.row];
        
        self.selectedFile = file;
        
        [self.filesTableView reloadData];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(fileList:selectedFile:)]) {
            [self.delegate fileList:self selectedFile:file];
        }
        
        [self close];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSString *file = [self.files objectAtIndex:indexPath.row];
    
    cell.textLabel.text = file;
    
    if (self.selectedFile && ![self.selectedFile isEqualToString:@""] && [self.selectedFile isEqualToString:file]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

@end
