//
//  OptionPanel.h
//  Rising Fall
//
//  Created by David Villarreal on 5/25/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ButtonNode.h"
#import "TextureLoader.h"

@protocol OptionPanelDelegate <NSObject>

@required
-(void)optionButtonPressed;

@end

@interface OptionPanel : SKSpriteNode

@property (nonatomic, weak) id <OptionPanelDelegate> delegate;
@property SKTexture * pressedTexture;
@property SKTexture * notPressedTexture;

-(void)clearAll;

@end
