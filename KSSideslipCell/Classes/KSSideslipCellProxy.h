//
//  KTSideslipCellProxy.h
//  LYSideslipCellDemo
//
//  Created by Klaus on 2019/4/9.
//  Copyright © 2019年 Louis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/**
    代理累，负责拦截tableView与其代理者的事件。关键作用是在有动作时收起扩展按钮
 */
@interface KTSideslipCellProxy : NSProxy<UITableViewDelegate,UIScrollViewDelegate,NSObject>

@property (nonatomic,weak) UITableView *target;

@end

NS_ASSUME_NONNULL_END
