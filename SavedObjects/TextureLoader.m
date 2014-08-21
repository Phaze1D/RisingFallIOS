//
//  TextureLoader.m
//  Rising Fall
//
//  Created by David Villarreal on 4/28/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "TextureLoader.h"

@implementation TextureLoader


+(id)shareTextureLoader{
    
    static TextureLoader * textLoader = nil;
    @synchronized(self) {
        if (textLoader == nil){
            textLoader = [[self alloc] init];
        }
    }
    return textLoader;
    
}

//Returns the atlas with all the social media art
-(SKTextureAtlas *)socialMediaAtlas{
  
    return [SKTextureAtlas atlasNamed:@"SocialMediaArt"];
}

//Returns the atlas with all the Start menu art
-(SKTextureAtlas *)startMenuAtlas{
   
    return [SKTextureAtlas atlasNamed:@"StartMenuArt"];
}

//Returns the atlas with all the level scene art
-(SKTextureAtlas *)levelSceneAtlas{

    return [SKTextureAtlas atlasNamed:@"LevelSceneArt"];
}

//Returns the atlas with all the gameplay art
-(SKTextureAtlas *)gameplayAtlas{
    
    return [SKTextureAtlas atlasNamed:@"GameplayArt"];
}

//Returns the atlas with all the balls ;)
-(SKTextureAtlas *)ballsAtlas{

    
    return [SKTextureAtlas atlasNamed:@"BallsArt"];
}


//Returns the power ball art atlas
-(SKTextureAtlas * )powerBallAtlas{
   
    return [SKTextureAtlas atlasNamed:@"PowerBallArt"];
}

//Bad ball art
-(SKTextureAtlas * )badBallAtlas{
   
    return [SKTextureAtlas atlasNamed:@"BadBallArt"];
}



//Returns the button atlas
-(SKTextureAtlas *)buttonAtlas{
  
    
    return [SKTextureAtlas atlasNamed:@"Buttons"];
}

//Returns the unmovable ball atlas
-(SKTextureAtlas *)unmovableBallAtlas{
   
    return [SKTextureAtlas atlasNamed:@"UnmovableBallArt"];
}

//Stores atlas
-(SKTextureAtlas *)storeAtlas{
   
    return [SKTextureAtlas atlasNamed:@"StoreArt"];
}

-(SKTextureAtlas *)itemsAtlas{
 
    return [SKTextureAtlas atlasNamed:@"StoreItems"];
}


-(SKTextureAtlas *)infoAtlas: (int)levelAt{
    return [SKTextureAtlas atlasNamed:[NSString stringWithFormat:@"Info%d",levelAt]];
}


@end
