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
    
    NSMutableString * titleString = [[NSMutableString alloc] init];
    
    if(_gameType == 2){
        [titleString appendString: NSLocalizedString(@"Balls Left:", nil)];
        
    }else{
         [titleString appendString: NSLocalizedString(@"Time Left:", nil)];
    }
    
    _fontSize = 16;
    
    _titleNode = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    _titleNode.fontSize = _fontSize;
    _titleNode.fontColor = [UIColor blackColor];
    _titleNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _titleNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    
    if (_gameType == 2) {
        [titleString appendFormat: @" %d", _ballsLeft];
    }else{
        int minutes = _time/60;
        int seconds = _time - minutes*60;
        [titleString appendFormat:@" %02d:%02d",minutes, seconds];
    }

    [_titleNode setText:titleString];
     _titleNode.position = CGPointMake(_titleNode.frame.size.width/1.75, -self.size.height/2);
    [self addChild:_titleNode];
    
}


//Checks and updates the game objective
-(BOOL)updateObjective{
    
    NSMutableString * titleString = [[NSMutableString alloc] init];
    
    if(_gameType == 2){
        [titleString appendString: NSLocalizedString(@"Balls Left:", nil)];
        
    }else{
        [titleString appendString: NSLocalizedString(@"Time Left:", nil)];
    }

    
    
    if (_gameType == 2) {
        
        [titleString appendFormat:@" %d", _ballsLeft];
        _titleNode.text = titleString;
    }else{
        int minutes = _time/60;
        int seconds = _time - minutes*60;
         [titleString appendFormat:@" %02d:%02d",minutes, seconds];
        _titleNode.text = titleString;
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        _time = _futureTime - date.timeIntervalSince1970;
    }
    
    
    if (_gameType == 2 && _ballsLeft <= 0) {
        _ballsLeft = 0;
        [titleString appendFormat:@" %d", _ballsLeft];
        _titleNode.text = titleString;
        return YES;
    }else if (_gameType == 1 && _time < 0){
        _time  = 0;
        int minutes = _time/60;
        int seconds = _time - minutes*60;
        [titleString appendFormat:@" %02d:%02d",minutes, seconds];
        _titleNode.text = titleString;
        return YES;
    }


    return NO;
    
}


-(void)clearAll{
    [self removeAllActions];
    [self removeAllChildren];
    
}

@end
