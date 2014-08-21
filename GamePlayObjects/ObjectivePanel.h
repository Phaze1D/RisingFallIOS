//
//  ObjectivePanel.h
//  Rising Fall
//
//  Created by David Villarreal on 5/25/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ObjectivePanel : SKSpriteNode

@property NSTimeInterval time;
@property NSTimeInterval futureTime;


@property int ballsLeft;
@property int gameType;
@property (readonly) int fontSize;

@property SKLabelNode * titleNode;
@property SKLabelNode * objectiveNode;

-(void)initVariables;
-(BOOL)updateObjective;
-(void)clearAll;
@end
