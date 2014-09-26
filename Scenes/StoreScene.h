//
//  StoreScene.h
//  Rising Fall
//
//  Created by David Villarreal on 7/22/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <StoreKit/StoreKit.h>
#import "Spawner.h"
#import "ButtonNode.h"
#import "StoreBuyPanel.h"
#import "SellItemPanel.h"
#import "PaymentClass.h"

@protocol StoreSceneDelegate <NSObject>

@required
-(void)storeBackPressed;

@end



@interface StoreScene : SKScene <ButtonDelegate, StoreBuyPanelDelegate>

@property(nonatomic, weak) id<StoreSceneDelegate> mdelegate;

@property BOOL isCreated;
@property BOOL hasFinishCreated;
@property BOOL isSellCreated;

@property SKTextureAtlas * sceneAtlas;

@property NSMutableArray * spawners;
@property NSMutableArray * ballQuene;

@property NSTimeInterval deltaTime;
@property NSTimeInterval passTime;

@property CGVector velocity;

@property float spawnRate;

@property CGPoint sidePositions;
@property CGPoint backButtonPosition;
@property CGPoint initPointSellPanel;

@property StoreBuyPanel * buyPanel;
@property SellItemPanel * sellItemP;

@property ButtonNode * backB;

-(void)disableBack;
-(void)enableBack;

@end
