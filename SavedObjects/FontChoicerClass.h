//
//  FontChoicerClass.h
//  Rising Fall
//
//  Created by David Villarreal on 7/22/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextureLoader.h"

@interface FontChoicerClass : NSObject

@property BOOL XXS;
@property BOOL XS;
@property BOOL S;
@property BOOL M;
@property BOOL H;
@property BOOL XH;



+(id)shareFontChoicer;

-(id)init;

-(float)fontButtonL;//
-(float)fontButtonS;//
-(float)fontLevelButton;//
-(float)fontLifePanelTitle;//
-(float)fontLifePanelLifes;//
-(float)fontLifePanelTime;//
-(float)fontStoreTitle;//
-(float)fontStoreInfo;//
-(float)fontGameplayLevelID;//
-(float)fontObjectivePanel;
-(float)fontScorePanel;//
-(float)fontIntroText;//
-(float)fontPowerNoti;//
-(float)fontKeepPlaying;
-(float)fontGameOver;//
-(float)fontGameWon;//
-(float)fontPowerTime;
-(float)fontPopEffect;

@end
