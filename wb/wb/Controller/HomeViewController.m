//
//  HomeViewController.m
//  wb
//
//  Created by Admin on 2022/4/27.
//  Copyright © 2022年 admin. All rights reserved.
//

#import "HomeViewController.h"
#import "StatusFrame.h"
#import "Status.h"
#import "HomeTableViewCell.h"
#import "JumpToURL_Protocol.h"

#define AppKey @"2324327966"

@interface HomeViewController ()<JumpToURL_Protocol>

@property(nonatomic,strong) NSMutableArray *statusFrames;//存放所有微博的模型和数据
@property(nonatomic,strong) NSMutableDictionary *StatusInfo;//存放最新微博信息


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    self.tableView.delegate = self;
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    
    self.historyStatusFrameTostore = [[NSMutableArray alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];
    self.historyDataFileName = [plistPath stringByAppendingPathComponent:@"History.plist"];
    NSArray *HistoryDataArr = [[NSArray alloc] initWithContentsOfFile:self.historyDataFileName];
    [self.historyStatusFrameTostore addObjectsFromArray:HistoryDataArr];
    
    self.likeStatusTostore = [[NSMutableArray alloc]init];
    NSArray *like_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *like_plistPath = [like_paths objectAtIndex:0];
    self.likeStatusDataFileName = [like_plistPath stringByAppendingPathComponent:@"LikeStatus.plist"];
    NSArray *likeStatusArr = [[NSArray alloc] initWithContentsOfFile:self.likeStatusDataFileName];
    [self.likeStatusTostore addObjectsFromArray:likeStatusArr];
    
    NSArray *StatusPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *StatusPlistPath = [StatusPaths objectAtIndex:0];
    NSString *StatusPath = [StatusPlistPath stringByAppendingPathComponent:@"NewStatus.plist"];
    self.NewStatusDataArr = [[NSMutableArray alloc] initWithContentsOfFile:StatusPath];
    
    //创建发微博按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发微博" style:UIBarButtonItemStylePlain target:self action:@selector(clickAdd)];
    
    //创建刷新微博按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(reloadStatus)];
    //获得各微博信息及尺寸
    [self getstatusFrames];

}


- (NSArray *)getstatusFrames{
    if (_statusFrames == nil) {
        //新建一个存放模型的数组
        NSMutableArray *statusFrameArr = [NSMutableArray array];
        //本地发的微博
        if (self.NewStatusDataArr) {
            
            for (NSDictionary *dic in self.NewStatusDataArr) {
                Status *status = [Status statusWithDict:dic];
                
                StatusFrame *statusFrame = [[StatusFrame alloc]init];
                statusFrame.status = status;
                
                [statusFrameArr addObject:statusFrame];
            }
        }
        //从服务器获取的微博
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *plistPath = [paths objectAtIndex:0];
        self.StatusFile = [plistPath stringByAppendingPathComponent:@"StatusInfo.plist"];
        self.dataArr = [[NSMutableArray alloc] initWithContentsOfFile:self.StatusFile];
        
        
        for (NSDictionary *dic in self.dataArr) {
            Status *status = [Status statusWithDict:dic];
            
            StatusFrame *statusFrame = [[StatusFrame alloc]init];
            statusFrame.status = status;
            
            [statusFrameArr addObject:statusFrame];
        }
        
        _statusFrames = statusFrameArr;
        
    }
    
    return _statusFrames;
}


#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    StatusFrame *heightFrame = self.statusFrames[indexPath.row];
    return heightFrame.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count + self.NewStatusDataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeTableViewCell *cell = [HomeTableViewCell cellWithTableView:tableView];
    //设置点击网页链接跳转代理
    cell.delegate = self;
     cell.statusFrame = self.statusFrames[indexPath.row];
    
    //防止cell内容没变一直复用，用下面这个就会一直都是看过的内容
//
//    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCellId"];
//    if(!cell) {
//        cell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"homeCellId"];
//        cell.statusFrame = self.statusFrames[indexPath.row];
//    }
 
    return cell;
}

//浏览历史
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //因为有自己发的本地微博，所以需要判断
    if (self.NewStatusDataArr && (indexPath.row+1) <= self.NewStatusDataArr.count) {//点击本地微博
        //判断是否有同样的记录
        for (NSInteger index = 0; index < self.historyStatusFrameTostore.count; index++) {
            if ([[self.historyStatusFrameTostore[index] objectForKey:@"text"]isEqualToString:[self.NewStatusDataArr[indexPath.row] objectForKey:@"text"]])
            {
                [self.historyStatusFrameTostore removeObjectAtIndex:index];
            }
        }
        [self.historyStatusFrameTostore insertObject:self.NewStatusDataArr[indexPath.row] atIndex:0];
        [self.historyStatusFrameTostore writeToFile:self.historyDataFileName atomically:YES];
    }
    else if(self.NewStatusDataArr && (indexPath.row+1) > self.NewStatusDataArr.count){//存在本地微博且点击非本地微博
        for (NSInteger index = 0; index < self.historyStatusFrameTostore.count; index++) {
            if ([[self.historyStatusFrameTostore[index] objectForKey:@"text"]isEqualToString:[self.dataArr[indexPath.row-self.NewStatusDataArr.count] objectForKey:@"text"]])
            {
                [self.historyStatusFrameTostore removeObjectAtIndex:index];
            }
        }
        [self.historyStatusFrameTostore insertObject:self.dataArr[indexPath.row-self.NewStatusDataArr.count] atIndex:0];
        [self.historyStatusFrameTostore writeToFile:self.historyDataFileName atomically:YES];
    }
    else{//没有本地微博
        for (NSInteger index = 0; index < self.historyStatusFrameTostore.count; index++) {
            if ([[self.historyStatusFrameTostore[index] objectForKey:@"text"]isEqualToString:[self.dataArr[indexPath.row] objectForKey:@"text"]])
            {
                [self.historyStatusFrameTostore removeObjectAtIndex:index];
            }
        }
        [self.historyStatusFrameTostore insertObject:self.dataArr[indexPath.row] atIndex:0];
        [self.historyStatusFrameTostore writeToFile:self.historyDataFileName atomically:YES];
    }
    
}

#pragma mark 点击跳转网页
-(void)jumpToURL:(UITapGestureRecognizer *)param{
    
    CGPoint location = [param locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath) {
        StatusFrame *statusFrame = [[StatusFrame alloc]init];
        statusFrame = self.statusFrames[indexPath.row];
        NSString *URLstr = statusFrame.status.source;
        //担心初始化detailviewcontroller后，url没加载进去，所以用一个没有初始化的self。detailviewController，以确保能接收到url且发送对应请求
        DetailViewController *detailView = [[DetailViewController alloc]initView:self.detailViewController WithUrl:URLstr];
        [self.navigationController pushViewController:detailView animated:YES];
    }
    
}

#pragma mark 滑动收藏
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //收藏与历史记录同理
    if (self.NewStatusDataArr && (indexPath.row+1) <= self.NewStatusDataArr.count) {
        for (NSInteger index = 0; index < self.likeStatusTostore.count; index++) {
            if ([[self.likeStatusTostore[index] objectForKey:@"text"]isEqualToString:[self.NewStatusDataArr[indexPath.row] objectForKey:@"text"]])
            {
                [self.likeStatusTostore removeObjectAtIndex:index];
            }
        }
        [self.likeStatusTostore insertObject:self.NewStatusDataArr[indexPath.row] atIndex:0];
        [self.likeStatusTostore writeToFile:self.likeStatusDataFileName atomically:YES];
    }
    else if(self.NewStatusDataArr && (indexPath.row+1) > self.NewStatusDataArr.count){
        for (NSInteger index = 0; index < self.likeStatusTostore.count; index++) {
            if ([[self.likeStatusTostore[index] objectForKey:@"text"]isEqualToString:[self.dataArr[indexPath.row-self.NewStatusDataArr.count] objectForKey:@"text"]])
            {
                [self.likeStatusTostore removeObjectAtIndex:index];
            }
        }
        [self.likeStatusTostore insertObject:self.dataArr[indexPath.row-self.NewStatusDataArr.count] atIndex:0];
        [self.likeStatusTostore writeToFile:self.likeStatusDataFileName atomically:YES];
    }
    else{
        for (NSInteger index = 0; index < self.likeStatusTostore.count; index++) {
            if ([[self.likeStatusTostore[index] objectForKey:@"text"]isEqualToString:[self.dataArr[indexPath.row] objectForKey:@"text"]])
            {
                [self.likeStatusTostore removeObjectAtIndex:index];
            }
        }
        [self.likeStatusTostore insertObject:self.dataArr[indexPath.row] atIndex:0];
        [self.likeStatusTostore writeToFile:self.likeStatusDataFileName atomically:YES];
    }
}

#pragma mark 更改滑动按钮文本
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"收藏";
}

#pragma mark 展示发微博的页面
- (void)clickAdd {
    NewStatusViewController *newStatusViewController = [[NewStatusViewController alloc]init];
    [self.navigationController pushViewController:newStatusViewController animated:YES];
}


#pragma mark 刷新微博
-(void)reloadStatus{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *dataFileName = [plistPath stringByAppendingPathComponent:@"AccessToken.plist"];
    NSArray *accessTokenArr= [[NSArray alloc]initWithContentsOfFile:dataFileName];
    
    
    NSString *accessToken = [[NSString alloc]init];
    //防止用户还没登录就刷新，此时 accessTokenArr里没数据，而导致越界，所以用遍历来取；
    for (NSString *AccessToken in accessTokenArr) {
        accessToken = AccessToken;
    }
    
    [self getStatusWith:accessToken];
    [self.tableView reloadData];
    
}

#pragma mark 获取最新微博
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
    
    BOOL isEqual = YES;
    for (NSUInteger index = 0; index < dataToStore.count ; index++) {
        NSMutableDictionary *dica = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dicb = [[NSMutableDictionary alloc]init];
        [dica setDictionary:dataToStore[index]];
        [dicb setDictionary:self.dataArr[index]];
        //只要有一个不一样的，就加载进来
        if (![[dica objectForKey:@"text"] isEqualToString:[dicb objectForKey:@"text"]]) {
            isEqual = NO;
        }
    }
    
    if (isEqual) {
        [self showNewStatus:0];
    }else{
        [dataToStore writeToFile:self.StatusFile atomically:YES];
        
        /**
         重新为statusframe赋值
         */
        //新建一个存放模型的数组
        NSMutableArray *statusFrameArr = [NSMutableArray array];
        if (self.NewStatusDataArr) {

            for (NSDictionary *dic in self.NewStatusDataArr) {
                Status *status = [Status statusWithDict:dic];

                StatusFrame *statusFrame = [[StatusFrame alloc]init];
                statusFrame.status = status;

                [statusFrameArr addObject:statusFrame];
            }
        }

        for (NSDictionary *dic in dataToStore) {
            Status *status = [Status statusWithDict:dic];

            StatusFrame *statusFrame = [[StatusFrame alloc]init];
            statusFrame.status = status;

            [statusFrameArr addObject:statusFrame];
        }

        _statusFrames = statusFrameArr;
        
        [self showNewStatus:(int)dataToStore.count];
        
        //记录之前加载过，但是被刷新替换掉的微博，为搜索准备
        [dataToStore addObjectsFromArray:self.dataArr];
        
        //更改从plist里读出来的数据，方便下次刷新时比对
        [self.dataArr replaceObjectsInRange:NSMakeRange(0, self.dataArr.count) withObjectsFromArray:dataToStore];
        
        NSArray *StatusPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *StatusPlistPath = [StatusPaths objectAtIndex:0];
        NSString *StatusPath = [StatusPlistPath stringByAppendingPathComponent:@"HistoryStatus.plist"];
        NSArray *HistoryStatusFromFile = [[NSArray alloc]initWithContentsOfFile:StatusPath];
        [dataToStore addObjectsFromArray:HistoryStatusFromFile];
        [dataToStore writeToFile:StatusPath atomically:YES];
        
    }
}


-(void)showNewStatus:(int)count{
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.frame.size.height-35, [UIScreen mainScreen].bounds.size.width, 35);
    label.backgroundColor = [UIColor orangeColor];
    if (count == 0) {
        label.text = @"没有最新微博";
    }else{
        label.text = [NSString stringWithFormat:@"已为您加载%d条最新微博",count];
    }
    label.textColor = [UIColor whiteColor];
    //文字剧中
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    //动画显示
    [UIView animateWithDuration:1.0 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, 35);
    }completion:^(BOOL finished){
        [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            //回到最初始状态
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            //移除掉label
            [label removeFromSuperview];
        }];
    }];
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
