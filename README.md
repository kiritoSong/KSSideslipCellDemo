# KSSideslipCellDemo

一个高仿微信左滑确认删除的轮子

>最初参考了一个16年仿微信左滑的博客https://www.jianshu.com/p/dc57e633de51
>
>由于16年的微信与现在的交互差异太大，所以进行了大量改造，只保留了其对于侧滑菜单的创建以及滑动判定的逻辑基础。
>
>对其中的bug以及功能实现方式进行优化调整，基本实现了现在微信的左滑逻辑功能。



***
#### 效果如下

![](https://upload-images.jianshu.io/upload_images/1552225-a3b0de3ab334643c.gif?imageMogr2/auto-orient/strip)

***

#### 详细的实现可以查看[博客](https://www.jianshu.com/p/a08b6db47014)

***
#### 使用起来


1. 继承该类
```
@interface LYHomeCell : KSSideslipCell
@end
```
2. 在tableView:cellForRowAtIndexPath:方法中设置代理:

```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LYHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KSSideslipCell.class)];
    if (!cell) {
        cell = [[LYHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(KSSideslipCell.class)];
        cell.delegate = self;
    }
    return cell;
}
```
3.实现KSSideslipCellDelegate协议sideslipCell:editActionsForRowAtIndexPath:方法，返回侧滑按钮事件数组。

```
#pragma mark - KSSideslipCellDelegate
- (NSArray<KSSideslipCellAction *> *)sideslipCell:(KSSideslipCell *)sideslipCell editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    KSSideslipCellAction *action = [KSSideslipCellAction rowActionWithStyle:KSSideslipCellActionStyleNormal title:@"备注" handler:^(KSSideslipCellAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [sideslipCell hiddenAllSideslip];
    }];
    return @[action];
}
```
4.二次确认 
在sideslipCell:rowAtIndexPath:didSelectedAtIndex:代理方法中返回一个UIView

如果你想展示另一个View，那么返回他。如果返回nil，则会直接收起侧滑菜单
需要注意如果你返回了一个View，那么整个侧滑容器将会对其进行适配(宽度)

```
- (UIView *)sideslipCell:(KSSideslipCell *)sideslipCell rowAtIndexPath:(NSIndexPath *)indexPath didSelectedAtIndex:(NSInteger)index {
    self.indexPath = indexPath;
    UIButton * view =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 135, 0)];
    view.titleLabel.textAlignment = NSTextAlignmentCenter;
    view.titleLabel.font = [UIFont systemFontOfSize:17];
    [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view setTitle:@"确认删除" forState:UIControlStateNormal];
    view.backgroundColor = [UIColor redColor];
    [view addTarget:self action:@selector(delBtnClick) forControlEvents:UIControlEventTouchUpInside];
    return view;
}

- (void)delBtnClick {
    [_dataArray removeObjectAtIndex:self.indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
```
