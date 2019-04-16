//
//  LYHomeCellModel.m
//  LYSideslipCellDemo
//
//  Created by Louis on 16/7/5.
//  Copyright © 2016年 Louis. All rights reserved.
//

#import "LYHomeCellModel.h"


@implementation LYHomeCellModel
+ (NSMutableArray *)requestDataArray {
    NSArray *images = @[@"icon0", @"icon1", @"icon2", @"icon3", @"icon4"];
    NSArray *names = @[@"Louis", @"老帅哥", @"iOS Coder", @"iOS Developer", @"Joe"];
    NSArray *time = @[@"13:14", @"23:45", @"昨天", @"星期五", @"15/10/19"];
    NSArray *lastMessage = @[@"你个傻×, 快回消息!", @"今天天气很好啊, 是不是?, 是不是?, 是不是?, 是不是?, 是不是?, 是不是?, 是不是?, 是不是?, 是不是?", @"原作者博客 http://www.louisly.com", @"我的博客 https://www.jianshu.com/u/f8c6149f1b15", @"What can i do for you?"];
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        LYHomeCellModel *model = [LYHomeCellModel new];
        model.iconName = images[arc4random()%5];
        model.userName = names[arc4random()%5];
        model.timeString = time[arc4random()%5];
        model.lastMessage = lastMessage[arc4random()%5];
        model.messageType = 0;
        if (i == 3) {
            model.messageType = 1;
            model.iconName = @"add_friend_icon_offical";
        }
        if (i == 5) {
            model.messageType = 2;
            model.iconName = @"ReadVerified_icon";
        }
        [mArray addObject:model];
    }
    [mArray addObjectsFromArray:mArray];
    return mArray;
}
@end
