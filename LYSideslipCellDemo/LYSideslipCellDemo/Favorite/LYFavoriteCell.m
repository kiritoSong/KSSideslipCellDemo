//
//  LYFavoriteCell.m
//  LYSideslipCellDemo
//
//  Created by Louis on 16/7/7.
//  Copyright © 2016年 Louis. All rights reserved.
//

#import "LYFavoriteCell.h"

@interface LYFavoriteCell ()


@end
@implementation LYFavoriteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _avatarImageView.layer.cornerRadius = _avatarImageView.frame.size.width / 2;
}

@end
