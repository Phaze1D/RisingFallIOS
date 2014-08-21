//
//  ScorePanel.m
//  Rising Fall
//
//  Created by David Villarreal on 5/25/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "ScorePanel.h"

@implementation ScorePanel


-(void)createScorePanel:(int)targetScore{
    
    int fontsize = 11;
    _currentScore = 0;
    _targetScore = targetScore;
    _titleLabel = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    _titleLabel.fontColor = [UIColor blackColor];
    _titleLabel.position = CGPointMake(self.size.width/2, self.size.height*4.0/7);
    _titleLabel.fontSize = fontsize;
    _titleLabel.zPosition = 2;
    _titleLabel.text = NSLocalizedString(@"score", nil);
    [self addChild: _titleLabel];
    
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    _scoreLabel.fontColor = [UIColor blackColor];
    _scoreLabel.position = CGPointMake(self.size.width/2, self.size.height/7.0);
    _scoreLabel.fontSize = fontsize;
    _scoreLabel.zPosition = 2;
    _scoreLabel.text = [NSString stringWithFormat:@"%d/%d", 0, targetScore];
    [self addChild:_scoreLabel];
    
}

//Updates the current score
-(void)updateScore:(int)addScore{
    _currentScore = _currentScore + addScore;
    _scoreLabel.text = [NSString stringWithFormat:@"%d/%d", _currentScore, _targetScore];
    
    if (_currentScore >= _targetScore && !_reachYet) {
        //Create score reach animation
        _reachYet = YES;
        _titleLabel.alpha = 0;
        _scoreLabel.alpha = 0;
        
        SKLabelNode * reachL = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
        reachL.fontColor = [UIColor blackColor];
        reachL.alpha = 1;
        reachL.position = CGPointMake(self.size.width/2, self.size.height/2);
        reachL.fontSize = 9;
        reachL.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        reachL.text = [NSString stringWithFormat:@"%d", _targetScore];
        SKAction * fadeIn = [SKAction fadeAlphaTo:0 duration:1.5];
        SKAction * resizeB = [SKAction scaleBy:6 duration:1.5];
        SKAction * group = [SKAction group:@[fadeIn, resizeB]];
        [self addChild:reachL];
        
        
        [reachL runAction:group completion:^{
            
                _titleLabel.alpha = 1;
                _scoreLabel.alpha = 1;
                [reachL removeFromParent];
        }];

        
        

        
    }
    
}

//Called when the objective is done and checks to see if the player reach the min score
-(BOOL)didReachScore{
    if (_currentScore >= _targetScore) {
        return YES;
    }else{
        return NO;
    }
}

//Runs a short animation if the player did not reach the target score at the end of a game
-(void)didNotReachAnimation{
    SKAction * scaleUp = [SKAction scaleTo:1.8 duration:1];
    SKAction * scaleDown = [SKAction scaleTo:1 duration:1];
    SKAction * group = [SKAction sequence:@[scaleUp, scaleDown]];
    [_scoreLabel runAction:[SKAction repeatActionForever:group]];
    
}


-(void)clearAll{
    [self removeAllActions];
    [self removeAllChildren];
}

@end
