//
//  LinkedList.h
//  Rising Fall
//
//  Created by David Villarreal on 6/4/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ball.h"
#import "Node.h"

@class GamePlayScene;
@interface LinkedList : NSObject

@property (readonly) Node * head;
@property (readonly) Node * tail;
@property (readonly) int count;

@property (weak)GamePlayScene * gameScene;

-(id)initWithScene: (GamePlayScene *)gameScene;

-(void)addToEnd: (Ball *)ball;
-(void)addToFront: (Ball *)ball;
-(BOOL)checkIfReached;
-(void)printList;
-(void)removeAll;
-(void)gamePaused;
-(void)gameResumed;
-(void)findNodeAndRemove: (Ball *)ball;

@end
