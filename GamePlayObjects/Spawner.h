//
//  Spawner.h
//  Rising Fall
//
//  Created by David Villarreal on 4/30/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ball.h"
#import "TextureLoader.h"
#import "SizeManager.h"


@interface Spawner : NSObject

@property TextureLoader * textLoad;

@property BOOL stopSpawningPower; 


@property CGPoint position;
@property CGSize size;

@property int column;
@property int levelAt;

@property float powerupProb;
@property float doubleBallProb;
@property float unMovableProb;

@property SKTextureAtlas * ballAtlas;
@property SKTextureAtlas * powerAtlas;
@property SKTextureAtlas * badBallAtlas;
@property SKTextureAtlas * unBallAtlas;

@property (strong) NSArray * pTextures;


-(id)initWithLevel: (int)levelAt;
-(Ball *)spawnBall;
-(Ball *)spawnSpecificBall: (int) balltype;
-(void)setup;
-(void)clearAll;


@end

