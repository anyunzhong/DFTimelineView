//
//  AppDelegate.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

#import "UserViewController.h"

#import "DFImagesSendViewController.h"

#define NavBarBgColor [UIColor colorWithRed:24/255.0 green:30/255.0 blue:43/255.0 alpha:1.0]
#define NavBarFgColor [UIColor whiteColor]
#define NavTextAttribute @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}



@interface AppDelegate ()

@property (nonatomic, strong) ViewController *controller;

@property (nonatomic, strong) UserViewController *userTimelineController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _controller = [[ViewController alloc] init];
    
    _userTimelineController = [[UserViewController alloc] init];
    
    
    //DFImagesSendViewController *imageSendController = [[DFImagesSendViewController alloc] initWithImages:[NSArray array]];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_controller];
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.rootViewController = nav;
    _window.backgroundColor = [UIColor whiteColor];
    
    [_window makeKeyAndVisible];
    
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
    [UINavigationBar appearance].barTintColor =NavBarBgColor;
    [UINavigationBar appearance].tintColor = NavBarFgColor;
    [UINavigationBar appearance].titleTextAttributes = NavTextAttribute;

    
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
