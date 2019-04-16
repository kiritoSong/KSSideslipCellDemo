//
//  KSSideslipContainerView.m
//  LYSideslipCellDemo
//
//  Created by Kirito_Song on 2019/4/9.
//  Copyright © 2019年 infoq. All rights reserved.
//
#import "KSSideslipContainerView.h"
#import "KSSideslipCell.h"

@interface KSSideslipContainerView()
@property (nonatomic) NSMutableArray<NSNumber *> *originWidths;
@property (nonatomic,readwrite) NSArray<UIView *> *originSubViews; //这里，由于外部有可能会追加一些确认删除等等按钮。不能单独判断self.subViews
@property (nonatomic,readwrite) NSArray<UIButton *> *subButtons;
@property (nonatomic) CGFloat currentSubViewHeight;
@property (nonatomic,weak) id targetCell; //这个属性会在cell中被调用，但是不对外开放
@end

@implementation KSSideslipContainerView

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.frame.size.height != _currentSubViewHeight) {
        //修改子View高度
        for (UIView *btnBgView in self.subviews) {
            //同步一下新的高度
            btnBgView.frame = CGRectMake(btnBgView.frame.origin.x, btnBgView.frame.origin.y, btnBgView.frame.size.width, self.frame.size.height);
            if (btnBgView.subviews.firstObject) {
                btnBgView.subviews.firstObject.frame = CGRectMake(0, btnBgView.subviews.firstObject.frame.origin.y, btnBgView.subviews.firstObject.frame.size.width, self.frame.size.height);
            }
        }
        _currentSubViewHeight = self.frame.size.height;
    }
}

- (instancetype)initWithActions:(NSArray<KSSideslipCellAction *> *)actions {
    self = [super init];
    if (self) {
        for (int i = 0; i < actions.count; i++) {
            KSSideslipCellAction *action = actions[i];
            UIView * btnBgView = [[UIView alloc]init];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.adjustsImageWhenHighlighted = NO;
            
            [btn setTitle:action.title forState:UIControlStateNormal];
            
            if (action.backgroundColor) btnBgView.backgroundColor = action.backgroundColor;
            if (action.image) [btn setImage:action.image forState:UIControlStateNormal];
            if (action.fontSize != 0) btn.titleLabel.font = [UIFont systemFontOfSize:action.fontSize];
            if (action.titleColor) [btn setTitleColor:action.titleColor forState:UIControlStateNormal];
            
            CGFloat width = [action.title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : btn.titleLabel.font} context:nil].size.width;
            width += (action.image ? action.image.size.width : 0);
    
            btnBgView.frame = CGRectMake(i?[_originWidths[i-1] floatValue]:0, 0, width + action.margin*2, 0);
            btn.frame = CGRectMake(0, 0, width + action.margin*2, 0);
            
            //需要对初始的宽度进行保存。在形变等操作后恢复
            [self.originWidths addObject:@(width + action.margin*2)];
            
            //需要对总宽度进行保存
            _totalWidth += width + action.margin*2;
            btn.tag = i;
            
            [btn addTarget:self action:@selector(actionBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [btnBgView addSubview:btn];
            [self addSubview:btnBgView];
        }

        self.originSubViews = [self.subviews copy];
        self.frame = CGRectMake(self.frame.size.width, 0, _totalWidth, 0);
        [self subButtons];
    }
    return self;
}


- (void)actionBtnDidClicked:(UIButton *)btn {
    if ([self.targetCell respondsToSelector:@selector(actionBtnDidClicked:)]) {
        [self.targetCell performSelector:@selector(actionBtnDidClicked:) withObject:btn];
    }
}

- (void)restoration {
    NSUInteger count = self.subviews.count;
    CGFloat currentX = 0;
    for (int i = 0; i < count; i++) {
        UIView *s = self.subviews[i];
        //                NSLog(@"%lf",s.frame.size.width);
        CGRect sframe = s.frame;
        sframe.origin.x = currentX;
        sframe.size.width = [_originWidths[i] floatValue];
        s.frame = sframe;
        
        //下一个X起点为上一个起点+上一个宽度
        currentX += [_originWidths[i] floatValue];
    }
}


- (void)scaleToWidth:(CGFloat)width {
    CGFloat needExpandWidth = width - self.totalWidth;
    NSUInteger count = _originSubViews.count;
    CGFloat currentX = 0;
    for (int i = 0; i < count; i++) {
        UIView *s = _originSubViews[i];
        CGRect sframe = s.frame;
        sframe.origin.x = currentX;
        CGFloat sneedExpandWidth = (needExpandWidth * [_originWidths[i] floatValue]/_totalWidth);
        sframe.size.width = [_originWidths[i] floatValue] + sneedExpandWidth;
        s.frame = sframe;
        
        //下一个X起点为上一个起点+上一个宽度
        currentX += sframe.size.width;
    }
}

- (NSMutableArray<NSNumber *> *)originWidths {
    if (!_originWidths) {
        _originWidths = [NSMutableArray new];
    }
    return _originWidths;
}


- (NSArray *)subButtons {
    if (!_subButtons) {
        NSMutableArray * arr = [NSMutableArray new];
        for (UIView *v in self.subviews) {
            if (v.subviews.firstObject) {
                [arr addObject:v.subviews.firstObject];
            }
        }
        _subButtons = [arr copy];
    }
    
    return _subButtons;
}

- (void)setTargetCell:(id)targetCell {
    _targetCell = targetCell;
}

@end
