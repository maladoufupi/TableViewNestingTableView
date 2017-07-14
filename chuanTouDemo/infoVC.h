//
//  infoVC.h
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
@interface infoVC : UIViewController
@property (nonatomic ,copy)NSString * aaaa;
@end
