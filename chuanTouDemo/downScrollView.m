//
//  downScrollView.m
//  chuanTouDemo
//
//  Created by XF on 2017/7/11.
//  Copyright © 2017年 XF. All rights reserved.
//

#import "downScrollView.h"
#import "infoVC.h"
#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
@interface downScrollView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * collection;
@property (nonatomic, strong) UIViewController *parentVC;//父视图
@property (nonatomic, strong) NSArray *childsVCs;//子视图数组
@property (nonatomic, assign) CGFloat startOffsetX;
@end
@implementation downScrollView

 -(instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray *)childVCs parentVC:(UIViewController *)parentVC delegate:(id<XFPageContentViewDelegate>)delegate
{
    if (self = [super initWithFrame:frame])
    {
        self.parentVC = parentVC;
        self.childsVCs = childVCs;
        self.delegate = delegate;
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = self.bounds.size;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.bounces = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"coll"];
    [self addSubview:collectionView];
    self.collection = collectionView;
    
    for (NSString * a in self.childsVCs)
    {
        infoVC * vc = [[infoVC alloc]init];
        vc.aaaa = a;
        [self.parentVC addChildViewController:vc];
    }
    //    [self addSubview:self.collectionView];
    [self.collection reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childsVCs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"coll" forIndexPath:indexPath];
    if (IOS_VERSION < 8.0) {
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UIViewController *childVC = self.parentVC.childViewControllers[indexPath.item];
        childVC.view.frame = cell.contentView.bounds;
        [cell.contentView addSubview:childVC.view];
    }
    return cell;
}

#ifdef __IPHONE_8_0
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIViewController *childVc = self.parentVC.childViewControllers[indexPath.row];
    childVc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVc.view];
}
#endif

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _startOffsetX = scrollView.contentOffset.x;
    if (self.delegate && [self.delegate respondsToSelector:@selector(XFContentViewWillBeginDragging:)]) {
        [self.delegate XFContentViewWillBeginDragging:self];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger indext = scrollView.contentOffset.x/kScreen_Width;
    CGFloat scrollView_W = scrollView.bounds.size.width;
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    NSInteger startIndex = floor(_startOffsetX/scrollView_W);
    NSInteger endIndex;
    CGFloat progress;
    if (currentOffsetX > _startOffsetX)
    {//左滑left
        progress = (currentOffsetX - _startOffsetX)/scrollView_W;
        endIndex = startIndex + 1;
        if (endIndex > self.childsVCs.count - 1)
        {
            endIndex = self.childsVCs.count - 1;
        }
    }else if (currentOffsetX == _startOffsetX)
    {//没滑过去
        progress = 0;
        endIndex = startIndex;
    }else
    {//右滑right
        progress = (_startOffsetX - currentOffsetX)/scrollView_W;
        endIndex = startIndex - 1;
        endIndex = endIndex < 0?0:endIndex;
    }
    
    NSLog(@"%ld",indext);
    infoVC * vc = self.parentVC.childViewControllers[indext];
    if (vc.view.superview)
    {
        return;
    }
    else
    {
        vc.view.frame= CGRectMake(0, 0, kScreen_Width, kScreen_Height-153);
        
        [self addSubview:vc.view];
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(XFContentViewDidScroll:startIndex:endIndex:progress:)])
    {
        [self.delegate XFContentViewDidScroll:self startIndex:startIndex endIndex:endIndex progress:progress];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat scrollView_W = scrollView.bounds.size.width;
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    NSInteger startIndex = floor(_startOffsetX/scrollView_W);
    NSInteger endIndex = floor(currentOffsetX/scrollView_W);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(XFContenViewDidEndDecelerating:startIndex:endIndex:)]) {
        [self.delegate XFContenViewDidEndDecelerating:self startIndex:startIndex endIndex:endIndex];
    }
}

@end
