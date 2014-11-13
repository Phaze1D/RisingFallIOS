//
//  ScorePanel.h
//  Rising Fall
//
//  Created by David Villarreal on 5/25/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "FontChoicerClass.h"

@interface ScorePanel : SKSpriteNode

@property int currentScore;
@property int targetScore;

@property BOOL reachYet;

@property SKLabelNode * titleLabel;


-(void)createScorePanel: (int)targetScore;
-(BOOL)didReachScore;
-(void)didNotReachAnimation;
-(void)updateScore:(int)addScore;
-(void)clearAll;

@end
