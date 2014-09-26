//
//  LevelsScene.h
//  Rising Fall
//
//  Created by David Villarreal on 5/2/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TextureLoader.h"
#import "ButtonNode.h"
#import "LevelButton.h"
#import "PlayerInfo.h"
#import "GameData.h"
#import "LifePanel.h"

@protocol LevelsSceneDelegate<NSObject>

@required
-(void)navigationPressed;
-(void)beginGamePlay: (int)levelID;

@end

@interface LevelsScene : SKScene <ButtonDelegate, LevelButtonDelegate>

@property(nonatomic, weak) id<LevelsSceneDelegate> mdelegate;

@property PlayerInfo * player;

@property BOOL isCreated;
@property BOOL isSubCreated;
@property BOOL hasCreatedScene;

@property SKTextureAtlas * sceneAtlas;
@property SKTextureAtlas * buttonAtlas;

@property ButtonNode * navigationB;

@property CGPoint naviBPostion;

@property NSMutableArray * levelBPostions;
@property NSMutableArray * subLevelBPosition;
@property NSMutableArray * parentLevelButtons;
@property NSMutableArray * childLevelButtons;

@property LifePanel * lifeP;


@end
