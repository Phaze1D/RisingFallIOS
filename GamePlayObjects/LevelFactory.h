//
//  LevelFactory.h
//  Rising Fall
//
//  Created by David Villarreal on 5/17/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LevelFactory : NSObject

@property float velocity;
@property float initFill;
@property float powerBallDrop;
@property float doubleBallProb;
@property float unMovableProb;
@property float dropRate;
@property float finalSpeed;
@property float finalDRate;
@property float changeRate;
@property float incrementS;
@property float incrementD;

@property NSTimeInterval gameTime;
@property NSTimeInterval changeColorTime;
@property NSTimeInterval changeSpeedTime;

@property int changeSpeedBNum;
@property int ceilingHeight;
@property int numOfColumns;
@property int gameType;
@property int numberOfBalls;
@property int targetScore;
@property int gameObjective;

@property BOOL velocityGreater;
@property BOOL velocityLess;
@property BOOL dropGreater;
@property BOOL dropLess;

-(id)initLevelNumber: (int) levelNumber;
-(void)changeSpeedAndDrop;

@end
