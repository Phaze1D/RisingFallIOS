//
//  SettingPanel.h
//  Rising Fall
//
//  Created by David Villarreal on 5/30/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ButtonNode.h"
#import "TextureLoader.h"
#import "SocialMediaButton.h"
#import "PaymentClass.h"

@protocol SettingPanelDelegate <NSObject>

@required
-(void)quitButtonPressed;
-(void)resumenButtonPressed;
-(void)startNextLevel;
-(void)restartButtonPressed;
-(void)continuePlaying;

@end

@interface SettingPanel : SKSpriteNode <ButtonDelegate, SocialMediaDelegate>

@property (nonatomic, weak) id <SettingPanelDelegate> delegate;

@property int targetScore;
@property int objectiveLeft;
@property int gameType;

@property BOOL socialCreated;

@property SKTextureAtlas * socialMediaAtlas;

@property SocialMediaButton * socialB;

@property UITextView * textView;

@property NSMutableArray * socialChildren;

-(void)createIntroPanel: (int)levelAt;
-(void)createPausePanel;
-(void)createGameOverPanel: (BOOL) didWin;
-(void)clearAll;

@end
