//
//  DetailViewController.h
//  wb
//
//  Created by Admin on 2022/4/28.
//  Copyright © 2022年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController

@property (nonatomic,strong) NSString *Urlstr;

- (DetailViewController *)initView:(DetailViewController *)detail WithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
