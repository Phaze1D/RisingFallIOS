//
//  AppDelegate.m
//  Rising Fall
//
//  Created by David Villarreal on 4/27/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    ViewController * myView = (ViewController *) self.window.rootViewController;

    if ([myView.mainView.scene isKindOfClass: [GamePlayScene class]]) {
        GamePlayScene * scene = (GamePlayScene * )myView.mainView.scene;
        [scene pauseGame];
    }

     myView.mainView.paused = YES;
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    GameData * data = [GameData sharedGameData];
    [data saveData];

    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    ViewController * myView = (ViewController *) self.window.rootViewController;
    myView.mainView.paused = NO;
    
    if ([myView.mainView.scene isKindOfClass: [StartScene class]]) {
        StartScene * sScene = (StartScene *)myView.mainView.scene;
        if (!_googleBack) {
            [sScene enbableChild];
            
        }
    
        sScene.deltaTime = 1;
    }else if([myView.mainView.scene isKindOfClass: [GamePlayScene class]]){
        GamePlayScene * scene = (GamePlayScene *)myView.mainView.scene;
        if (scene.stageAt == 3 && !_googleBack) {
            [scene.sPanel enbableChild];
        }
        
        
    }else if ([myView.mainView.scene isKindOfClass: [StoreScene class]]){
        
        StoreScene * storeS = (StoreScene *)myView.mainView.scene;
        storeS.deltaTime = 1;
        
    }
    
    _googleBack = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
    
   
    if ([GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation]) {
        _googleBack = YES;
        return  YES;
    }else{
        _googleBack = NO;
        return NO;
    }
}



@end
