//
//  StoreBuyPanel.h
//  Rising Fall
//
//  Created by David Villarreal on 7/22/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ButtonNode.h"
#import "TextureLoader.h"
#import "GameData.h"

@protocol StoreBuyPanelDelegate <NSObject>

@required
-(void)pButtonPressed: (int)powerType;

@end

@interface StoreBuyPanel : SKSpriteNode <ButtonDelegate>

@property (nonatomic, weak) id<StoreBuyPanelDelegate> delegate;

@property NSMutableArray * powerItems;
@property SKLabelNode * title;
@property SKTextureAtlas * iteamsAtlas;

-(void)createPanel;
-(void)disableButtons;
-(void)enableButtons;

@end
