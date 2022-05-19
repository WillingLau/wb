//
//  DetailViewController.m
//  wb
//
//  Created by Admin on 2022/4/28.
//  Copyright © 2022年 admin. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<WKNavigationDelegate>

@property (nonatomic,strong,readwrite) WKWebView *webView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height + 50)];
    //去掉乱码，且乱码固定
    NSString *url1 = [self.Urlstr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *url2 = [[url1 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] stringByReplacingOccurrencesOfString:@"%E2%80%8B" withString:@""];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url2]]];
    //如果把addsubview放在前面，虽然一样效果，但是日志版上会出现113:could not find specified service
    [self.view addSubview:({
        self.webView.navigationDelegate = self;
        self.webView;
    })];
    
}

//初始化的同时传入url
- (DetailViewController *)initView:(DetailViewController *)detail WithUrl:(NSString *)url{
    detail = [self init];
    self.Urlstr = url;
    return detail;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
