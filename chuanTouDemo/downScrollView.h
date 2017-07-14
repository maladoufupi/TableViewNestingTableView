//
//  downScrollView.h
//  chuanTouDemo
//
//  Created by XF on 2017/7/11.
//  Copyright © 2017年 XF. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef kScreen_Width
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#endif

#ifndef kScreen_Height
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#endif
@class downScrollView;
@protocol XFPageContentViewDelegate <NSObject>

@optional


- (void)XFContentViewWillBeginDragging:(downScrollView *)contentView;


- (void)XFContentViewDidScroll:(downScrollView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress;


- (void)XFContenViewDidEndDecelerating:(downScrollView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;

@end
@interface downScrollView : UIView
- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray *)childVCs parentVC:(UIViewController *)parentVC delegate:(id<XFPageContentViewDelegate>)delegate;
@property (nonatomic, weak) id<XFPageContentViewDelegate>delegate;
@end
