//
//  ObjectivePanel.m
//  Rising Fall
//
//  Created by David Villarreal on 5/25/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "ObjectivePanel.h"

@implementation ObjectivePanel

-(void)initVariables{
    
    NSString * titleString;
    
    if(_gameType == 2){
        titleString = NSLocalizedString(@"ballsLeft", nil);
    }else{
        titleString = NSLocalizedString(@"timeLeft", nil);
    }
    
    _fontSize = 11;
    
    _titleNode = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    _titleNode.fontSize = _fontSize;
    _titleNode.fontColor = [UIColor blackColor];
    _titleNode.position = CGPointMake(self.size.width/2, self.size.height*4.0/7);
    _titleNode.text = titleString;
    [self addChild:_titleNode];
    
    _objectiveNode = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    _objectiveNode.fontSize = _fontSize;
    _objectiveNode.fontColor = [UIColor blackColor];
    _objectiveNode.position = CGPointMake(self.size.width/2, self.size.height/7.0);
    
    if (_gameType == 2) {
        _objectiveNode.text = [NSString stringWithFormat:@"%d", _ballsLeft];
    }else{
        int minutes = _time/60;
        int seconds = _time - minutes*60;
        _objectiveNode.text = [NSString stringWithFormat:@"%02d:%02d",minutes, seconds ]; // Should present the time in MM:SS
    }

    
    [self addChild:_objectiveNode];
    
    
}


//Checks and updates the game objective
-(BOOL)updateObjective{
    
    
    if (_gameType == 2) {
        _objectiveNode.text = [NSString stringWithFormat:@"%d", _ballsLeft];
    }else{
        int minutes = _time/60;
        int seconds = _time - minutes*60;
        _objectiveNode.text = [NSString stringWithFormat:@"%02d:%02d",minutes, seconds ];
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        _time = _futureTime - date.timeIntervalSince1970;
    }
    
    
    if (_gameType == 2 && _ballsLeft <= 0) {
        _ballsLeft = 0;
        _objectiveNode.text = [NSString stringWithFormat:@"%d", _ballsLeft];
        return YES;
    }else if (_gameType == 1 && _time < 0){
        _time  = 0;
        int minutes = _time/60;
        int seconds = _time - minutes*60;
        _objectiveNode.text = [NSString stringWithFormat:@"%02d:%02d",minutes, seconds ];
        return YES;
    }


    return NO;
    
}


-(void)clearAll{
    [self removeAllActions];
    [self removeAllChildren];
    
}

@end
