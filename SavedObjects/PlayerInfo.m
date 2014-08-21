//
//  PlayerInfo.m
//  Rising Fall
//
//  Created by David Villarreal on 5/19/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "PlayerInfo.h"

@implementation PlayerInfo


//Init method
-(id)init{
    
    if (self = [super init]) {
        [self getPlayInfo];
    }
    return self;
    
}


//Singleton Class Player
+(id)sharedPlayerInfo{
    
    static PlayerInfo *player = nil;
    @synchronized(self) {
        if (player == nil){
            player= [[self alloc] init];
        }
    }
    return player;
    
}


//Gets the players info
-(void)getPlayInfo{
    
    _levelAt = 99;
    _power1 = 0;
    _power2 = 0;
    _power3 = 0;
    _power4 = 0;
    _power5 = 0;
    _timeLeftOnSocialMedia = 0;
    _lifesLeft = 5;
    _timeLeftOnLifes = 0;
    
    NSArray * arry = @[@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0];
    
    _scores= [[NSMutableArray alloc] initWithArray:arry];
    
    
}

//Increase the amount of a specific power
-(void)increasePower:(int)powerType{
    
    switch (powerType) {
        case 1:
            _power1++;
            break;
        case 2:
            _power2++;
            break;
            
        case 3:
            _power3++;
            break;
            
        case 4:
            _power4++;
            break;
            
        case 5:
            _power5++;
            break;
            
        default:
            break;
    }
    
}

//Decrease the amount of a specific power;
-(void)decreasePower:(int)powerType{
    switch (powerType) {
        case 1:
            if (_power1 > 0) {
                _power1--;
            }
            break;
        case 2:
            if (_power2 > 0) {
                _power2--;
            }
            break;
            
        case 3:
            if (_power3 > 0) {
                _power3--;
            }
            
            break;
            
        case 4:
            if (_power4 > 0) {
                _power4--;
            }
            
            break;
            
        case 5:
            if (_power5 > 0) {
                _power5--;
            }
            break;
            
        default:
            break;
    }
    
    
}

-(int)getPowerAmount:(int)powerType{
    switch (powerType) {
        case 1:
            return _power1;
        case 2:
            return _power2;
        case 3:
            return _power3;
            
        case 4:
            return _power4;
        case 5:
            return _power5;
            
        default:
            return -1;
    }
}

//Calculates the next time the user can share this app
-(void)calculateNextShareTime{
    //NSDate * next = [NSDate dateWithTimeIntervalSinceNow:15];
    NSDate * next = [NSDate dateWithTimeIntervalSinceNow:172800];
    _timeLeftOnSocialMedia = next.timeIntervalSince1970;
    
}

-(void)calculateNextLifeTime{
    NSDate * next = [NSDate dateWithTimeIntervalSinceNow:300];
    _timeLeftOnLifes = next.timeIntervalSince1970;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    PlayerInfo * playerInfo = [PlayerInfo sharedPlayerInfo];
    
    [aCoder encodeInt:playerInfo.levelAt forKey:@"Level At"];
    [aCoder encodeDouble:playerInfo.timeLeftOnSocialMedia forKey:@"Time Left"];
    [aCoder encodeInt:playerInfo.power1 forKey:@"Power 1"];
    [aCoder encodeInt:playerInfo.power2 forKey:@"Power 2"];
    [aCoder encodeInt:playerInfo.power3 forKey:@"Power 3"];
    [aCoder encodeInt:playerInfo.power4 forKey:@"Power 4"];
    [aCoder encodeInt:playerInfo.power5 forKey:@"Power 5"];
    [aCoder encodeInt:playerInfo.lifesLeft forKey:@"Lifes Left"];
    [aCoder encodeDouble:playerInfo.timeLeftOnLifes forKey:@"Time Left Lifes"];
    [aCoder encodeObject:playerInfo.scores forKey:@"Scores"];
    
    
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    PlayerInfo * playerInfo = [PlayerInfo sharedPlayerInfo];
    
    playerInfo.levelAt = [aDecoder decodeIntForKey:@"Level At"];
    playerInfo.power1 = [aDecoder decodeIntForKey:@"Power 1"];
    playerInfo.power2 = [aDecoder decodeIntForKey:@"Power 2"];
    playerInfo.power3 = [aDecoder decodeIntForKey:@"Power 3"];
    playerInfo.power4 = [aDecoder decodeIntForKey:@"Power 4"];
    playerInfo.power5 = [aDecoder decodeIntForKey:@"Power 5"];
    playerInfo.timeLeftOnSocialMedia = [aDecoder decodeDoubleForKey:@"Time Left"];
    playerInfo.lifesLeft = [aDecoder decodeIntForKey:@"Lifes Left"];
    playerInfo.timeLeftOnLifes = [aDecoder decodeDoubleForKey:@"Time Left Lifes"];
    playerInfo.scores =[aDecoder decodeObjectForKey:@"Scores"];
    
    return playerInfo;
}


@end
