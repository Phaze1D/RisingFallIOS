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
    
    
    _textLoad = [TextureLoader shareTextureLoader];
    
    _powerBalls = [[NSMutableArray alloc] initWithCapacity:5];
    _player = ((GameData *)[GameData sharedGameData]).player;
    
    SKTextureAtlas * pAtlas = [_textLoad powerBallAtlas];

    float xOffset = (self.size.width - [[SizeManager sharedSizeManager] getPowerPanelBallSize].width * 5 )/6;
    float yOffset = (self.size.height - [[SizeManager sharedSizeManager]getPowerPanelBallSize].height)/2;
    
    for (int i = 0 ; i < 5; i++) {
        Ball * ball = [Ball spriteNodeWithTexture:[pAtlas textureNamed:[NSString stringWithFormat:@"powerBall%d", i + 1]]];
        ball.position = CGPointMake(xOffset + ( [[SizeManager sharedSizeManager] getPowerPanelBallSize].width + xOffset )*i , yOffset);
        ball.size = [[SizeManager sharedSizeManager] getPowerPanelBallSize];
        ball.isPowerBall = YES;
        ball.powerBallType = 1+i;
        ball.anchorPoint = CGPointMake(0, 0);
        ball.userInteractionEnabled = YES;
        [self addChild:ball];
        [_powerBalls addObject:ball];
    }
    
    int fontsize = 11;
    
    SKTextureAtlas * gameObjects = [_textLoad gameplayAtlas];
    
    float xposition2 = yOffset - [[SizeManager sharedSizeManager] getPowerPanelBallSize].width/4 + [[SizeManager sharedSizeManager] getPowerPanelBallSize].height/2;
    
    
    for (int i = 0; i < 5 ; i++) {
        
        int amount = [_player getPowerAmount:i+1];
        
        if (amount > 0) {
            
            SKSpriteNode * noti = [SKSpriteNode spriteNodeWithTexture:[gameObjects textureNamed:@"notificationCircle"]];
            noti.position = CGPointMake(((Ball * )[_powerBalls objectAtIndex:i]).position.x, xposition2);
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
