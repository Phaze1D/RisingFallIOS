//
//  Spawner.m
//  Rising Fall
//
//  Created by David Villarreal on 4/30/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "Spawner.h"


@implementation Spawner
@synthesize position, powerupProb;




-(id)initWithLevel: (int)levelAt;
{
    if (self = [super init])
    {
        _levelAt = levelAt;
        _textLoad = [TextureLoader shareTextureLoader];
        [self setup];
    }
    return self;
}

//Setups up the spawner
-(void)setup{
     NSSortDescriptor * sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    _stopSpawningPower = NO;
    _ballAtlas = [_textLoad ballsAtlas];
    _powerAtlas = [_textLoad powerBallAtlas];
    
    if (_levelAt >= 18) {
        _badBallAtlas = [_textLoad badBallAtlas];
    }
    
    if (_levelAt >= 50) {
        _unBallAtlas = [_textLoad unmovableBallAtlas];
    }
    
    _pTextures = [_powerAtlas textureNames];
    _pTextures = [_pTextures sortedArrayUsingDescriptors:@[sd]];
    _size = [[SizeManager sharedSizeManager] getBallSize];
}

//Spawns random ball
-(Ball *)spawnBall{
    
    double powerTest = arc4random_uniform(100);
    
    if (powerTest <= powerupProb && !_stopSpawningPower) {
        int powerType = arc4random_uniform(5);
        Ball * ball = [Ball spriteNodeWithTexture: [_powerAtlas textureNamed:[_pTextures objectAtIndex:powerType]]];
        ball.position = position;
        ball.zPosition = 2;
        ball.anchorPoint = CGPointMake(0, 0);
        ball.column = _column;
        ball.isPowerBall = YES;
        ball.powerBallType = powerType + 1;
        ball.ballColor = -1;
        ball.size = CGSizeMake(ball.size.width/2, ball.size.height/2);
        return ball;
        
    }else{
    
        int randIndex = arc4random_uniform((unsigned)[_ballAtlas textureNames].count);
        double dp = arc4random_uniform(100);
        double un = arc4random_uniform(100);
        
        if (dp < _doubleBallProb && _levelAt >= 18 ) {
            Ball * ball = [Ball spriteNodeWithTexture: [_badBallAtlas textureNamed: [NSString stringWithFormat:@"badBall%d", randIndex]]];
            ball.doubleTexture = [_ballAtlas textureNamed:[NSString stringWithFormat:@"ball%d", randIndex]];
            ball.position = position;
            ball.anchorPoint = CGPointMake(0, 0);
            ball.zPosition = 2;
            ball.column = _column;
            ball.ballColor = randIndex;
            ball.size = CGSizeMake(ball.size.width/2, ball.size.height/2);
            ball.isDoubleBall = YES;
            return ball;
            
        }
        
        if(un < _unMovableProb && _levelAt >= 50){
            Ball * ball = [Ball spriteNodeWithTexture: [_unBallAtlas textureNamed: [NSString stringWithFormat:@"unBall%d", randIndex]]];
            ball.position = position;
            ball.zPosition = 2;
            ball.anchorPoint = CGPointMake(0, 0);
            ball.column = _column;
            ball.ballColor = randIndex;
            ball.size = CGSizeMake(ball.size.width/2, ball.size.height/2);
            ball.isUnMoveable = YES;
            return ball;
        
        }
        
        Ball * ball = [Ball spriteNodeWithTexture: [_ballAtlas textureNamed:[NSString stringWithFormat:@"ball%d", randIndex]]];
        ball.position = position;
        ball.zPosition = 2;
        ball.anchorPoint = CGPointMake(0, 0);
        ball.column = _column;
        ball.ballColor = randIndex;
        ball.size = [[SizeManager sharedSizeManager] getBallSize];
        return ball;
        
    }
    
    
}


//Spawns a specific type of ball used in powertype 2
-(Ball *)spawnSpecificBall: (int) balltype{
    
    Ball * ball = [Ball spriteNodeWithTexture: [_ballAtlas textureNamed:[NSString stringWithFormat:@"ball%d", balltype]]];
    ball.position = position;
    ball.zPosition = 1;
    ball.size = [[SizeManager sharedSizeManager] getBallSize];
    ball.anchorPoint = CGPointMake(0, 0);
    ball.column = _column;
    ball.ballColor = balltype;
    return ball;

    
}

//Clears for memory
-(void)clearAll{
    _ballAtlas = nil;
    _badBallAtlas = nil;
    _powerAtlas = nil;
    _unBallAtlas = nil;
}


@end
