//
//  StartScene.h
//  Rising Fall
//
//  Created by David Villarreal on 4/27/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TextureLoader.h"
#import "ButtonNode.h"
#import "SocialMediaButton.h"
#import "Spawner.h"


@protocol StartSceneDelegate <NSObject>

@required
-(void)playButtonPressed;
-(void)storeButtonPressed;

@end

@interface StartScene : SKScene <ButtonDelegate, SocialMediaDelegate>

@property(nonatomic, weak) id<StartSceneDelegate> mdelegate;

@property TextureLoader * textLoad;

@property SKTextureAtlas * startAtlas;
@property SKTextureAtlas * socialAtlas;
@property SKTextureAtlas * ballAtlas;

@property SKTexture * playImage;
@property SKTexture * playPressedImage;
@property SKTexture * storeImage;
@property SKTexture * storeImagePressed;


@property BOOL isCreated;
@property BOOL isSocialSubCreated;
@property BOOL hasFinishCreated;

@property CGPoint titlePosition;
@property CGPoint playButtonPosition;
@property CGPoint socialButtonPosition;
@property CGPoint storeButtonPosition;

@property NSMutableArray * socialSubPositions;
@property NSMutableArray * socialSubNodes;
@property NSMutableArray * spawners;
@property NSMutableArray * ballQuene;

@property ButtonNode * playButton;
@property ButtonNode * storeButton;

@property Ball * sBall;
@property BOOL testB;

@property SocialMediaButton * socialMediaB;

@property float socialSubAnimationDuration;
@property float spawnRate; // .5 means 2 balls per second

@property NSTimeInterval deltaTime;
@property NSTimeInterval passTime;


@property CGVector velocity;

-(void)enbableChild;

@end
