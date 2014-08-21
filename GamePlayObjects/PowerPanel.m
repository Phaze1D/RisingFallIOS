//
//  PowerPanel.m
//  Rising Fall
//
//  Created by David Villarreal on 5/25/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "PowerPanel.h"

@implementation PowerPanel

//Creates the panel
-(void)createPanel{
    
    NSSortDescriptor * sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    
    _textLoad = [TextureLoader shareTextureLoader];
    
    _powerBalls = [[NSMutableArray alloc] initWithCapacity:5];
    _player = ((GameData *)[GameData sharedGameData]).player;
    
    SKTextureAtlas * pAtlas = [_textLoad powerBallAtlas];
    NSArray * textures = [pAtlas textureNames];
    
    textures = [textures sortedArrayUsingDescriptors:@[sd]];
    
    float yOffset = (self.size.height - [pAtlas textureNamed:[textures objectAtIndex:0]].size.height*5)/6.0;
    float xpostion1 = self.size.width*.65;
    
    for (int i = 0; i < textures.count; i++) {
        Ball * ball = [Ball spriteNodeWithTexture:[pAtlas textureNamed:[textures objectAtIndex:i]]];
        ball.position = CGPointMake(xpostion1, -yOffset - (ball.size.height + yOffset)*i);
        ball.anchorPoint = CGPointMake(.5, 1);
        ball.isPowerBall = YES;
        ball.powerBallType = 1+i;
        ball.userInteractionEnabled = YES;
        [self addChild:ball];
        [_powerBalls addObject:ball];
        
    }
    
    int fontsize = 11;
    
    SKTextureAtlas * gameObjects = [_textLoad gameplayAtlas];
    
    float xposition2 = xpostion1 - [pAtlas textureNamed:[textures objectAtIndex:0]].size.height/2;
    
    
    for (int i = 0; i < textures.count ; i++) {
        
        int amount = [_player getPowerAmount:i+1];
        
        if (amount > 0) {
            
            SKSpriteNode * noti = [SKSpriteNode spriteNodeWithTexture:[gameObjects textureNamed:@"notificationCircle"]];
            noti.position = CGPointMake(xposition2, ((Ball * )[_powerBalls objectAtIndex:i]).position.y);
            noti.size = CGSizeMake(0, 0);
            
            
            SKAction * resize = [SKAction resizeToWidth:[gameObjects textureNamed:@"notificationCircle"].size.width height:[gameObjects textureNamed:@"notificationCircle"].size.height duration:.6];
            [noti runAction:resize completion:^{
                    SKAction * scaleDown = [SKAction scaleTo:.9 duration:.8];
                    SKAction * scaleUp = [SKAction scaleTo:1 duration:.8];
                    SKAction * seq = [SKAction sequence:@[scaleDown, scaleUp]];
                    [noti runAction: [SKAction repeatActionForever:seq]];
                    
                    SKLabelNode * amountL =  [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
                    amountL.fontSize = fontsize;
                    amountL.fontColor = [UIColor blackColor];
                    amountL.text = [NSString stringWithFormat:@"%d",amount];
                    amountL.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
                    [noti addChild:amountL];
            
            }];
            
            ((Ball * )[_powerBalls objectAtIndex:i]).notificationNode = noti;
            [self addChild:noti];
        }else{
            ((Ball * )[_powerBalls objectAtIndex:i]).alpha = .3;
            ((Ball * )[_powerBalls objectAtIndex:i]).userInteractionEnabled = NO;
        }
        
    }
    
    
}

//Called when the scene is removed
-(void)clearAll{
    [self removeAllActions];
    [self removeAllChildren];
    for (Ball * ball in  _powerBalls) {
        ball.notificationNode = nil;
    }
    [_powerBalls removeAllObjects];
    
    
}




@end
