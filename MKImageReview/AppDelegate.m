//
//  AppDelegate.m
//  MKImageReview
//
//  Created by Liujh on 16/3/11.
//  Copyright © 2016年 com.minstone. All rights reserved.
//

#import "AppDelegate.h"
#import "MKApplicationShortcutsConfigure.h"
#import "Utils.h"
#import <CoreSpotlight/CoreSpotlight.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //动态设置程序快捷方式
//    [MKApplicationShortcutsConfigure configure];
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

//程序快捷方式
-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    if(shortcutItem){
        NSString *ID = [NSString stringWithFormat: @"%@", shortcutItem.userInfo[@"scheme"]];
        if([ID isEqualToString: @"mkapple://snapshot"]){
            //延时处理
            dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
            dispatch_after(start, dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName: SnapshootNotification object: nil];
            });
        }
    }
    
    if(completionHandler){
        completionHandler(YES);
    }
}

-(BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    NSString *identifier = userActivity.userInfo[CSSearchableItemActivityIdentifier];
    
    if([identifier isEqualToString:@"打开MKApple"]){
        
        UIViewController *rootViewCtrl = self.window.rootViewController;
        
        __block UIViewController *ctrl = [UIViewController new];
        
        [rootViewCtrl presentViewController:ctrl animated:YES completion:^{
            
            UIWebView *webView = [[UIWebView alloc] initWithFrame: ctrl.view.bounds];
            [webView sizeToFit];
            webView.scalesPageToFit = YES;
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mkapple.cn"]]];
            [ctrl.view addSubview:webView];
            
        }];
        
    }
    
    return YES;
}

@end
