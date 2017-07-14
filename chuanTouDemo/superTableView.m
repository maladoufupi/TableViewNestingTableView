//
//  superTableView.m
//  chuanTouDemo
//
//  Created by XF on 2017/7/11.
//  Copyright © 2017年 XF. All rights reserved.
//

#import "superTableView.h"

@implementation superTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
