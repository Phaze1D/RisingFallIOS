//
//  SettingPanel.m
//  Rising Fall
//
//  Created by David Villarreal on 5/30/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "SettingPanel.h"

@implementation SettingPanel

//Creates the intro panel for when the gameplay starts
-(void)createIntroPanel: (int)levelAt{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        int fontsize = 13;
        
        NSString * key;
        NSString * info;
        
        if (levelAt <= 2 || levelAt == 18 || levelAt == 28 || levelAt == 50 || levelAt == 70) {
            key = [NSString stringWithFormat:@"LevelInfo%d",levelAt];
            info = NSLocalizedString(key, nil);
        }else{
            if (_gameType == 1) {
                info = [NSString stringWithFormat:@"You have %d seconds to reach the target score of %d and surive without hitting the roof", _objectiveLeft, _targetScore];
            }else{
                info = [NSString stringWithFormat:@"You have %d balls left to reach the target score of %d and surive without hitting the roof", _objectiveLeft, _targetScore];
            }
        }
        
        CGRect frame = CGRectMake(self.position.x ,self.position.y+self.size.height/2,self.size.width,self.size.height/2);
        
        _textView = [[UITextView alloc] initWithFrame:frame];
        _textView.textColor = [UIColor blackColor];
        _textView.font = [UIFont fontWithName:@"CooperBlack" size:fontsize];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.text = info;
        _textView.textAlignment = NSTextAlignmentCenter;
        _textView.clipsToBounds = YES;
        _textView.layer.cornerRadius = 10.0f;
        _textView.editable = NO;
        _textView.userInteractionEnabled = NO;
        
        SKScene * owner = (SKScene *)self.parent;
        
        [owner.view addSubview:_textView];
        
        [self createInfoTexture:levelAt];
        
    });
    
}

//Creates the info images
-(void)createInfoTexture: (int)levelAt{
    
    if (levelAt <= 2 || levelAt == 18 || levelAt == 28 || levelAt == 50 || levelAt == 70) {
        
    }else{
        levelAt = 101;
    }
    
    SKTextureAtlas * infoAtlas  = [[TextureLoader shareTextureLoader] infoAtlas:levelAt ];
    float xOffset = (self.size.width - [infoAtlas textureNamed:@"correct"].size.width*2)/3;
    
    SKSpriteNode * node1 = [SKSpriteNode spriteNodeWithTexture:[infoAtlas textureNamed:@"correct"]];
    node1.position = CGPointMake(xOffset, self.size.height - 5);
    node1.anchorPoint = CGPointMake(0, 1);
    [self addChild:node1];
    
    SKSpriteNode * node2 = [SKSpriteNode spriteNodeWithTexture:[infoAtlas textureNamed:@"incorrect"]];
    node2.position = CGPointMake(xOffset*2 + [infoAtlas textureNamed:@"correct"].size.width, self.size.height - 5);
    node2.anchorPoint = CGPointMake(0, 1);
    [self addChild:node2];
    
}


//Creates the pause panel for when the gameplay is paused
-(void)createPausePanel{
    
    TextureLoader * textLoader = [TextureLoader shareTextureLoader];
    
    SKTexture * buttonL1T = [[textLoader buttonAtlas]textureNamed:@"buttonL1"];
    SKTexture * buttonL2T = [[ textLoader buttonAtlas]textureNamed:@"buttonL2"];
    float yOffset = (self.size.height - buttonL1T.size.height - buttonL2T.size.height)/3.0;
    CGPoint quitPosition = CGPointMake(self.size.width/2, yOffset + buttonL1T.size.height/2);
    CGPoint resumenPosition = CGPointMake(self.size.width/2, yOffset*2 + buttonL1T.size.height*3/2.0);
    
    ButtonNode * quitButton = [ButtonNode spriteNodeWithTexture:buttonL1T];
    [quitButton setImages:buttonL1T pressedImage:buttonL2T];
    [quitButton setText: NSLocalizedString(@"QuitK", nil)];
    quitButton.anchorPoint = CGPointMake(0.5, 0.5);
    quitButton.buttontype = NaviagtionButton;
    quitButton.delegate = self;
    quitButton.position = quitPosition;
    quitButton.userInteractionEnabled = YES;
    
    ButtonNode * resumenButton = [ButtonNode spriteNodeWithTexture:buttonL1T];
    [resumenButton setImages:buttonL1T pressedImage:buttonL2T];
    resumenButton.anchorPoint = CGPointMake(0.5, 0.5);
    [resumenButton setText: NSLocalizedString(@"ResumeK", nil)];
    resumenButton.buttontype = ResumenButton;
    resumenButton.delegate = self;
    resumenButton.position = resumenPosition;
    resumenButton.userInteractionEnabled = YES;
    
    [self addChild:resumenButton];
    [self addChild:quitButton];
    
}

//Creates the game over panel
-(void)createGameOverPanel:(BOOL)didWin{
    if (didWin) {
        [self createGameWon];
    }else{
        [self createGameLost];
    }
    
}

-(void)createGameWon{
    
    TextureLoader * textLoader = [TextureLoader shareTextureLoader];
    
    SKTexture * buttonL1T = [[textLoader buttonAtlas] textureNamed:@"buttonL1"];
    SKTexture * buttonL2T = [[textLoader buttonAtlas] textureNamed:@"buttonL2"];
    float yOffset = (self.size.height - buttonL1T.size.height*3)/4;
    
    SKLabelNode * title = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    title.text = NSLocalizedString(@"GameWonTitle", nil);
    title.fontColor = [UIColor blackColor];
    title.fontSize = 20;
    title.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
    title.position = CGPointMake(self.size.width/2, self.size.height - yOffset*2);
    [self addChild:title];
    
    ButtonNode * nextLevelB = [ButtonNode spriteNodeWithTexture:buttonL1T];
    nextLevelB.position = CGPointMake(self.size.width/2, buttonL1T.size.height*3.0/2.0 + yOffset*2);
    nextLevelB.buttontype = NextLevelB;
    nextLevelB.delegate = self;
    nextLevelB.userInteractionEnabled = YES;
    [nextLevelB setText:NSLocalizedString(@"NextLevel", nil)];
    [nextLevelB setImages:buttonL1T pressedImage:buttonL2T];
    [self addChild:nextLevelB];
    
    ButtonNode * mainMeunB = [ButtonNode spriteNodeWithTexture:buttonL1T];
    mainMeunB.buttontype = BackToMain;
    mainMeunB.delegate = self;
    mainMeunB.userInteractionEnabled = YES;
    mainMeunB.position = CGPointMake(self.size.width/2, buttonL1T.size.height/2 + yOffset);
    [mainMeunB setText:NSLocalizedString(@"MainMenu", nil)];
    [mainMeunB setImages:buttonL1T pressedImage:buttonL2T];
    [self addChild:mainMeunB];
    
    
    
    
}

//Create the game lost panel when the player loses
-(void)createGameLost{
    TextureLoader * textLoader = [TextureLoader shareTextureLoader];
    
    SKTexture * buttonS1T = [[textLoader buttonAtlas] textureNamed:@"buttonS1"];
    SKTexture * buttonS2T = [[textLoader buttonAtlas] textureNamed:@"buttonS2"];
    float yOffset = (self.size.height - buttonS1T.size.height*5)/6;
    float xOffset = (self.size.width - buttonS1T.size.width * 2)/3;
    CGPoint keepLabelPosition = CGPointMake(self.size.width/2, self.size.height - yOffset - buttonS1T.size.height/2);
    CGPoint payPosition = CGPointMake(self.size.width/2, self.size.height - yOffset*2 - buttonS1T.size.height*3/2);
    CGPoint socialPosition = CGPointMake(self.size.width/2, self.size.height - yOffset*3 - buttonS1T.size.height*5/2);
    CGPoint endLabelPosition = CGPointMake(self.size.width/2, self.size.height - yOffset*4 - buttonS1T.size.height*7/2);
    CGPoint resestPosition = CGPointMake(xOffset + buttonS1T.size.width/2 , self.size.height - yOffset*5 - buttonS1T.size.height*9/2);
    CGPoint quitPosition = CGPointMake(xOffset * 2 + buttonS1T.size.width*3/2, self.size.height - yOffset*5 - buttonS1T.size.height*9/2);
    
    SKLabelNode * keepPlayingLabel = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    keepPlayingLabel.position = keepLabelPosition;
    keepPlayingLabel.text = NSLocalizedString(@"KeepPlayK", nil);
    keepPlayingLabel.fontColor = [UIColor blackColor];
    keepPlayingLabel.fontSize = 20;
    keepPlayingLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    [self addChild: keepPlayingLabel];
    
    ButtonNode * payButton = [ButtonNode spriteNodeWithTexture:buttonS1T];
    payButton.position = payPosition;
    payButton.buttontype = PayButton;
    payButton.delegate = self;
    payButton.userInteractionEnabled = YES;
    [payButton setText:NSLocalizedString(@".99k", nil)];
    [payButton setImages:buttonS1T pressedImage:buttonS2T];
    [self addChild:payButton];
    
    _socialB = [SocialMediaButton spriteNodeWithTexture:buttonS1T];
    _socialB.position = socialPosition;
    _socialB.socialDelegate = self;
    _socialB.userInteractionEnabled = YES;
    _socialB.type = SOCIAL_BUTTON;
    [_socialB setText:NSLocalizedString(@"ShareK", nil)];
    [self addChild:_socialB];
    
    SKLabelNode * endLabel = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    endLabel.position = endLabelPosition;
    endLabel.text = NSLocalizedString(@"Endk", nil);
    endLabel.fontSize = 20;
    endLabel.fontColor = [UIColor blackColor];
    endLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    [self addChild: endLabel];
    
    ButtonNode * resetButton = [ButtonNode spriteNodeWithTexture:buttonS1T];
    resetButton.position = resestPosition;
    resetButton.buttontype = RestartB;
    resetButton.delegate = self;
    resetButton.userInteractionEnabled = YES;
    [resetButton setText:NSLocalizedString(@"Restartk", nil)];
    [resetButton setImages:buttonS1T pressedImage:buttonS2T];
    [self addChild: resetButton];
    
    ButtonNode * quitButton = [ButtonNode spriteNodeWithTexture:buttonS1T];
    quitButton.position = quitPosition;
    quitButton.buttontype = BackToMain;
    quitButton.delegate = self;
    quitButton.userInteractionEnabled = YES;
    [quitButton setText:NSLocalizedString(@"Quitk", nil)];
    [quitButton setImages:buttonS1T pressedImage:buttonS2T];
    [self addChild:quitButton];
    
    
    
    
}

//Creates the social Children
-(void)createSocialChildren{
    
    TextureLoader * textLoader = [TextureLoader shareTextureLoader];
    float duration = .3;
    
    SKTexture * buttonS1 = [[textLoader buttonAtlas] textureNamed:@"buttonS1"];
    _socialMediaAtlas = [textLoader socialMediaAtlas];
    _socialChildren = [[NSMutableArray alloc] initWithCapacity:6];
    
    float xoffset = (self.size.width - [_socialMediaAtlas textureNamed:@"facebook"].size.width*3)/4;
    float yoffset = (self.size.height - [_socialMediaAtlas textureNamed:@"facebook"].size.height*2 - buttonS1.size.height)/4;
    
    NSArray * names = [_socialMediaAtlas textureNames];
    
    int count = 0;
    
    for (int row = 0 ; row < 2 ; row++) {
        for (int column = 0; column < 3; column++) {
            
            CGPoint point = CGPointMake(xoffset + (xoffset + [_socialMediaAtlas textureNamed:@"facebook"].size.width)*column + [_socialMediaAtlas textureNamed:@"facebook"].size.width/2, self.size.height - ( yoffset + (yoffset + [_socialMediaAtlas textureNamed:@"facebook"].size.height)*row + [_socialMediaAtlas textureNamed:@"facebook"].size.height/2));
            
            SocialMediaButton * subSocial = [SocialMediaButton spriteNodeWithTexture:[_socialMediaAtlas textureNamed: [names objectAtIndex:count]]];
            
            subSocial.position = CGPointMake(self.size.width/2, self.size.height/2 + [_socialMediaAtlas textureNamed:@"facebook"].size.height/2);
            subSocial.alpha = 0;
            subSocial.zPosition = 3;
            subSocial.name = [names objectAtIndex:count];
            subSocial.socialDelegate = self;
            subSocial.indexInSubArray = count;
            [_socialChildren addObject:subSocial];
            
            SKAction * fadeIn = [SKAction fadeAlphaTo:1 duration:duration];
            SKAction * moveTo = [SKAction moveTo:point duration:duration];
            SKAction * group = [SKAction group:@[fadeIn, moveTo]];
            
            [subSocial runAction:group completion:^{
                subSocial.userInteractionEnabled = YES;
            }];
            
            [self addChild:subSocial];
            
            count++;
        }
    }
    
    SocialMediaButton * socialB = [SocialMediaButton spriteNodeWithTexture:buttonS1];
    socialB.position = CGPointMake(self.size.width/2, yoffset);
    socialB.socialDelegate = self;
    socialB.userInteractionEnabled = YES;
    socialB.type = SOCIAL_BUTTON;
    socialB.name = @"BackB";
    [socialB setText:NSLocalizedString(@"BackK", nil)];
    [self addChild:socialB];
    
    
}

//Removes the social children
-(void)removeSocialChildren{
    
    CGPoint point = CGPointMake(self.size.width/2 , self.size.height/2 + [_socialMediaAtlas textureNamed:@"facebook"].size.height/2);
    
    for (SocialMediaButton * button in _socialChildren) {
        SKAction * fadin = [SKAction fadeAlphaTo:0 duration:.3];
        SKAction * moveTo = [SKAction moveTo:point duration:.3];
        SKAction * group = [SKAction group:@[fadin, moveTo]];
        
        [button runAction:group completion:^{
            
            [button removeFromParent];
        }];
        
    }
    
    [_socialChildren removeAllObjects];
    _socialChildren = nil;
    [[self childNodeWithName:@"BackB"] removeFromParent];
}


//Called when social button is pressed Delegate method
-(void)socialButtonPressed{
    
    if (_socialCreated) {
        [self removeSocialChildren];
        [self createGameLost];
        _socialCreated = NO;
        _socialB.isOpen = NO;
    }else{
        [self removeAllChildren];
        [self createSocialChildren];
        _socialCreated = YES;
        _socialB.isOpen = YES;
    }
    
}

//Called when a sub social media button is clicked
-(void)subSocialButtonPressed:(BOOL)didShare{
    
    if (didShare) {
        [self.delegate continuePlaying];
    }else{
        //Display error message
    }
    
}


//Called when either the quit button or the resumen button is pressed
-(void)buttonPressed:(ButtonType)type{
    
    if (type == NaviagtionButton || type == BackToMain) {
        [self.delegate quitButtonPressed];
    }else if(type == ResumenButton){
        [self.delegate resumenButtonPressed];
    }else if (type == NextLevelB){
        [self.delegate startNextLevel];
    }else if(type == RestartB){
        [self.delegate restartButtonPressed];
    }else if(type == PayButton){
        for (SKNode * node in [self children]) {
            node.userInteractionEnabled = NO;
        }
        PaymentClass * paymentClass = [PaymentClass sharePaymentClass];
        paymentClass.delegate = self;
        [paymentClass beginBuyFlow: @"com.Phaze1D.RisingFall.KeepPlaying"];
    }
    
}

-(void)disableChild{
    for (SocialMediaButton * sub in _socialChildren) {
        sub.userInteractionEnabled = NO;
    }
}

-(void)enbableChild{
    for (SocialMediaButton * sub in _socialChildren) {
        sub.userInteractionEnabled = YES;
    }
}

-(void)buyTransctionFinished:(BOOL)didBuy{
    for (SKNode * node in [self children]) {
        node.userInteractionEnabled = YES;
    }
    if (didBuy) {
        [self.delegate continuePlaying];
    }
}

//Clears all the variables
-(void)clearAll{
    [self removeAllActions];
    [self removeAllChildren];
    _delegate = nil;
    _socialMediaAtlas = nil;
    [_textView removeFromSuperview];
    _textView = nil;
}



@end
