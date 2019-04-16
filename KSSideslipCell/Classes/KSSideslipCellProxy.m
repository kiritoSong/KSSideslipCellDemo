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


@interface KTSideslipCellProxy()<UIScrollViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) id<UIScrollViewDelegate,UITableViewDelegate> tbDelegate;
@property (nonatomic,weak) id<UITableViewDataSource> tbDataSource;
@end

@implementation KTSideslipCellProxy

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [self.target respondsToSelector:aSelector] ||[self.tbDataSource respondsToSelector:aSelector] ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.tbDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [self.tbDataSource numberOfSectionsInTableView:tableView];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.tbDataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        return [self.tbDataSource tableView:tableView numberOfRowsInSection:section];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tbDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.tbDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tbDelegate respondsToSelector:@selector(cellForRowAtIndexPath:)]) {
        return [self.tbDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tbDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        return [self.tbDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.tbDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [self.tbDelegate tableView:tableView heightForHeaderInSection:section];
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self.tbDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [self.tbDelegate tableView:tableView viewForFooterInSection:section];
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.tbDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [self.tbDelegate tableView:tableView heightForFooterInSection:section];
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.tbDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [self.tbDelegate tableView:tableView viewForHeaderInSection:section];
    }
    return [UIView new];
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
    return self.target;
}

- (BOOL)isKindOfClass:(Class)aClass {
    if ([NSStringFromClass(aClass) isEqualToString:@"KTSideslipCellProxy"]) {
        return YES;
    }else {
        return NO;
    }
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
