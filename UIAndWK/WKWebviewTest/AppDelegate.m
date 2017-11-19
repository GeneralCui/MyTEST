

#import "AppDelegate.h"
#import "myTabBarController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "MyURLProtocol.h"
#import "NSURLProtocol+WebKitSupport.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    // 创建并初始化UITabBarController
    myTabBarController *tabBarC = [[myTabBarController alloc] init];
    self.window.rootViewController = tabBarC;
    
    LeftViewController *leftVC = [[LeftViewController alloc] init];
    RightViewController *rightVC = [[RightViewController alloc] init];
    
    UINavigationController *leftNavi = [[UINavigationController alloc] initWithRootViewController:leftVC];
    UINavigationController *rightNavi = [[UINavigationController alloc] initWithRootViewController:rightVC];
    NSArray *NCArray = [NSArray arrayWithObjects:leftNavi,rightNavi,nil];
    tabBarC.viewControllers = NCArray;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    leftNavi.title = @"UIWebView";
    rightNavi.title = @"WKWebView";

    
    leftNavi.tabBarItem.image = [UIImage imageNamed:@"Left1"];
    rightNavi.tabBarItem.image =[UIImage imageNamed:@"Right1"];

    
//    [NSURLProtocol registerClass:[MyURLProtocol class]];
//    [NSURLProtocol wk_registerScheme:@"http"];
//    [NSURLProtocol wk_registerScheme:@"https"];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
