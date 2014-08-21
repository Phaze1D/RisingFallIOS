//
//  LinkedListNew.m
//  Rising Fall
//
//  Created by David Villarreal on 8/2/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "LinkedListNew.h"
#import "GamePlayScene.h"

@implementation LinkedListNew

-(id)initWithScene: (GamePlayScene *)gameScene{
    
    
    if (self = [super init]) {
        _gameScene = gameScene;
        _count = 0;
    }
    return self;
    
    
}

-(void)addToEnd:(Ball *)ball{
    @synchronized(self){
        
        NodeNew * node = [[NodeNew alloc]initWithElement:ball];
        node.element.isInMoveingList = YES;
        node.element.userInteractionEnabled = NO;
        
        if (_count == 0) {
            _head = node;
            
        }else if(_count == 1){
            _tail = node;
            _head.next = _tail;
            
        }else{
            
            _tail.next = node;
            _tail = node;
        }
        
        _count++;
    }
    
}


-(void)addToFront:(Ball *)ball{
    @synchronized(self){
        NodeNew * node = [[NodeNew alloc]initWithElement:ball];
        node.element.isInMoveingList = YES;
        node.element.userInteractionEnabled = NO;

        if (_count == 0) {
            _head = node;
            
        }else if(_count == 1){
            _tail = _head;
            _head = node;
            _head.next = _tail;
            
        }else{
            
            node.next = _head;
            _head = node;
        }
        
        _count++;
    }
    

    
}

-(void)findNodeAndRemove:(Ball *)ball{
    @synchronized(self){
        NodeNew * current = _head;
        NodeNew * previous = nil;
        
        while (current.element != ball && current != nil) {
            previous = current;
            current = current.next;
        }
        if(current != nil){
            if (current == _head) {
                current.element.userInteractionEnabled = YES;
                current.element.isInMoveingList = NO;
                _head = current.next;
                current.next = nil;
                current.element = nil;
                current = nil;
                _count--;
            }else if(current == _tail){
                current.element.userInteractionEnabled = YES;
                current.element.isInMoveingList = NO;
                previous.next = nil;
                current.element = nil;
                current = nil;
                _tail = previous;
                _count--;
            }else{
                current.element.userInteractionEnabled = YES;
                current.element.isInMoveingList = NO;
                previous.next = current.next;
                current.next = nil;
                current.element = nil;
                current = nil;
                _count--;
            }
        }
    }
}

-(void)checkIfReached{
    
    @synchronized(self){
        
        NodeNew * current = _head;
        NodeNew * previous = nil;
        
        while (current != nil) {
            
            if ([current.element isAtFinalPosition]) {
                
                if (current.element.row == _gameScene.numRows -1) {
                    [_gameScene disableBalls];
                    _gameScene.ceilingHit = YES;
                    _gameScene.stageAt = 3;
                    _gameScene.hitBall = current.element;
                }

                
                if(current != nil){
                    if (current == _head) {
                        current.element.userInteractionEnabled = YES;
                        current.element.isInMoveingList = NO;
                        _head = current.next;
                        current.next = nil;
                        current.element = nil;
                        current = nil;
                        current = _head;
                        _count--;
                    }else if(current == _tail){
                        current.element.userInteractionEnabled = YES;
                        current.element.isInMoveingList = NO;
                        previous.next = nil;
                        current.element = nil;
                        current = nil;
                        _tail = previous;
                        _count--;
                    }else{
                        current.element.userInteractionEnabled = YES;
                        current.element.isInMoveingList = NO;
                        previous.next = current.next;
                        current.next = nil;
                        current.element = nil;
                        current = nil;
                        current = previous.next;
                        _count--;
                    }
                }
                
                
                
            }else{
                previous = current;
                current = current.next;
                
            }
            
        }
    }
}

-(void)gamePaused{
    @synchronized(self){
        NodeNew * current = _head;
        
        while (current != nil) {
            current.element.physicsBody = nil;
            current = current.next;
        }
    }

    
}

-(void)gameResumed{
    @synchronized(self){
        NodeNew * current = _head;
        
        while (current != nil) {
            [current.element setPhysicsProperties];
            current = current.next;
        }
    }

    
}

-(void)printList{
    
    NodeNew * current = _head;
    
    while (current != nil) {
        NSLog(@"%@ ---> %@", current, current.next);
        current = current.next;
    }
    
    NSLog(@"-------- count %d", _count);
    
}

-(void)removeAll{
  
    _head = nil;
    _tail = nil;
    _gameScene = nil;
    
}

@end
