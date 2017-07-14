//
//  infoVC.m
//  chuanTouDemo
//
//  Created by XF on 2017/7/11.
//  Copyright © 2017年 XF. All rights reserved.
//

#import "infoVC.h"

@interface infoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong)UITableView * tableView;

@property (nonatomic , assign)BOOL canScroll;
@end

@implementation infoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-153)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus:) name:@"taleView" object:nil];
}

-(void)changeScrollStatus:(NSNotification *)objc
{
    NSMutableDictionary * dic =  (NSMutableDictionary *)[objc userInfo];
    NSLog(@"改变的状态：%@",dic[@"type"]);
    if ([dic[@"type"] isEqualToString:@"NO"])
    {
        _canScroll = NO;
    }
    else
    {
        _canScroll = YES;
    }
    if (!_canScroll)
    {
        self.tableView.contentOffset = CGPointZero;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"XF"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XF"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"这是第：%ld个",indexPath.row];
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"tableView %d",self.canScroll);
    if (self.canScroll == NO)
    {
        //NSLog(@"这里也是不让动啊啊");
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0)
    {
        self.canScroll = NO;
        scrollView.contentOffset = CGPointZero;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"leaveTop" object:nil];
    }
    self.tableView.showsVerticalScrollIndicator = _canScroll?YES:NO;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
