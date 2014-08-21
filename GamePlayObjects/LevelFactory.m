//
//  LevelFactory.m
//  Rising Fall
//
//  Created by David Villarreal on 5/17/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "LevelFactory.h"

@implementation LevelFactory


-(id)initLevelNumber:(int)levelNumber{
    
    if (self = [super init]) {
        
        [self initVariables: levelNumber];
    }
    
    
    return self;
}

//Init the variables that will create a certian level
-(void)initVariables: (int) levelNumber{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"testing"
                                                     ofType:@"txt"];
    
    NSCharacterSet *newlineCharSet = [NSCharacterSet newlineCharacterSet];
    NSString* fileContents = [NSString stringWithContentsOfFile:path
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
    
    NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:newlineCharSet];
    NSArray * line = [[lines objectAtIndex:levelNumber] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    _gameObjective = [[line objectAtIndex:0] intValue];
    _gameType = [[line objectAtIndex:1] intValue];
    _velocity = [[line objectAtIndex:2] intValue];
    _dropRate = [[line objectAtIndex:3] floatValue];
    _ceilingHeight = [[line objectAtIndex:4] intValue];
    _gameTime = [[line objectAtIndex:5] intValue];
    _numOfColumns = [[line objectAtIndex:6] intValue];
    _numberOfBalls = [[line objectAtIndex:7] intValue];
    _targetScore = [[line objectAtIndex:8] intValue];
    _initFill = [[line objectAtIndex:9] floatValue];
    _doubleBallProb = [[line objectAtIndex:10] floatValue];
    _changeColorTime = [[line objectAtIndex:11] floatValue];
    _unMovableProb = [[line objectAtIndex:12] floatValue];
    _finalSpeed = [[line objectAtIndex:13] floatValue];
    _finalDRate = [[line objectAtIndex:14] floatValue];
    _changeRate = [[line objectAtIndex:15] floatValue];
    _powerBallDrop = arc4random_uniform(4);
    
 
    [self calculateChangeSpeedTime];
    
}

//Calculates the time that a speed and drop rate should happen
-(void)calculateChangeSpeedTime{
    if (_gameType == 1) {
         _changeSpeedTime = _gameTime/_changeRate;
    }else if (_gameType == 2){
        _changeSpeedBNum = _numberOfBalls / _changeRate;
    }
    _incrementS = (_finalSpeed - _velocity)/(_changeRate - 1);
    _incrementD = (_finalDRate - _dropRate)/(_changeRate - 1);
}

//Changes the speed and drop rate
-(void)changeSpeedAndDrop{
    if (_velocity + _incrementS > 0  && _velocity != _finalSpeed) {
        _velocity = _velocity + _incrementS;
    }
    
    if (_dropRate + _incrementD > 0 && _dropRate != _finalDRate) {
        _dropRate = _dropRate + _incrementD;
    }
}


@end
