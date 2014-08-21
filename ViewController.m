//
//  ViewController.m
//  Rising Fall
//
//  Created by David Villarreal on 4/27/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "ViewController.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
#define IS_IPAD_1 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )1024 ) < DBL_EPSILON )
#define IS_IPAD_2 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )2048 ) < DBL_EPSILON )



@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    SocialMediaControl * socialC = [SocialMediaControl sharedSocialMediaControl];
    socialC.viewC = self;
    
    
    // Configure the view.
    _mainView = (SKView *)self.view;
    //_mainView.ignoresSiblingOrder = YES;
    //_mainView.showsFPS = YES;
    //_mainView.showsNodeCount = YES;
    _mainView.showsDrawCount = YES;
    _banner = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    _banner.delegate = self;
    _bannerIsVisible = YES;
    [self.view addSubview:_banner];
    [self hideBanner: nil];
    
    
    [self loadStartMenu];
    
}

//Loads the Start Menu
- (void)loadStartMenu{
    
    
    SKTextureAtlas * startAtlas = [[TextureLoader shareTextureLoader] startMenuAtlas];
    SKTextureAtlas * socialAtlas = [[TextureLoader shareTextureLoader]  socialMediaAtlas];
    SKTextureAtlas *  ballAtlas = [[TextureLoader shareTextureLoader]  ballsAtlas];
    
    [SKTextureAtlas preloadTextureAtlases:@[startAtlas, socialAtlas, ballAtlas] withCompletionHandler:^{
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            StartScene * startScene = [StartScene sceneWithSize:_mainView.bounds.size];
            startScene.delegate = self;
            startScene.startAtlas = startAtlas;
            startScene.socialAtlas = socialAtlas;
            startScene.ballAtlas = ballAtlas;
            [self showBanner:startScene];
            _storeScene = nil;
            _storeScene.delegate = nil;
            
        });
        
    }];
    
}


//Loads the Level Scene
-(void)loadLevelScene{
    
    
    SKTextureAtlas * levelAtlas = [[TextureLoader shareTextureLoader] levelSceneAtlas];
    SKTextureAtlas * buttonAtlas = [[TextureLoader shareTextureLoader] buttonAtlas];
    
    [SKTextureAtlas preloadTextureAtlases:@[levelAtlas, buttonAtlas] withCompletionHandler:^{
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            LevelsScene * levelScene = [LevelsScene sceneWithSize:_mainView.bounds.size];
            levelScene.delegate = self;
            levelScene.sceneAtlas = levelAtlas;
            levelScene.buttonAtlas = buttonAtlas;
            [self showBanner: levelScene];
            
        });
    }];
    
}


//Loads the Gameplay Scene
-(void)loadGameplayScene: (int) levelID{
    
    
    SKTextureAtlas * gameAtlas = [[TextureLoader shareTextureLoader] gameplayAtlas];
    SKTextureAtlas * ballAtlas = [[TextureLoader shareTextureLoader] ballsAtlas];
    
    [SKTextureAtlas preloadTextureAtlases:@[gameAtlas, ballAtlas] withCompletionHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            GamePlayScene *  gameplayScene = [GamePlayScene sceneWithSize:_mainView.bounds.size];
            gameplayScene.levelID = levelID;
            gameplayScene.delegate = self;
            gameplayScene.gameSceneAtlas = gameAtlas;
            gameplayScene.ballAtlas = ballAtlas;
            [self hideBanner: gameplayScene];
        });
        
    }];
    
}

//Loads the store scene
-(void)loadStoreScene{
    
    SKTextureAtlas * storeAtlas = [[TextureLoader shareTextureLoader] storeAtlas];
    SKTextureAtlas * ballAtlas = [[TextureLoader shareTextureLoader] itemsAtlas];
    [SKTextureAtlas preloadTextureAtlases:@[storeAtlas, ballAtlas] withCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            _storeScene = [StoreScene sceneWithSize:_mainView.bounds.size];
            _storeScene.scaleMode = SKSceneScaleModeAspectFill;
            _storeScene.delegate = self;
            _storeScene.sceneAtlas = storeAtlas;
            _storeScene.buyPanel.iteamsAtlas = ballAtlas;
            [self hideBanner: _storeScene];
        });
        
    }];
    
    
}

//When the play button in the start scene is pressed
-(void)playButtonPressed{
    
   
    
    [self loadLevelScene];
    
}

//Called when store button is pressed in the start scene
-(void)storeButtonPressed{
   
    [self loadStoreScene];
}


//When a navigtion button is pressed
-(void)navigationPressed{
    
    if ([_mainView.scene isKindOfClass:[LevelsScene class]]) {
        [self loadStartMenu];
        
    }
    
}

//Called when a level is select to be played
-(void)beginGamePlay:(int)levelID{
    [self loadGameplayScene: levelID];
    
}

//called when the player clicks the quit button in gameplay scene
-(void)quitGameplay{
    [self loadStartMenu];
    
    
}

//Called when the player starts a new level aftering winning
-(void)beginNextLevel: (int)level{
    [_mainView presentScene:[SKScene sceneWithSize:_mainView.bounds.size]];
    [self loadGameplayScene:level];
}

//Called when store back button is pressed
-(void)storeBackPressed{
    [self loadStartMenu];
}


-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    if (error) {
        NSLog(@"banner error");
        [self hideBanner: nil];
    }
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    
    if ([_mainView.scene isKindOfClass: [StartScene class]]) {
        StartScene * sScene = (StartScene *)_mainView.scene;
        sScene.deltaTime = 1;
    }
    _mainView.paused = NO;
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    
    _mainView.paused = YES;
    
    return YES;
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
        NSLog(@"loaded");
    [self showBanner: nil];
}

-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
    
}

-(void)showBanner: (SKScene *)scene{
    
    if (!_bannerIsVisible && ([scene isKindOfClass:[StartScene class]] || [scene isKindOfClass:[LevelsScene class]]) && [_banner isBannerLoaded]) {
        
        _banner.hidden = NO;
        [UIView animateWithDuration:.2 animations:^{
            
            _banner.frame = CGRectMake(0,0 , _banner.frame.size.width, _banner.frame.size.height);
            
        } completion:^(BOOL finished) {
            if (finished) {
                _bannerIsVisible = YES;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (scene != nil) {
                    [_mainView presentScene:scene];
                }
            });
            
        }];
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (scene != nil) {
                [_mainView presentScene:scene];
            }
        });

    }
    
}

-(void)hideBanner: (SKScene * )scene{
    if (_bannerIsVisible) {
        
        
        [UIView animateWithDuration:.2 animations:^{
            
            _banner.frame =CGRectMake(0,0-_banner.bounds.size.height , _banner.frame.size.width, _banner.frame.size.height);
            
        } completion:^(BOOL finished) {
            if (finished) {
                _bannerIsVisible = NO;
                _banner.hidden = YES;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
            
                if (scene != nil) {
                    [_mainView presentScene:scene];
                }
            });
            
            
        }];
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (scene != nil) {
                [_mainView presentScene:scene];
            }
        });
    }
    
    
}


- (BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
    NSLog(@"MEMORY WARING");
}

@end
