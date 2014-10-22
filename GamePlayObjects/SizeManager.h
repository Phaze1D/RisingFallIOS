//
//  SizeManager.h
//  Rising Fall
//
//  Created by David Villarreal on 10/13/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#ifndef Rising_Fall_SizeManager_h
#define Rising_Fall_SizeManager_h
#endif

#import <Foundation/Foundation.h>
#import "TextureLoader.h"

@interface SizeManager : NSObject

+(id)sharedSizeManager;

-(CGSize)getBallSize;
-(CGSize)getPowerPanelBallSize;
-(CGSize)getPowerPanelSize;
-(CGSize)getPlayAreaSize: (int)playHeight;
-(CGSize)getCeilingSize;
-(CGSize)getPowerTimeSize;
-(CGSize)getInfoPanelSize;
-(CGSize)getPauseButtonSize;
-(CGSize)getSettingSize;
//-(float)getShadowSize;

@end

