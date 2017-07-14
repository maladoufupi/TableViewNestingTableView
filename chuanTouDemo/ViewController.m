//
//  ViewController.m
//  chuanTouDemo
//
//  Created by XF on 2017/7/11.
//  Copyright © 2017年 XF. All rights reserved.
//

#import "ViewController.h"
#import "superTableView.h"
#import "downScrollView.h"
#ifndef kScreen_Width
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#endif

#ifndef kScreen_Height
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#endif
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,XFPageContentViewDelegate>

@property (nonatomic , strong)UITableView * superTableView;
@property (nonatomic , strong)downScrollView * down;
@property (nonatomic , assign)BOOL canScroll;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor blueColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];
    [self createUI];
}

-(void)createUI
{
    self.canScroll = YES;
    _superTableView = [[superTableView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-113)];
    _superTableView.delegate = self;
    _superTableView.dataSource = self;
    [self.view addSubview:_superTableView];
}
- (void)changeScrollStatus//改变主视图的状态
{
    self.canScroll = YES;
    //elf.contentCell.cellCanScroll = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"taleView" object:nil userInfo:@{@"type":@"NO"}];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        return kScreen_Height-153;
    }
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 40;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
        view.backgroundColor = [UIColor redColor];
        return view;
    }
    
    return [UIView new];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"one"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
        }
        cell.backgroundColor = [UIColor orangeColor];
        return cell;
    }
    else
    {
        //[self removeFromParentViewController];
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"two"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"two"];
            _down = [[downScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-153) childVCs:@[@"1",@"2",@"3"] parentVC:self delegate:self];
            _down.backgroundColor = [UIColor greenColor];
            [cell addSubview:_down];
        }
        
        return cell;
    }
}
#pragma mark FSSegmentTitleViewDelegate
- (void)XFContenViewDidEndDecelerating:(downScrollView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    
    _superTableView.scrollEnabled = YES;//此处其实是监测scrollview滚动，pageView滚动结束主tableview可以滑动，或者通过手势监听或者kvo，这里只是提供一种实现方式
}



- (void)XFContentViewDidScroll:(downScrollView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress
{
    _superTableView.scrollEnabled = NO;//pageView开始滚动主tableview禁止滑动
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _superTableView)
    {
        CGFloat bottomCellOffset = [_superTableView rectForSection:1].origin.y;
       
        if (scrollView.contentOffset.y>= bottomCellOffset)
        {
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            if (self.canScroll)
            {
                self.canScroll = NO;
                //发布通知修改状态
               [[NSNotificationCenter defaultCenter]postNotificationName:@"taleView" object:nil userInfo:@{@"type":@"YES"}];
            }
        }
        else
        {
            //子视图如果没有到顶部，superView还是保持组一置顶
            if (!self.canScroll)
            {
                //子视图没到顶部
                scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
