//
//  GamePlayScene.h
//  Rising Fall
//
//  Created by David Villarreal on 5/17/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TextureLoader.h"
#import "ObjectivePanel.h"
#import "LevelFactory.h"
#import "SettingPanel.h"
#import "OptionPanel.h"
#import "ScorePanel.h"
#import "PowerPanel.h"
#import "Spawner.h"
#import "LinkedListNew.h"
#import "PowerTimePanel.h"


@protocol GamePlayDelegate <NSObject>

@required
-(void)quitGameplay;
-(void)beginNextLevel: (int)level;

@end

@interface GamePlayScene : SKScene<OptionPanelDelegate, SettingPanelDelegate, BallDelegate>

@property(nonatomic, weak)id<GamePlayDelegate> mdelegate;

@property PlayerInfo * player;

@property int levelID;
@property int stageAt;
@property int numRows;
@property int powerTypeAt;
@property int power2BallNum;
@property int powerMaxAmount;
@property int nextBallChange;

@property float maxColumns;
@property float firstX;
@property float firstY;
@property float yOffsetPA;
@property float xOffsetPA;

@property NSTimeInterval deltaTime;
@property NSTimeInterval nextTime;
@property NSTimeInterval currentTime;
@property NSTimeInterval nextColorTime;
@property NSTimeInterval nextSpeedTime;
@property NSTimeInterval previousPauseTime;

@property NSMutableArray * ballsArray;
@property NSMutableArray * spwaners;

@property LinkedListNew * movingBallList;

@property BOOL isCreated;
@property BOOL isSettingPanelCreated;
@property BOOL hasFinishCreated;
@property BOOL clickedBegin;
@property BOOL pausedGame;
@property BOOL objectiveReached;
@property BOOL didReachScore;
@property BOOL didWin;
@property BOOL ceilingHit;
@property BOOL didCreateTextView;

@property SKTextureAtlas * gameSceneAtlas;
@property SKTextureAtlas * ballAtlas;

@property SKTexture *playAreaTexture;
@property SKTexture *ceilingTexture;

@property SKSpriteNode * ceiling;
@property SKSpriteNode * playArea;
@property SKSpriteNode * crackSprite;

@property ObjectivePanel * objectivePanel;
@property OptionPanel * optionPanel;
@property SettingPanel * sPanel;
@property ScorePanel * scorePanel;
@property PowerTimePanel * ptPanel;
@property PowerPanel * powerPanel;

@property LevelFactory * levelFactory;

@property Ball * hitBall;

@property CGPoint playAreaPosition;
@property CGPoint powerAreaPosition;
@property CGPoint optionAreaPosition;
@property CGPoint objectivePosition;
@property CGPoint scorePosition;
@property CGPoint ptPosition;
@property CGPoint settingPosition;
@property CGPoint ceilingPosition;

@property TextureLoader * textLoader;



-(void)pauseGame;
-(void)disableBalls;


@end
