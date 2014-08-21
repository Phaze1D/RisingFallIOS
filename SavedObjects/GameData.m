//
//  GameData.m
//  Rising Fall
//
//  Created by David Villarreal on 5/19/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "GameData.h"

@implementation GameData




-(id)init{
    
    self = [super init];
    if (self) {
        _player = [NSKeyedUnarchiver unarchiveObjectWithFile:[self dicPathPlayer]];
        if (!_player) {
            _player = [PlayerInfo sharedPlayerInfo];
        }
    }
    return self;
    
}

//Shared Game data class
+(id)sharedGameData{
    
    static GameData *info = nil;
    @synchronized(self) {
        if (info == nil)
            info = [[self alloc] init];
    }
    return info;
    
    
}



//Returns the path were the player data is saved to and loaded from
-(NSString *)dicPathPlayer{
    NSArray * dics = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString * dic = [dics objectAtIndex:0];
    return [dic stringByAppendingPathComponent:@"playerInfo.archive"];
    
}

//Should be called when want to saved the player data
-(BOOL)saveData{
    
    return [NSKeyedArchiver archiveRootObject:self.player toFile:[self dicPathPlayer]];
}



@end
