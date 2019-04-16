//
//  KSSideslipCell.h
//  KSSideslipCellDemo
//
//  Created by Kirito_Song on 2019/4/9.
//  Copyright © 2019年 infoq. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "KSSideslipContainerView.h"




NS_ASSUME_NONNULL_BEGIN


/**
 
    <#     提供多个侧滑扩展，以及二次确认按钮的cell       #>
 
    iOS11之后，可以通过对系统方法进行改造的方式实现。
    可以看这篇https://www.jianshu.com/p/aa6ff5d9f965
 
    但是iOS11之前，系统在点击删除按钮之后会自动对扩展按钮进行回收。无法进行那样的改造。
 
    于是决定自己写一个。最初参考了一个16年仿微信左滑的博客https://www.jianshu.com/p/dc57e633de51
    由于16年微信做跟现在比起来也蛮简陋，所以进行了大量改造，只保留了其对于cell创建以及滑动判定的逻辑基础。
    对其中的bug以及功能实现方式进行优化调整，基本实现了现在微信的左滑逻辑功能。
 
 */



typedef NS_ENUM(NSInteger, KSSideslipCellActionStyle) {
    KSSideslipCellActionStyleDefault = 0,
    KSSideslipCellActionStyleDestructive = KSSideslipCellActionStyleDefault, // 删除 红底
    KSSideslipCellActionStyleNormal // 正常 灰底
};


/**
    创建扩展按钮用的Action，需要在cell代理中返回。
 */
@interface KSSideslipCellAction : NSObject
+ (instancetype)rowActionWithStyle:(KSSideslipCellActionStyle)style title:(nullable NSString *)title handler:(void (^)(KSSideslipCellAction *action, NSIndexPath *indexPath))handler;
@property (nonatomic, readonly) KSSideslipCellActionStyle style;
@property (nonatomic, copy, nullable) NSString *title;          // 文字内容
@property (nonatomic, strong, nullable) UIImage *image;         // 按钮图片. 默认无图
@property (nonatomic, assign) CGFloat fontSize;                 // 字体大小. 默认17
@property (nonatomic, strong, nullable) UIColor *titleColor;    // 文字颜色. 默认白色
@property (nonatomic, copy, nullable) UIColor *backgroundColor; // 背景颜色. 默认透明
@property (nonatomic, assign) CGFloat margin;                   // 内容左右间距. 默认15
@end




@class KSSideslipCell;
@protocol KSSideslipCellDelegate <NSObject>
@optional;
/**
 *  选中了侧滑按钮
 *
 *  @param sideslipCell 当前响应的cell
 *  @param indexPath    cell在tableView中的位置
 *  @param index        选中的是第几个action
 *  return 如果你想展示另一个View，那么返回他。如果返回nil，则会直接收起侧滑菜单
 *  需要注意如果你返回了一个View，那么整个侧滑容器将会对其进行适配(宽度)
 */
- (UIView *)sideslipCell:(KSSideslipCell *)sideslipCell rowAtIndexPath:(NSIndexPath *)indexPath didSelectedAtIndex:(NSInteger)index;

/**
 *  告知当前位置的cell是否需要侧滑按钮
 *
 *  @param sideslipCell 当前响应的cell
 *  @param indexPath    cell在tableView中的位置
 *
 *  @return YES 表示当前cell可以侧滑, NO 不可以
 */
- (BOOL)sideslipCell:(KSSideslipCell *)sideslipCell canSideslipRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  返回侧滑事件
 *
 *  @param sideslipCell 当前响应的cell
 *  @param indexPath    cell在tableView中的位置
 *
 *  @return 数组为空, 则没有侧滑事件
 */
- (nullable NSArray<KSSideslipCellAction *> *)sideslipCell:(KSSideslipCell *)sideslipCell editActionsForRowAtIndexPath:(NSIndexPath *)indexPath;
@end



/**
    功能cell
 */
@interface KSSideslipCell : UITableViewCell


/**
    代理
 */
@property (nonatomic, weak) id<KSSideslipCellDelegate> delegate;

/**
 *  按钮容器
 */
@property (nonatomic, strong) KSSideslipContainerView *btnContainView;

/**
 *  隐藏所有侧滑按钮
 */
- (void)hiddenAllSideslip;


/**
 隐藏当前cell的侧滑按钮
 */
- (void)hiddenSideslip;


/**
 展示当前cell的侧滑按钮
 */
- (void)showSideslip;
@end


@interface UITableView (KSSideslipCell)


/**
  隐藏所有cell的侧滑按钮
 */
- (void)hiddenAllSideslip;
- (void)hiddenOtherSideslip:(KSSideslipCell *)cell;
@end

NS_ASSUME_NONNULL_END
