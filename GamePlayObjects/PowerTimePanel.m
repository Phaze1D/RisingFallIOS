//
//  PowerTimePanel.m
//  Rising Fall
//
//  Created by David Villarreal on 6/10/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "PowerTimePanel.h"

@implementation PowerTimePanel

-(void)createPanelWithTimer{
     NSSortDescriptor * sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    SKTextureAtlas * atlas = [[TextureLoader shareTextureLoader] powerBallAtlas];
    
    NSArray * names = [atlas textureNames];
    names = [names sortedArrayUsingDescriptors:@[sd]];
    
    SKTexture * text = [atlas textureNamed:[names objectAtIndex:_powerType -1]];
    
    _titlePower = [SKSpriteNode spriteNodeWithTexture:text];
    _titlePower.position = CGPointMake(self.size.width/2, self.size.height/2);
    _titlePower.size = CGSizeMake(text.size.width/1.5, text.size.height/1.5);
    _titlePower.anchorPoint = CGPointMake(.5, 0);
    [self addChild:_titlePower];
    
    _constantTime = 11;
    _timeLeftLabel = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    _timeLeftLabel.fontColor = [UIColor blackColor];
    _timeLeftLabel.fontSize = 11;
    _timeLeftLabel.position = CGPointMake(self.size.width/2, self.size.height/7.0);
    _timeLeftLabel.text = [NSString stringWithFormat:@"%02d:%02d",0, _constantTime];
    _targetTime = _constantTime + _currentTime;
    [self addChild:_timeLeftLabel];
    
    
}

-(void)createPanelWithBalls{
    NSSortDescriptor * sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    SKTextureAtlas * atlas = [[TextureLoader shareTextureLoader] powerBallAtlas];
    NSArray * names = [atlas textureNames];
    names = [names sortedArrayUsingDescriptors:@[sd]];
    
    SKTexture * text = [atlas textureNamed:[names objectAtIndex:_powerType -1]];
    
    _titlePower = [SKSpriteNode spriteNodeWithTexture:text];
    _titlePower.position = CGPointMake(self.size.width/2, self.size.height/2);
    _titlePower.size = CGSizeMake(text.size.width/1.5, text.size.height/1.5);
    _titlePower.anchorPoint = CGPointMake(.5, 0);
    [self addChild:_titlePower];
    
    _ballsLeft = 10;
    
    _ballsLeftLabel = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    _ballsLeftLabel.fontColor = [UIColor blackColor];
    _ballsLeftLabel.fontSize = 11;
    _ballsLeftLabel.position = CGPointMake(self.size.width/2, self.size.height/7.0);
    _ballsLeftLabel.text = [NSString stringWithFormat:@"%d", _ballsLeft];
    [self addChild:_ballsLeftLabel];

    
}

-(BOOL)updateBallsLeft{
    _ballsLeft--;
    
    
    if (_ballsLeft <= 0 ) {
        _ballsLeft = 0;
        _ballsLeftLabel.text = [NSString stringWithFormat:@"%d", _ballsLeft];
        return YES;
    }else{
        _ballsLeftLabel.text = [NSString stringWithFormat:@"%d", _ballsLeft];
        return NO;
    }

    return YES;
}

-(BOOL)updateTimer{
    _time = _targetTime - _currentTime;
   
    
    if (_time <= 0 ) {
        _time = 0;
        _timeLeftLabel.text = [NSString stringWithFormat:@"%02d:%02d",0, (int)_time];
        return YES;
    }else{
        _timeLeftLabel.text = [NSString stringWithFormat:@"%02d:%02d",0, (int)_time];
        return NO;
    }
}

-(void)resetTimer{
    if (_timeLeftLabel != nil) {
        _targetTime = _constantTime + _currentTime;
        [self removeAllChildren];
        [self createPanelWithTimer];
    }else{
        [self removeAllChildren];
        _titlePower = nil;
        [self createPanelWithTimer];
    }
    _ballsLeftLabel = nil;
}

-(void)resetBalls{
    if (_ballsLeftLabel != nil) {
        _ballsLeft = 11;
        [self removeAllChildren];
        [self createPanelWithBalls];
        
    }else{
        [self removeAllChildren];
        _titlePower = nil;
        [self createPanelWithBalls];
        
    }
    
    _timeLeftLabel = nil;
    
}

//Clears all the data
-(void)clearAll{
    [self removeAllActions];
    [self removeAllChildren];
}

@end
