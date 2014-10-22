//
//  PowerPanel.h
//  Rising Fall
//
//  Created by David Villarreal on 5/25/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TextureLoader.h"
#import "Ball.h" 
#import "GameData.h"
#import "SizeManager.h"

@interface PowerPanel : SKSpriteNode

@property PlayerInfo * player;
@property TextureLoader * textLoad;

@property NSMutableArray * powerBalls;

-(void)createPanel;
-(void)clearAll;

@end
