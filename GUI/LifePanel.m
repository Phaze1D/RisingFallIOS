//
//  LifePanel.m
//  Rising Fall
//
//  Created by David Villarreal on 7/28/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "LifePanel.h"
#import "LevelsScene.h"

@implementation LifePanel

//Creates the panel if the player has lifes
-(void)createLifePanel{
    
    int fontSize = [[FontChoicerClass shareFontChoicer] fontLifePanelLifes];
    GameData * info = [GameData sharedGameData];

    
//    SKLabelNode * title = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
//    title.text = NSLocalizedString(@"Lifes Left", nil);
//    title.fontColor = [UIColor whiteColor];
//    title.fontSize = fontSize;
//    title.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
//    title.position = CGPointMake(0, 0);
//    [self addChild:title];
    
    SKSpriteNode * heart = [SKSpriteNode spriteNodeWithTexture:[[[TextureLoader shareTextureLoader] levelSceneAtlas] textureNamed:@"heart"]];
    heart.size = CGSizeMake(heart.size.width/2, heart.size.height/2);
    heart.position = CGPointMake(0, 0);
    [self addChild:heart];
    
    SKLabelNode * lifes = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    lifes.text = [NSString stringWithFormat:@"%d", info.player.lifesLeft ];
    lifes.fontColor = [UIColor whiteColor];
    lifes.position = CGPointMake(0, 0);
    lifes.fontSize = fontSize;
    lifes.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    [self addChild:lifes];
    
}

-(void)createTimePanel{
    
    int fontSize = [[FontChoicerClass shareFontChoicer] fontLifePanelLifes];;
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    GameData * info = [GameData sharedGameData];

    _timeLeft = info.player.timeLeftOnLifes - date.timeIntervalSince1970;

    
    int minutes = _timeLeft/60;
    int seconds = _timeLeft - minutes*60;
    
//    SKLabelNode * title = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
//    title.text = NSLocalizedString(@"Lifes Left", nil);
//    title.fontColor = [UIColor whiteColor];
//    title.fontSize = fontSize;
//    title.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
//    title.position = CGPointMake(0, self.size.height/3);
//    [self addChild:title];
    
    SKSpriteNode * heart = [SKSpriteNode spriteNodeWithTexture:[[[TextureLoader shareTextureLoader] levelSceneAtlas] textureNamed:@"heart"]];
    heart.size = CGSizeMake(heart.size.width/2, heart.size.height/2);
    heart.position = CGPointMake(0, 0);
    [self addChild:heart];

    
    _timeL = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    _timeL.position = CGPointMake(0, self.size.height/3);
    _timeL.text = [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
    _timeL.fontSize = fontSize;
    _timeL.fontColor = [UIColor whiteColor];
    _timeL.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _timeL.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    [self addChild: _timeL];
    
    SKLabelNode * lifes = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    lifes.text = [NSString stringWithFormat:@"%d", info.player.lifesLeft ];
    lifes.fontColor = [UIColor whiteColor];
    lifes.position = CGPointMake(0, 0);
    lifes.fontSize = fontSize;
    lifes.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    [self addChild:lifes];
    
   
    SKTextureAtlas * buttonA  = [[TextureLoader shareTextureLoader] buttonAtlas];
    
    _buyB = [ButtonNode spriteNodeWithTexture: [buttonA textureNamed:@"buttonS1B"]];
    _buyB.position = CGPointMake( 0, -self.size.height/3);
    _buyB.userInteractionEnabled = YES;
    _buyB.delegate = self;
    _buyB.size = CGSizeMake(_buyB.size.width/2, _buyB.size.height/2);
    [_buyB setImages:[buttonA textureNamed:@"buttonS1B"] pressedImage:[buttonA textureNamed:@"buttonS2B"]];
    [_buyB setText:NSLocalizedString(@".99", nil)];
    [self addChild: _buyB];

    
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
    [((LevelsScene *)self.parent) disableButtons];
    _buyB.userInteractionEnabled = NO;
    PaymentClass * paymentClass = [PaymentClass sharePaymentClass];
    paymentClass.delegate = self;
    [paymentClass beginBuyFlow: @"com.Phaze1D.RisingFall.Lifes"];
}

-(void)buyTransctionFinished:(BOOL)didBuy{
    [((LevelsScene *)self.parent) enableButtons];
    _buyB.userInteractionEnabled = YES;
    if (didBuy) {
        GameData * info = [GameData sharedGameData];
        info.player.lifesLeft =+ 5;
        info.player.timeLeftOnLifes = 0;
        
        [self clearAll];
        [self createLifePanel];
        
    }
}

@end
