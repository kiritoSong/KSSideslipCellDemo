//
//  LYContactViewController.m
//  LYSideslipCellDemo
//
//  Created by Louis on 16/7/7.
//  Copyright © 2016年 Louis. All rights reserved.
//

#import "LYContactViewController.h"
#import "LYContactCell.h"

@interface LYContactViewController () <KSSideslipCellDelegate>
@property (nonatomic, strong) NSArray *titles;
@end

@implementation LYContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor colorWithRed:0 green:185/255.0 blue:1 alpha:1];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LYContactCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LYContactCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    
    cell.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon%ld", indexPath.row]];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"cellForRowAtIndexPath - %ld", indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.preservesSuperviewLayoutMargins = NO;
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 22)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.frame.size.width - 10, 22)];
    label.text = self.titles[section];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textColor = [UIColor grayColor];
    [headerView addSubview:label];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {

    return self.titles;
}

#pragma mark - LYSideslipCellDelegate
- (NSArray<KSSideslipCellAction *> *)sideslipCell:(KSSideslipCell *)sideslipCell editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    KSSideslipCellAction *action = [KSSideslipCellAction rowActionWithStyle:KSSideslipCellActionStyleNormal title:@"备注" handler:^(KSSideslipCellAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [sideslipCell hiddenAllSideslip];
    }];
    return @[action];
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"A", @"B", @"C", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N"];
    }
    return _titles;
}
@end
