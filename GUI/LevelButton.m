//
//  LevelButton.m
//  Rising Fall
//
//  Created by David Villarreal on 5/3/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "LevelButton.h"

@implementation LevelButton





-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.alpha = .5;
    [self runAction:[SKAction playSoundFileNamed:@"buttonSound.wav" waitForCompletion:NO]];
    NSLog(@"Level buttonpressed");
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.alpha = 1;
    
        if (!_isChild) {
            [self.subDelegate parentPressed: _parentNumber];
        }else{
            [self.subDelegate childPressed:_levelNumber];
        }
}

-(void)currentLevelAnimation{
    SKAction * scaleUp = [SKAction scaleTo:1.1 duration:.6];
    SKAction * scaleDown = [SKAction scaleTo:.9 duration:.6];
    
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[scaleUp, scaleDown]]]];
}


@end
