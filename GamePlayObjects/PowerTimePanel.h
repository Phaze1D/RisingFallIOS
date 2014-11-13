//
//  PowerTimePanel.h
//  Rising Fall
//
//  Created by David Villarreal on 6/10/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TextureLoader.h"
#import "FontChoicerClass.h"

@interface PowerTimePanel : SKSpriteNode

@property NSTimeInterval time;
@property NSTimeInterval currentTime;
@property NSTimeInterval targetTime;

@property int constantTime;
@property int ballsLeft;
@property int powerType;

@property SKSpriteNode * titlePower;

@property SKLabelNode * timeLeftLabel;
@property SKLabelNode * ballsLeftLabel;

-(BOOL)updateTimer;
-(BOOL)updateBallsLeft;
-(void)createPanelWithTimer;
-(void)createPanelWithBalls;
-(void)resetTimer;
-(void)resetBalls;


@end
