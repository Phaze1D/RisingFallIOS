//
//  ViewController.h
//  Rising Fall
//

//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "TextureLoader.h"
#import "StartScene.h"
#import "LevelsScene.h"
#import "GamePlayScene.h"
#import "StoreScene.h"
#import <iAd/iAd.h>

@interface ViewController : UIViewController <StartSceneDelegate,LevelsSceneDelegate, GamePlayDelegate,StoreSceneDelegate, ADBannerViewDelegate>

@property SKView * mainView;
@property StoreScene * storeScene;
@property BOOL bannerIsVisible;
@property ADBannerView * banner;
@property PaymentClass * paymentClass;


@end
