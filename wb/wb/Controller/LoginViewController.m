//
//  LoginViewController.m
//  wb
//
//  Created by Admin on 2022/5/3.
//  Copyright © 2022年 admin. All rights reserved.
//

#import "LoginViewController.h"


#define AppKey @"2324327966"
#define RedirectURI @"http://www.baidu.com"
#define BaseURL @"https://api.weibo.com/oauth2/authorize"
#define AppSecret @"0159ff2447a4a26e35bef49b49d2f618"


@interface LoginViewController ()<WKNavigationDelegate,UIWebViewDelegate>

@property(nonatomic,strong) NSString *accessToken;
@property(nonatomic,strong) NSString *Data;//用户数据


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super loadView];
    //accesstoken获取一次即可，accesstoken是固定的
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *dataFileName = [plistPath stringByAppendingPathComponent:@"AccessToken.plist"];
    NSArray *accessTokenArr= [[NSArray alloc]initWithContentsOfFile:dataFileName];
//防止accessTokenArr里没数据，而导致越界，所以用遍历来取；
    for (NSString *accessToken in accessTokenArr) {
        self.accessToken = accessToken;
    }
   
    if (self.accessToken) {
        [self getStatusWith:self.accessToken];
    }
    else{
        UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:webView];
        NSString *baseUrl = BaseURL;
        NSString *clientID = AppKey;
        NSString *redirectURI = RedirectURI;
        
        // 获得授权的url
        NSString *urlStr = [NSString stringWithFormat:@"%@?client_id=%@&response_type=code&redirect_uri=%@",baseUrl,clientID,redirectURI];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        
        webView.delegate = self;
    }
   
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark -WebViewDelegate-

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *str = request.URL.absoluteString;
    NSRange rang = [str rangeOfString:@"code="];
    if (rang.length) {
        NSString *code = [str substringFromIndex:rang.location + rang.length];
        NSLog(@"code=%@",code);
        [self accessTokenWithCode:code];
        return NO;
    }
    return YES;
}

#pragma mark 获取accessToken
-(void)accessTokenWithCode:(NSString *)code{
    //确定请求路径
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/access_token?client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",AppKey,AppSecret,RedirectURI,code];
    NSURL *url = [NSURL URLWithString:urlStr];
    //创建可变请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    //修改请求方式
    [request setHTTPMethod:@"POST"];//获取accessToken 要使用POST请求。默认是GET
    //设置请求体
    request.HTTPBody =[@"username=520&pwd=520&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    //创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    //创建请求task
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //解析返回的数据
        NSString *ATData =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSRange ATRang = [ATData rangeOfString:@"access_token"];
        NSRange UidRang = [ATData rangeOfString:@"uid"];
        //由于accessToken和uid长度是确定的，所以这样取
        self.accessToken = [ATData substringWithRange:NSMakeRange(ATRang.location+ATRang.length+3, 32)];
        self.uid = [ATData substringWithRange:NSMakeRange(UidRang.location+UidRang.length+3,10)];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *plistPath = [paths objectAtIndex:0];
        NSString *dataFileName = [plistPath stringByAppendingPathComponent:@"AccessToken.plist"];
        
        NSMutableArray *ArrToStore = [[NSMutableArray alloc]init];
        [ArrToStore addObject:self.accessToken];
        [ArrToStore writeToFile:dataFileName atomically:YES];
        
        [self getUserInfo];
        
    }];
    //发送请求
    [dataTask resume];
    
}

#pragma mark 获取授权用户信息
- (void)getUserInfo{
        
        /**
         以下是获取用户信息
        */
    NSString *urlStr1 =[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?client_id=%@&access_token=%@&uid=%@",AppKey,self.accessToken,self.uid];
    NSURL *url1 = [NSURL URLWithString:urlStr1];
        
    NSData *userData = [NSData dataWithContentsOfURL:url1];
    
    if (userData) {
        NSDictionary *userInfo1 = [NSJSONSerialization JSONObjectWithData:userData options:NSJSONReadingAllowFragments error:nil];
        
        self.userInfo = [[NSMutableDictionary alloc]init];
        
        NSString *name = [userInfo1 objectForKey:@"name"] ;
        [self.userInfo setValue:name forKey:@"name"];
        
        NSString *fans = [userInfo1 objectForKey:@"followers_count"];
        [self.userInfo setValue:fans forKey:@"fans"];
        
        NSString *iconUrl = [userInfo1 objectForKey:@"profile_image_url"] ;
        [self.userInfo setValue: iconUrl forKey:@"iconUrl"];
        
        NSString *blog_url = [userInfo1 objectForKey:@"profile_url"];
        NSString *blog_url_base = @"https://weibo.com";
        NSString *blogUrl = [blog_url_base stringByAppendingPathComponent:blog_url];
        [self.userInfo setValue:blogUrl forKey:@"blogUrl"];
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *plistPath = [paths objectAtIndex:0];
        NSString *dataFileName = [plistPath stringByAppendingPathComponent:@"UserInfo.plist"];
        [self.userInfo writeToFile:dataFileName atomically:YES];
        
        
        
        [self getStatusWith:self.accessToken];
        
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
        
         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜" message:@"登录成功" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel
         handler:^(UIAlertAction * action) {
         [self.navigationController popViewControllerAnimated:YES];
         }];
         [alert addAction:cancelAction];//添加按钮
         [self presentViewController:alert animated:YES completion:nil];
    }
    
}

#pragma mark 获取授权用户关注的用户发布的微博
-(void) getStatusWith:(NSString *)accessToken{
    NSString *urlStr =[NSString stringWithFormat:@"https://api.weibo.com/2/statuses/home_timeline.json?client_id=%@&access_token=%@",AppKey,accessToken];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSData *StatusData = [NSData dataWithContentsOfURL:url];
    NSDictionary *statusInfo = [NSJSONSerialization JSONObjectWithData:StatusData options:NSJSONReadingAllowFragments error:nil];
    
    //json嵌套 用数组接受需要用到的数据
    NSMutableArray *tmpArr = [[NSMutableArray alloc]init];
    [tmpArr addObject:[statusInfo objectForKey:@"statuses"]];
    
    NSMutableArray *dataToStore = [[NSMutableArray alloc]init];
    NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc]init];
    
    //tmpArr【0】中还有很多字典，我把它理解为c++二维数组类似的，然后遍历
    for (tmpDic in tmpArr[0]) {
        
        self.StatusInfo = [[NSMutableDictionary alloc]init];
        
        NSMutableDictionary *Poster = [[NSMutableDictionary alloc]init];
        [Poster setDictionary:[tmpDic objectForKey:@"user"]];

        
        NSString *name = [Poster objectForKey:@"name"] ;
        [self.StatusInfo setObject:name forKey:@"name"];
        //
        NSString *poster_icon = [Poster objectForKey:@"profile_image_url"];
        [self.StatusInfo setObject:poster_icon forKey:@"icon"];
        //
        NSString *text = [tmpDic objectForKey:@"text"];
        //判断正文中是否有网页链接
        if ([text rangeOfString:@"http://"].location <= text.length) {
            NSRange rang = [text rangeOfString:@"http://"];
            NSString *source = [text substringFromIndex:rang.location];
            NSString *text1 = [text substringToIndex:rang.location];
            [self.StatusInfo setObject:text1 forKey:@"text"];
            [self.StatusInfo setObject:source forKey:@"source"];
        }else{
            [self.StatusInfo setObject:text forKey:@"text"];
        }
        //
        if ([tmpDic objectForKey:@"thumbnail_pic"]) {
            NSString *picture = [tmpDic objectForKey:@"thumbnail_pic"];
            [self.StatusInfo setObject:picture forKey:@"picture"];
        }
        //
        NSString *attitudes_count = [tmpDic objectForKey:@"attitudes_count"];
        [self.StatusInfo setObject:attitudes_count forKey:@"likeCount"];
        //
        NSString *reposts_count = [tmpDic objectForKey:@"reposts_count"];
        [self.StatusInfo setObject:reposts_count forKey:@"reportsCount"];
        //
        NSString *comments_count = [tmpDic objectForKey:@"comments_count"];
        [self.StatusInfo setObject:comments_count forKey:@"commentsCount"];
        //
        NSString *time = [tmpDic objectForKey:@"created_at"];
        [self.StatusInfo setObject:time forKey:@"time"];
        
        [dataToStore addObject:self.StatusInfo];
    }
   
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *statusDataFileName = [plistPath stringByAppendingPathComponent:@"StatusInfo.plist"];
        
    [dataToStore writeToFile:statusDataFileName atomically:YES];
    
}

@end
