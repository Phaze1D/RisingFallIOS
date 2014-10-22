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
    
    int fontsize = 16;
    _currentScore = 0;
    _targetScore = targetScore;
    
    NSMutableString * stringL = [[NSMutableString alloc]init];
    
    [stringL appendString:NSLocalizedString(@"Score:", nil)];
    [stringL appendFormat:@" %d/%d", _currentScore, _targetScore];
    
    _titleLabel = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    _titleLabel.fontColor = [UIColor whiteColor];
    _titleLabel.fontSize = fontsize;
    _titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _titleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _titleLabel.zPosition = 2;
    _titleLabel.text = stringL;
    _titleLabel.position = CGPointMake(-_titleLabel.frame.size.width/1.5, -self.size.height/2);
    [self addChild: _titleLabel];

    
}

//Updates the current score
-(void)updateScore:(int)addScore{
    _currentScore = _currentScore + addScore;
    
    NSMutableString * stringL = [[NSMutableString alloc]init];
    
    [stringL appendString:NSLocalizedString(@"Score:", nil)];
    [stringL appendFormat:@" %d/%d", _currentScore, _targetScore];
    _titleLabel.text = stringL;
    
    if (_currentScore >= _targetScore && !_reachYet) {
        //Create score reach animation
        _reachYet = YES;
        _titleLabel.alpha = 0;
        
        SKLabelNode * reachL = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
        reachL.fontColor = [UIColor whiteColor];
        reachL.alpha = 1;
        reachL.position = CGPointMake(-self.size.width/2, -self.size.height/2);
        reachL.fontSize = 9;
        reachL.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        reachL.text = [NSString stringWithFormat:@"%d", _targetScore];
        SKAction * fadeIn = [SKAction fadeAlphaTo:0 duration:1.5];
        SKAction * resizeB = [SKAction scaleBy:6 duration:1.5];
        SKAction * group = [SKAction group:@[fadeIn, resizeB]];
        [self addChild:reachL];
        
        
        [reachL runAction:group completion:^{
            
                _titleLabel.alpha = 1;
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
    [_titleLabel runAction:[SKAction repeatActionForever:group]];
    
}


-(void)clearAll{
    [self removeAllActions];
    [self removeAllChildren];
}

@end
