//
//  KSSideslipCellProxy.m
//  LYSideslipCellDemo
//
//  Created by Klaus on 2019/4/9.
//  Copyright © 2019年 Louis. All rights reserved.
//

#import "KSSideslipCellProxy.h"
#import "KSSideslipCell.h"

@interface UITableView ()
@property (nonatomic) BOOL sideslip;
@property (nonatomic) KTSideslipCellProxy *sideslipCellProxy;
@end

@interface KSSideslipCell () <UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL sideslip;
@end


@interface KTSideslipCellProxy()
@property (nonatomic,weak) id<UIScrollViewDelegate,UITableViewDelegate> tbDelegate;
@property (nonatomic,weak) id<UITableViewDataSource> tbDataSource;
@end

@implementation KTSideslipCellProxy

- (BOOL)respondsToSelector:(SEL)aSelector {
    if (aSelector == @selector(scrollViewWillBeginDragging:) || aSelector == @selector(tableView:didSelectRowAtIndexPath:)) {
        return YES;
    }
    BOOL res = [self.tbDelegate respondsToSelector:aSelector] ||[self.tbDataSource respondsToSelector:aSelector];
    return res ;
}

- (BOOL)isKindOfClass:(Class)aClass {
    if ([NSStringFromClass(aClass) isEqualToString:@"KTSideslipCellProxy"]) {
        return YES;
    }else {
        return NO;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (self.target.sideslip) {
        [self.target hiddenAllSideslip];
    }
    
    if ([self.tbDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.tbDelegate scrollViewWillBeginDragging:scrollView];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.target.sideslip) {
        [self.target hiddenAllSideslip];
    }
    
    if ([self.tbDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.tbDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    id res;
    if ([self.tbDelegate respondsToSelector:aSelector]) {
        res = self.tbDelegate;
    }else if ([self.tbDataSource respondsToSelector:aSelector]) {
        res = self.tbDataSource;
    }
    return res;
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return nil;
}

- (void)setTarget:(UITableView *)target {
    _target = target;
    target.sideslipCellProxy = self; //这里需要让tableView强引用proxy防止释放
    self.tbDelegate = target.delegate; //保存tableView原本的delegate，进行转发
    self.tbDataSource = target.dataSource;//保存tableView原本的dataSource，进行转发
    target.delegate = self; //修改tableView.delegate拦截事件
}

@end
