//
//  SocialMediaButton.m
//  Rising Fall
//
//  Created by David Villarreal on 4/28/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "SocialMediaButton.h"

@implementation SocialMediaButton

//Creates and runs a frame by frame animation of all the social medias
-(void)beginAnimation{
    TextureLoader * textLoader = [TextureLoader shareTextureLoader];
    NSMutableArray * frames = [NSMutableArray new];
    NSArray * mediaNames = [[textLoader socialMediaAtlas] textureNames];
    
    for (NSString * name in mediaNames) {
        [frames addObject:[[textLoader socialMediaAtlas] textureNamed:name] ];
    }
    
    SKAction * actionFrames = [SKAction repeatActionForever:[SKAction animateWithTextures:frames timePerFrame:5 resize:NO restore:YES]];
    [self runAction:actionFrames];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.alpha = .5;
    [self runAction:[SKAction playSoundFileNamed:@"buttonSound.wav" waitForCompletion:NO]];
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    self.alpha = 1;
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.alpha = 1;
    
    GameData * data = [GameData sharedGameData];
    NSTimeInterval playerTime = data.player.timeLeftOnSocialMedia;
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    
    if (date.timeIntervalSince1970 < playerTime && !_isOpen && _type == SOCIAL_BUTTON) {
        [self displayTimeLeft];
    }else{
        
        if (_type == SOCIAL_BUTTON) {
            [self.socialDelegate socialButtonPressed];
        }else{
            
            SocialMediaControl * control = [SocialMediaControl sharedSocialMediaControl];
            control.delegate = self;
            _didShare = NO;
            
            if ([self.name isEqualToString:@"facebook.png"]) {
                
                [control facebookClicked];
                
            }else if ([self.name isEqualToString:@"contacts.png"]) {
                [control contactsClicked];
                
            }else if ([self.name isEqualToString:@"google.png"]) {
                
                [control googleClicked];
                
            }else if ([self.name isEqualToString:@"twitter.png"]) {
                
                [control twitterClicked];
                
            }else if ([self.name isEqualToString:@"vk.png"]) {
                
                [control vkClicked];
                
            }else if ([self.name isEqualToString:@"weibo.png"]) {
                
                [control weiboClicked];
                
            }
            
            if (_didShare) {
                [data.player calculateNextShareTime];
            }
            
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    self.alpha = .5;
    
}

//Displays the time left until the player can share again
-(void)displayTimeLeft{
    self.userInteractionEnabled = NO;
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    GameData * data = [GameData sharedGameData];
    
    int timeLeft = data.player.timeLeftOnSocialMedia - date.timeIntervalSince1970;
    
    int seconds = timeLeft % 60;
    int minutes = (timeLeft / 60) % 60;
    int hours = timeLeft / 3600;
    
    
    SKLabelNode * title = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    title.position = CGPointMake(0, self.size.height/2 );
    title.text = NSLocalizedString(@"TimeLeftK", nil);
    title.fontSize = 13;
    title.alpha = 0;
    title.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    
    SKLabelNode * timeL = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    timeL.position = CGPointMake(0, -self.size.height/2);
    timeL.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    timeL.fontSize = 13;
    timeL.alpha = 0;
    timeL.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    timeL.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    
    
    
    title.fontColor = [UIColor blackColor];
    timeL.fontColor = [UIColor blackColor];
    
    
    
    SKAction * fadeIn = [SKAction fadeAlphaTo:1 duration:1];
    SKAction * fadeOut = [SKAction fadeAlphaTo:0 duration:1];
    SKAction * seq = [SKAction sequence:@[fadeIn,fadeOut]];
    [timeL runAction:seq];
    [title runAction: seq completion:^{
        
            [timeL removeFromParent];
            [title removeFromParent];
            self.userInteractionEnabled = YES;
    }];
    
    [self addChild:title];
    [self addChild:timeL];
    
}

//SocialMediaControlDelegate method
//Displays no internet connection
-(void)displayNoInternetConnection{
    self.userInteractionEnabled = NO;
    SKLabelNode * title = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    title.position = CGPointMake(0, self.size.height/2 );
    title.text = NSLocalizedString(@"NoInterntK", nil);
    title.fontSize = 13;
    title.fontColor = [UIColor blackColor];
    title.alpha = 0;
    title.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    
    SKAction * fadeIn = [SKAction fadeAlphaTo:1 duration:1];
    SKAction * fadeOut = [SKAction fadeAlphaTo:0 duration:1];
    SKAction * seq = [SKAction sequence:@[fadeIn,fadeOut]];
    [title runAction: seq completion:^{
            [title removeFromParent];
            self.userInteractionEnabled = YES;
        
    }];
    
    [self addChild:title];
}


//Called back when shared in a social media
-(void)sharedCallBack:(BOOL)didShare{
    if (didShare) {
        GameData * data = [GameData sharedGameData];
        [data.player calculateNextShareTime];
        [self.socialDelegate subSocialButtonPressed:didShare];
    }
}

//Called back when there has been an error sharing
-(void)sharedErrorCallBack{
    
}

//Disables the other buts while sharing
-(void)disableOther{
    [self.socialDelegate disableChild];
}

//Enables others childs after sharing
-(void)enableOther{
    
    [self.socialDelegate enbableChild];
}

@end
