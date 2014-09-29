//
//  LifePanel.h
//  Rising Fall
//
//  Created by David Villarreal on 7/28/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameData.h"
#import "TextureLoader.h"
#import "ButtonNode.h"
#import "PaymentClass.h"

@interface LifePanel : SKSpriteNode<ButtonDelegate, PaymentClassDelegate>

@property NSTimeInterval timeLeft;

@property SKLabelNode * timeL;

@property ButtonNode * buyB;

-(void)createLifePanel;
-(void)createTimePanel;
-(void)runActionWarning;
-(void)updateTime;
-(void)clearAll;

@end
