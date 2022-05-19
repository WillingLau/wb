//
//  AppDelegate.m
//  wb
//
//  Created by Admin on 2022/4/25.
//  Copyright © 2022年 admin. All rights reserved.
//

#import "AppDelegate.h"

#define AppKey @"2324327966"
#define RedirectURI @"http://www.baidu.com"

@interface AppDelegate ()<UIAlertViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UITabBarController *tabbarController= [[UITabBarController alloc]init];
    
    HomeViewController *controller1 = [[HomeViewController alloc]init];
    self.HomeNavViewController = [[UINavigationController alloc]initWithRootViewController:controller1];
    controller1.view.backgroundColor = [UIColor grayColor];
    controller1.tabBarItem.title = @"首页";
    controller1.tabBarItem.image = [UIImage imageNamed:@"home"];
    
    SearchViewController *controller2 = [[SearchViewController alloc]init];
    self.SearchNavViewController = [[UINavigationController alloc]initWithRootViewController:controller2];
    controller2.view.backgroundColor = [UIColor whiteColor];
    controller2.tabBarItem.title = @"搜索";
    controller2.tabBarItem.image = [UIImage imageNamed:@"search"];
    
    UIViewController *controller3 = [[UIViewController alloc]init];
    self.MessageNavViewController = [[UINavigationController alloc]initWithRootViewController:controller3];
    controller3.view.backgroundColor = [UIColor greenColor];
    controller3.tabBarItem.title = @"消息";
    controller3.tabBarItem.image = [UIImage imageNamed:@"messages"];
    
    MeViewController *controller4 = [[MeViewController alloc]init];
    self.MineNavViewController = [[UINavigationController alloc]initWithRootViewController:controller4];
    controller4.tabBarItem.title = @"我的";
    controller4.tabBarItem.image = [UIImage imageNamed:@"mine"];
    
    //设置tabbar
    [tabbarController setViewControllers:@[self.HomeNavViewController,self.SearchNavViewController,self.MessageNavViewController,self.MineNavViewController]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];
    controller4.dataFileName = [plistPath stringByAppendingPathComponent:@"UserInfo.plist"];

    
    self.window.rootViewController = tabbarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"wb"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}



@end
