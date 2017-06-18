//
//  DetailViewController.m
//  WikiPro
//
//  Created by Minhaz on 18/06/17.
//  Copyright © 2017 iqtech. All rights reserved.
//

#import "DetailViewController.h"
#import "ImageViewCell.h"
#import "TitleCell.h"
#import "ParagraphCell.h"

@interface DetailViewController () <UITableViewDataSource,UITableViewDelegate,ParagraphCellDelegate>
{
    __weak IBOutlet UITableView *theTableView;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self reloadTableData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Reload Table Data
- (void)reloadTableData
{
    theTableView.delegate = self;
    theTableView.dataSource = self;
    [theTableView reloadData];
}

#pragma mark - Actions
- (IBAction)onSearchBtClicked:(id)sender {
    
}
- (IBAction)onBackBtClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableDictionary *dataDic = self.data[kKeyDataDict];
    NSArray *items = dataDic[kKeyDataDictItems];
    return items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *dataDic = self.data[kKeyDataDict];
    NSArray *items = dataDic[kKeyDataDictItems];
    NSMutableDictionary *d = items[indexPath.row];
    NSString *key = d[___kDataKeyTextType];
    
    if ([key isEqualToString:___keyImgUrl]) {
        ImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageViewCell"];
        return cell.contentView.frame.size.height;
        
    } else if ([key isEqualToString:___keyMt]) {
        TitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        UIFont *font = cell.lblTitle.font;
        
        NSString *text = d[___kDataKeyText];
        CGSize size = [text getSizeWithConstrainedWidth:cell.lblTitle.frame.size.width font:font];
        return (size.height < 60 ? 60 : size.height);
        
    } else if ([key isEqualToString:___keyPar]) {
        ParagraphCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParagraphCell"];
        UIFont *font = cell.lblTitle.font;
        
        NSString *text = d[___kDataKeyText];
        CGSize size = [text getSizeWithConstrainedWidth:cell.lblTitle.frame.size.width font:font];
        return size.height + 50;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dataDic = self.data[kKeyDataDict];
    NSArray *items = dataDic[kKeyDataDictItems];
    NSMutableDictionary *d = items[indexPath.row];
    NSString *key = d[___kDataKeyTextType];
    NSString *text = d[___kDataKeyText];
    
    if ([key isEqualToString:___keyImgUrl]) {
        ImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageViewCell"];
        [cell.imgView setImageWithURL:[NSURL URLWithString:text] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                
            }
            else {
                
            }
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        return cell;
        
    } else if ([key isEqualToString:___keyMt]) {
        TitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        cell.lblTitle.text = text;
        return cell;
        
    } else if ([key isEqualToString:___keyPar]) {
        ParagraphCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParagraphCell"];
        cell.lblTitle.text = text;
        cell.dataDict = d;
        cell.lblTitle.hidden = YES;
        cell.delegate = self;
        [cell updateLinksAndText];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"blank_cell"];
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - ParagraphCellDelegate
- (void)didSelectLinkWithText:(NSString *)text
{
    NSLog(@"Selected: %@", text);
}
@end