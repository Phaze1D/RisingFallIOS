//
//  SizeManager.m
//  Rising Fall
//
//  Created by David Villarreal on 10/13/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//


#import "SizeManager.h"

@implementation SizeManager

+(id)sharedSizeManager{
    
        
        static SizeManager *player = nil;
        @synchronized(self) {
            if (player == nil){
                player= [[self alloc] init];
            }
        }
        return player;
        
    
}

-(CGSize)getBallSize{
    CGSize size = [[[TextureLoader shareTextureLoader] ballsAtlas] textureNamed:@"ball0"].size;
    
    return CGSizeMake(size.width/2, size.height/2);
}

-(CGSize)getPowerPanelBallSize{
    CGSize size = [[[TextureLoader shareTextureLoader] powerBallAtlas] textureNamed:@"powerBall1"].size;
    
    return CGSizeMake(size.width/2/1.2, size.height/2/1.2);
}

-(CGSize)getPowerPanelSize{
    
     CGSize size = [[[TextureLoader shareTextureLoader] gameplayAtlas] textureNamed:@"powerArea"].size;
    
     return CGSizeMake(size.width/2, size.height/2);
}

-(CGSize)getPowerTimeSize{
    
    CGSize size = [[[TextureLoader shareTextureLoader] gameplayAtlas] textureNamed:@"playerTimeArea"].size;
    
     return CGSizeMake(size.width/2, size.height/2);
}

-(CGSize)getPlayAreaSize: (int)playHeight{
    
    CGSize size = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"playArea%d",playHeight]].size;
    
     return CGSizeMake(size.width/2, size.height/2);
}

-(CGSize)getCeilingSize{
     return CGSizeMake(0, 0);
}

-(CGSize)getInfoPanelSize{
    CGSize size = [[[TextureLoader shareTextureLoader] gameplayAtlas] textureNamed:@"LevelIDArea"].size;
     return CGSizeMake(size.width/2 , size.height/2);
}

-(CGSize)getPauseButtonSize{
    CGSize size = [[[TextureLoader shareTextureLoader] gameplayAtlas] textureNamed:@"optionArea"].size;
     return CGSizeMake(size.width/2, size.height/2);
}

-(float)getShadowSize{
    return 8;
}

-(CGSize)getSettingSize{
    CGSize size = [[[TextureLoader shareTextureLoader] gameplayAtlas] textureNamed:@"gameOverArea"].size;
    
    return CGSizeMake(size.width/2, size.height/2);
}


@end