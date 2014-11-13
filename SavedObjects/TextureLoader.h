//
//  TextureLoader.h
//  Rising Fall
//
//  Created by David Villarreal on 4/28/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface TextureLoader : NSObject

+(id)shareTextureLoader;


-(SKTextureAtlas *)socialMediaAtlas;
-(SKTextureAtlas *)startMenuAtlas;
-(SKTextureAtlas *)levelSceneAtlas;
-(SKTextureAtlas *)gameplayAtlas;
-(SKTextureAtlas *)ballsAtlas;
-(SKTextureAtlas *)powerBallAtlas;
-(SKTextureAtlas *)badBallAtlas;
-(SKTextureAtlas *)buttonAtlas;
-(SKTextureAtlas *)unmovableBallAtlas;
-(SKTextureAtlas *)storeAtlas;
-(SKTextureAtlas *)itemsAtlas;
-(SKTextureAtlas *)infoAtlas: (int)levelAt;
-(SKTexture *)playAreaTexture:(int)height;


@property NSString * screenSizeAlt;

-(void)selectScreenSize: (float)screenWidth Height: (float)screenHeight;

@end
