//
//  PlayerInfo.h
//  Rising Fall
//
//  Created by David Villarreal on 5/19/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerInfo : NSObject <NSCoding>


@property int levelAt;

@property int power1;
@property int power2;
@property int power3;
@property int power4;
@property int power5;
@property int lifesLeft;

@property NSString * playerRandomString;

@property NSMutableArray* scores;

@property NSTimeInterval timeLeftOnLifes;
@property NSTimeInterval timeLeftOnSocialMedia;

+(id)sharedPlayerInfo;
-(void)increasePower: (int) powerType;
-(void)decreasePower: (int) powerType;
-(int)getPowerAmount:(int)powerType;
-(void)calculateNextShareTime;
-(void)calculateNextLifeTime;

@end
