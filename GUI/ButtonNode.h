//
//  ButtonNode.h
//  Rising Fall
//
//  Created by David Villarreal on 4/27/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "FontChoicerClass.h"

typedef NS_ENUM(NSInteger,
                ButtonType) {
    StoreButton = 0,
    NaviagtionButton = 1,
    ResumenButton = 2,
    BackToMain = 3,
    NextLevelB = 4,
    RestartB = 5,
    PayButton = 6,
    P1 = 7,
    P2 = 8,
    P3 = 9,
    P4 = 10,
    P5 = 11
};

@class ButtonNode;

@protocol ButtonDelegate <NSObject>

@required
-(void)buttonPressed: (ButtonType )type;

@end

@interface ButtonNode : SKSpriteNode

@property (nonatomic, weak) id<ButtonDelegate> delegate;

@property SKTexture * defaultImage;
@property SKTexture * pressedImage;

@property SKLabelNode * label;

@property ButtonType buttontype;

@property BOOL isMoved;

-(void)setImages: (SKTexture *)defaultImage pressedImage:(SKTexture * )pressedImage;
-(void)setText: (NSString *)text;
-(void)setText:(NSString *)text Size: (int)fontSize;


@end
