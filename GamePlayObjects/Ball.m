//
//  Ball.m
//  Rising Fall
//
//  Created by David Villarreal on 5/1/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "Ball.h"

@implementation Ball

-(void)setPhysicsProperties{
    
    _phyBody = [SKPhysicsBody bodyWithRectangleOfSize: self.size];
    _phyBody.friction = 0;
    _phyBody.allowsRotation = NO;
    _phyBody.mass = 5;
    _phyBody.linearDamping = 0;
    _phyBody.velocity = _velocity;
    self.physicsBody = _phyBody;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSArray * array = [touches allObjects];
    _startPoint = [((UITouch *)[array objectAtIndex:0]) locationInNode:self.parent];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
        if (!_isPowerBall) {
            NSArray * array = [touches allObjects];
            CGPoint midPoint = [((UITouch *)[array objectAtIndex:0]) locationInNode:self.parent];
            float distance = [self calculateDistance:midPoint];
            
            if (distance > self.size.height && !_didMove) {
                _didMove = YES;
                _moveDirection = [self calculateDirection:midPoint];
                if (!_isUnMoveable) {
                    [self.delegate ballMoved:self direction:_moveDirection];
                }
            }
            
        }
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
        if (_isPowerBall) {
            
            if ([self.parent isKindOfClass:[PowerPanel class]]) {
                
                PlayerInfo * player = ((GameData * )[GameData sharedGameData]).player;
                
                [player decreasePower:_powerBallType];
                int amount = [player getPowerAmount:_powerBallType];
                if (amount > 0) {
                    ((SKLabelNode *)[[self.notificationNode children] objectAtIndex:0]).text = [NSString stringWithFormat:@"%d", amount];
                }else{
                    [_notificationNode removeAllChildren];
                    [_notificationNode removeFromParent];
                    _notificationNode = nil;
                    self.alpha = .3;
                    self.userInteractionEnabled = NO;
                }
                
            }
            
            [self.delegate powerBallTouch:self];
            
        }else{
            if (!_didMove) {
                
                [self.delegate ballTaped:self];
                
            }
            
        }
        
        _didMove = NO;
    
}

//Updates the name of the ball when ever it is moved
-(void)updateName{
    self.name = [NSString stringWithFormat:@"%d-%d",_column,_row];
}


//Checks to see if a moving ball is at its final position
-(BOOL)isAtFinalPosition{
    
    if (self.position.y < _finalPhysicY) {
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody = nil;
        _phyBody = nil;
        self.position = CGPointMake(self.position.x, _finalPhysicY);
        return YES;
    }
    
    return NO;
    
}

//Calculates the direction of the touch up down left right
-(int)calculateDirection: (CGPoint ) point2{
    
    float distance = [self calculateDistance:point2];
    float y = point2.y - _startPoint.y;
    float x = point2.x - _startPoint.x;
    float angle = asinf(y/distance);
    
    if (fabsf(angle) > M_PI_4) {
        
        if (y > 0) {
            return 1;
        }else{
            return -1;
        }
        
    }else{
        if (x > 0) {
            return 2;
        }else{
            return -2;
        }
    }
}

//Calculates the distance between the start point and the end point
-(float)calculateDistance{
    
    float x = _endPoint.x - _startPoint.x;
    float y = _endPoint.y - _startPoint.y;
    float distance = powf(x, 2) + powf(y, 2);
    
    return sqrtf(distance);
}


//Calculates the distance between start point and other point
-(float)calculateDistance: (CGPoint) endPoint{
    
    float x = endPoint.x - _startPoint.x;
    float y = endPoint.y - _startPoint.y;
    float distance = powf(x, 2) + powf(y, 2);
    
    return sqrtf(distance);
}

//Changes the color of this ball to other color
-(void)changeColor:(int)ballColor{
    
    TextureLoader *textl = [TextureLoader shareTextureLoader];
    
    SKTextureAtlas * ballsA = [textl ballsAtlas];
    SKTexture * newColor = [ballsA textureNamed: [NSString stringWithFormat:@"ball%d", ballColor]];
    _ballColor = ballColor;
    self.isUnMoveable = NO;
    self.texture = newColor;
    
}

//When a double ball is clicked or tryed to removed
-(void)doubleClicked{
    _isDoubleBall = NO;
    self.texture = _doubleTexture;
    
}
















@end
