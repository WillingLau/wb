//
//  MyBlogViewController.m
//  wb
//
//  Created by Admin on 2022/5/7.
//  Copyright © 2022年 admin. All rights reserved.
//

#import "MyBlogViewController.h"

@interface MyBlogViewController ()<WKNavigationDelegate>

@property (nonatomic,strong,readwrite) WKWebView *webView;

@end

@implementation MyBlogViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:({
        self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height + 50)];
        self.webView.navigationDelegate = self;
        self.webView;
    })];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *path = [plistPath stringByAppendingPathComponent:@"UserInfo.plist"];

    NSMutableDictionary *myBlogData = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    
    NSString *myBlogUrl = myBlogData[@"blogUrl"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:myBlogUrl]]];
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
