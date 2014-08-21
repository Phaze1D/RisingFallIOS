//
//  LinkedListNew.h
//  Rising Fall
//
//  Created by David Villarreal on 8/2/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NodeNew.h"
#import "Ball.h"

@class GamePlayScene;
@interface LinkedListNew : NSObject

@property NodeNew * head;
@property NodeNew * tail;
@property int count;
@property (weak)GamePlayScene * gameScene;

-(void)addToEnd: (Ball *)ball;
-(void)addToFront: (Ball *)ball;
-(void)checkIfReached;
-(void)removeAll;
-(void)gamePaused;
-(void)gameResumed;
-(void)findNodeAndRemove: (Ball *)ball;
-(void)printList;
-(id)initWithScene: (GamePlayScene *)gameScene;

@end
