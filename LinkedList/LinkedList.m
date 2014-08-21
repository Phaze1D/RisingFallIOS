//
//  LinkedList.m
//  Rising Fall
//
//  Created by David Villarreal on 6/4/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "LinkedList.h"
#import "GamePlayScene.h"

@implementation LinkedList


-(id)initWithScene: (GamePlayScene *)gameScene{
    
    
    if (self = [super init]) {
        _gameScene = gameScene;
    }
    return self;
    
    
}


-(void)addToEnd:(Ball *)ball{
    @synchronized(self){
        Node * newTail = [[Node alloc] initWithElement:ball];
        newTail.element.isInMoveingList = YES;
        newTail.element.userInteractionEnabled = NO;
        if (_count > 0) {
            
            Node * temp = _tail;
            _tail.next = newTail;
            _tail = newTail;
            _tail.parent = temp;
        }else{
            _tail = newTail;
            _head = newTail;
        }
        
        _count++;
    }
    
}

-(void)addToFront:(Ball *)ball{
    @synchronized(self){
        Node * newHead = [[Node alloc] initWithElement:ball];
        newHead.element.isInMoveingList = YES;
        newHead.next = _head;
        newHead.element.userInteractionEnabled = NO;
        if (_count > 0) {
            _head.parent = newHead;
            _head = newHead;
        }else{
            _head = newHead;
            _tail = newHead;
        }
        
        _count++;
    }
}

-(void)removeHeadNode{
    @synchronized(self){
        _head.element.isInMoveingList = NO;
        _head.element.userInteractionEnabled = YES;
        
        Node * temp = _head.next;
        _head.next = nil;
        _head = nil;
        _head = temp;
        _count--;
    }
}

-(void)removeTailNode{
    
    @synchronized(self){
        
        _tail.element.isInMoveingList = NO;
        _tail.element.userInteractionEnabled = YES;
        
        Node * temp = _tail.parent;
        _tail.parent = nil;
        _tail = nil;
        _tail = temp;
        _count--;
    }
}

-(void)removeNode: (Node * )node{
    @synchronized(self){
        
        
        node.element.isInMoveingList = NO;
        node.element.userInteractionEnabled = YES;

        node.parent.next = node.next;
        node.next.parent = node.parent;
        node.parent = nil;
        node.next = nil;
        node = nil;
        _count--;
    }
}

//Finds the node associted with the element and removes the node from the list
-(void)findNodeAndRemove: (Ball *) ball{
    
    Node * current = _head;
    while (current != nil) {
        if (current.element == ball) {
            
            if (current == _head) {
                current = _head.next;
                [self removeHeadNode];
                
            }else if(current == _tail){
                current = _tail.next;
                [self removeTailNode];
                
            }else{
                Node * temp = current.next;
                [self removeNode:current];
                current = temp;
            }
            break;
        }else{
            current = current.next;
        }
    }
    
}



-(void)removeAll{
    Node * current = _head;
    
    while (current != nil) {
        current.parent.next = nil;
        current.parent = nil;
        current = current.next;
    }
    
    _head = nil;
    _tail = nil;
    _gameScene = nil;
}


//Checks to see if all the moving balls have reached there final position
-(BOOL)checkIfReached{
    
    @synchronized(self){
        
        Node * current = _head;
        int amount = 0;
        
        while (current != nil) {
            if ([current.element isAtFinalPosition]) {
                Ball * elementB = current.element;
                if (current == _head) {
                    current = _head.next;
                    [self removeHeadNode];
                    
                }else if(current == _tail){
                    current = _tail.next;
                    [self removeTailNode];
                    
                }else{
                    Node * temp = current.next;
                    [self removeNode:current];
                    current = temp;
                }
                
                if (elementB.row == _gameScene.numRows -1) {
                    [_gameScene disableBalls];
                    _gameScene.ceilingHit = YES;
                    _gameScene.stageAt = 3;
                    _gameScene.hitBall = elementB;
                    
                }

                
                
                amount++;
            }else{
                current = current.next;
            }
        }
        
        if (amount > 0) {
            return YES;
        }else{
            return NO;
        }
        
    }
}

//Called when the game is paused
-(void)gamePaused{
    
    @synchronized(self){
        Node * current = _head;
        
        while (current != nil) {
            current.element.physicsBody = nil;
            current = current.next;
        }
    }
}

//Called when the game resumes
-(void)gameResumed{
    @synchronized(self){
        Node * current = _head;
        
        while (current != nil) {
            [current.element setPhysicsProperties];
            current = current.next;
        }
    }
    
}

-(void)printList{
    
    Node * current = _head;
    
    while (current != nil) {
        NSLog(@"%@", current);
        current = current.next;
    }
    
    NSLog(@"--------");
    
}






@end
