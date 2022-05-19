//
//  SearchedStatusViewController.m
//  wb
//
//  Created by Admin on 2022/5/14.
//  Copyright © 2022年 admin. All rights reserved.
//

#import "SearchedStatusViewController.h"
#import "StatusFrame.h"
#import "Status.h"
#import "HomeTableViewCell.h"
#import "JumpToURL_Protocol.h"

@interface SearchedStatusViewController ()<JumpToURL_Protocol>

@property(nonatomic,strong) NSMutableArray *statusFrames;//存放所有微博的模型和数据

@end

@implementation SearchedStatusViewController

- (void)viewDidLoad {
    [super loadView];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];
    self.StatusFileName = [plistPath stringByAppendingPathComponent:@"statusSearched.plist"];
    self.StatusDataArr = [[NSArray alloc]initWithContentsOfFile:self.StatusFileName];
    
    self.historyStatusFrameTostore = [[NSMutableArray alloc]init];
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath1 = [paths1 objectAtIndex:0];
    self.historyDataFileName = [plistPath1 stringByAppendingPathComponent:@"History.plist"];
    NSArray *HistoryDataArr = [[NSArray alloc] initWithContentsOfFile:self.historyDataFileName];
    [self.historyStatusFrameTostore addObjectsFromArray:HistoryDataArr];
    
    self.likeStatusTostore = [[NSMutableArray alloc]init];
    NSArray *like_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *like_plistPath = [like_paths objectAtIndex:0];
    self.likeStatusDataFileName = [like_plistPath stringByAppendingPathComponent:@"LikeStatus.plist"];
    NSArray *likeStatusArr = [[NSArray alloc] initWithContentsOfFile:self.likeStatusDataFileName];
    [self.likeStatusTostore addObjectsFromArray:likeStatusArr];
}



- (NSArray *)statusFrames{
    if (_statusFrames == nil) {
        NSArray *likesDataArr = [[NSArray alloc] initWithContentsOfFile:self.StatusFileName];
        //新建一个存放模型的数组
        NSMutableArray *statusFrameArr = [NSMutableArray array];
        
        for (NSDictionary *dic in likesDataArr) {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.StatusDataArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    StatusFrame *heightFrame = self.statusFrames[indexPath.row];
    return heightFrame.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeTableViewCell *cell = [HomeTableViewCell cellWithTableView:tableView];
    //设置点击网页链接跳转代理
    cell.delegate = self;
    cell.statusFrame = self.statusFrames[indexPath.row];
    
    return cell;
}

#pragma mark 记录历史
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.historyStatusFrameTostore insertObject:self.StatusDataArr[indexPath.row] atIndex:0];
    [self.historyStatusFrameTostore writeToFile:self.historyDataFileName atomically:YES];
    
    
}

#pragma mark 滑动收藏
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.likeStatusTostore insertObject:self.StatusDataArr[indexPath.row] atIndex:0];
    [self.likeStatusTostore writeToFile:self.likeStatusDataFileName atomically:YES];
    
}

#pragma mark 更改滑动按钮文本
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"收藏";
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
