//
//  GameData.h
//  Rising Fall
//
//  Created by David Villarreal on 5/19/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerInfo.h"

@interface GameData : NSObject

@property PlayerInfo * player;

-(BOOL)saveData;

+(id)sharedGameData;

@end
