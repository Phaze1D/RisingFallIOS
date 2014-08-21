//
//  LifePanel.m
//  Rising Fall
//
//  Created by David Villarreal on 7/28/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "LifePanel.h"

@implementation LifePanel

//Creates the panel if the player has lifes
-(void)createLifePanel{
    
    int fontSize = 19;
    GameData * info = [GameData sharedGameData];

    
    SKLabelNode * title = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    title.text = NSLocalizedString(@"Lifesk", nil);
    title.fontColor = [UIColor blackColor];
    title.fontSize = fontSize;
    title.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    title.position = CGPointMake(0, self.size.height/3);
    [self addChild:title];
    
    SKLabelNode * lifes = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    lifes.text = [NSString stringWithFormat:@"%d", info.player.lifesLeft ];
    lifes.fontColor = [UIColor blackColor];
    lifes.position = CGPointMake(0, -self.size.height/3);
    lifes.fontSize = fontSize;
    lifes.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
    [self addChild:lifes];
    
}

-(void)createTimePanel{
    
    int fontSize = 12;
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    GameData * info = [GameData sharedGameData];

    _timeLeft = info.player.timeLeftOnLifes - date.timeIntervalSince1970;

    
    int minutes = _timeLeft/60;
    int seconds = _timeLeft - minutes*60;
    
    SKLabelNode * title = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    title.text = NSLocalizedString(@"Lifesk", nil);
    title.fontColor = [UIColor blackColor];
    title.fontSize = fontSize;
    title.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    title.position = CGPointMake(0, self.size.height/3);
    [self addChild:title];
    
    _timeL = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    _timeL.position = CGPointMake(0, 0);
    _timeL.text = [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
    _timeL.fontSize = fontSize;
    _timeL.fontColor = [UIColor blackColor];
    _timeL.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [self addChild: _timeL];

    SKTextureAtlas * buttonA  = [[TextureLoader shareTextureLoader] buttonAtlas];
    
    ButtonNode * buyB = [ButtonNode spriteNodeWithTexture: [buttonA textureNamed:@"buttonXS1"]];
    buyB.position = CGPointMake( 0, -self.size.height/3);
    buyB.userInteractionEnabled = YES;
    buyB.delegate = self;
    [buyB setImages:[buttonA textureNamed:@"buttonXS1"] pressedImage:[buttonA textureNamed:@"buttonXS1"]];
    [buyB setText:NSLocalizedString(@".99k", nil)];
    [self addChild: buyB];

    
}

//Updates the time left
-(void)updateTime{
    
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    GameData * info = [GameData sharedGameData];
    _timeLeft = info.player.timeLeftOnLifes - date.timeIntervalSince1970;
    
    if (_timeLeft >  0) {
        int minutes = _timeLeft/60;
        int seconds = _timeLeft - minutes*60;
         _timeL.text = [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
    }else{
        GameData * info = [GameData sharedGameData];
        info.player.lifesLeft = 5;

        [self clearAll];
        [self createLifePanel];
    }
    
}

-(void)runActionWarning{
   
    SKAction * scaleUp = [SKAction scaleTo:1.5 duration:.5];
    SKAction * scaleD = [SKAction scaleTo:1 duration:.5];
    SKAction * group = [SKAction sequence:@[scaleUp, scaleD]];
    [_timeL runAction:group];
    
}

-(void)clearAll{
    [self removeAllActions];
    [self removeAllChildren];
}

//Pressed when the buy Button is pressed
-(void)buttonPressed:(ButtonType)type{
    PaymentClass * payment = [[PaymentClass alloc] init];
    if ([payment payDollar]) {
        GameData * info = [GameData sharedGameData];
        info.player.lifesLeft = 5;
        info.player.timeLeftOnLifes = 0;
        
        [self clearAll];
        [self createLifePanel];

    }
}


@end
