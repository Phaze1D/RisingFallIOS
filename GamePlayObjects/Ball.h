//
//  Ball.h
//  Rising Fall
//
//  Created by David Villarreal on 5/1/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameData.h"
#import "PowerPanel.h"

@class Ball;
@protocol BallDelegate <NSObject>

@required
-(void)ballTaped: (Ball * )ball;
-(void)ballMoved: (Ball *)ball direction: (int) dirc;
-(void)powerBallTouch: (Ball *)ball;

@end


@interface Ball : SKSpriteNode

@property (nonatomic, weak) id<BallDelegate> delegate;

@property BOOL isPowerBall;
@property BOOL isInMoveingList;
@property BOOL isDoubleBall;
@property BOOL isUnMoveable;
@property BOOL didMove;
@property BOOL hasBeenChecked;

@property int powerBallType;
@property int row;
@property int column;
@property int ballColor;

@property float finalPhysicY;
@property float moveDirection;

@property CGPoint startPoint;
@property CGPoint endPoint;

@property SKTexture * doubleTexture;

@property SKPhysicsBody * phyBody;

@property CGVector velocity;

@property SKSpriteNode * notificationNode;



-(void)setPhysicsProperties;
-(void)updateName;
-(BOOL)isAtFinalPosition;
-(void)changeColor: (int)ballColor;
-(void)doubleClicked;


@end
