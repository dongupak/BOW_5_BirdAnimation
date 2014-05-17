//
//  GameLayer.m
//  BOW_First
//
//  Created by ivis01 on 13. 6. 26..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"

//매크로 상수 #define으로 미리 정의
#define FRONT_CLOUD_SIZE 563 //앞 구름 이미지의 넓이 정의
#define BACK_CLOUD_SIZE  509 //뒤 구름 이미지의 넓이 정의
#define FRONT_CLOUD_TOP  310 //앞 구름 이미지의 높이 정의
#define BACK_CLOUD_TOP   230 //뒤 구름 이미지의 높이 정의

@implementation GameLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	GameLayer *layer = [GameLayer node];
	[scene addChild: layer];
	return scene;
}
//scene 메서드를 호출하면 CCScene 타입의 scene 이름을 가진 객체를 생성하고
//(CCLayer를 상속하는) GameLayer 타입의 layer 이름을 가진 객체를 생성하여
//scene 객체에 layer 객체를 붙이고 이 scene 객체를 리턴해줍니다.
//이렇게 리턴해준 scene 객체를 CCDirector가 실행시켜 주는 것입니다.
//매크로 상수 #define으로 미리 정의


-(void)dealloc {
    [super dealloc];
}
//사용자가 원하는 위치 변수를 받아서 구름을 생성하는 메소드입니다.
//int형의 imgSize에는 이미지의 넓이, top에는 이미지의 높이, NSString형의 fileName에는 이미지이름, int형의 interval은 시간, z는 z-index로 받아옵니다.
- (void)createCloudWithSize:(int)imgSize top:(int)imgTop fileName:(NSString*)fileName interval:(int)interval z:(int)z {
    //createCloud 함수의 내용에서처럼 해석하면 됩니다.
    id enterRight	= [CCMoveTo actionWithDuration:interval position:ccp(0, imgTop)];
    id enterRight2	= [CCMoveTo actionWithDuration:interval position:ccp(0, imgTop)];
    id exitLeft		= [CCMoveTo actionWithDuration:interval position:ccp(-imgSize, imgTop)];
    id exitLeft2	= [CCMoveTo actionWithDuration:interval position:ccp(-imgSize, imgTop)];
    id reset		= [CCMoveTo actionWithDuration:0  position:ccp( imgSize, imgTop)];
    id reset2		= [CCMoveTo actionWithDuration:0  position:ccp( imgSize, imgTop)];
    id seq1			= [CCSequence actions: exitLeft, reset, enterRight, nil];
    id seq2			= [CCSequence actions: enterRight2, exitLeft2, reset2, nil];
    
    //앞에 지나가는 구름 이미지를 표시하기 위해 Sprite를 이용합니다.
    CCSprite *spCloud1 = [CCSprite spriteWithFile:fileName];
    [spCloud1 setAnchorPoint:ccp(0,1)];
    [spCloud1.texture setAliasTexParameters];
    [spCloud1 setPosition:ccp(0, imgTop)];
    [spCloud1 runAction:[CCRepeatForever actionWithAction:seq1]];
    [self addChild:spCloud1 z:z ];
    
    //뒤에 지나가는 구름 이미지를 표시하기 위해 Sprite를 이용합니다.
    CCSprite *spCloud2 = [CCSprite spriteWithFile:fileName];
    [spCloud2 setAnchorPoint:ccp(0,1)];
    [spCloud2.texture setAliasTexParameters];
    [spCloud2 setPosition:ccp(imgSize, imgTop)];
    [spCloud2 runAction:[CCRepeatForever actionWithAction:seq2]];
    [self addChild:spCloud2 z:z ];
}

//전선 위로 날개짓을 하며 움직이는 새를 표현하는 메소드입니다.
- (void)createBird {
    // 파랑 새 이미지를 bird 라는 스프라이트로 지정합니다.
    CCSprite *bird = [CCSprite spriteWithFile:@"blue_fly0001.png"];
    // bird 스프라이트의 위치를 지정합니다.
    [bird setPosition:ccp(50, 280)];
    // bird 스프라이트를 생성하고  z 값은 5로 설정합니다.
    [self addChild:bird z:5];
    
    //애니메이션 객체 flyAnimation을 생성합니다.
    CCAnimation *flyAnimation = [CCAnimation animation];
    
    //이미지를 반복문으로 불러와서(blue_fly0001.png부터 blue_fly0016.png까지) 프레임에 넣고 이것을 다시 애니메이션 객체 flyAnimation에 넣습니다.
    for(NSInteger i = 1; i < 61; i++) {
        [flyAnimation addSpriteFrameWithFilename:[NSString stringWithFormat:@"blue_sit_%04d.png",i]];
//        NSLog(@"sprite frame name = %@",[NSString stringWithFormat:@"blue_fly%04d.png",i]);
    }
    //flyAnimation의 프레임당 시간 간격을 0.08초로 지정합니다.
    [flyAnimation setDelayPerUnit:0.05f];
    
    //flyAnimation을 Animate하는 flyAnimate를 정의합니다.
    id flyAnimate = [CCAnimate actionWithAnimation:flyAnimation];
    // flyAnimate를 무한 반복하는 액션 actionFlyrepeat를 만듭니다.
     id actionFlyrepeat = [CCRepeatForever actionWithAction:flyAnimate];
    //flyAnimate를 한 번 실행하는 액션 actionFlyrepeat를 만듭니다.
    //id actionFlyrepeat = [CCSequence actions:flyAnimate, nil];
    //bird 스프라이트가 actionFlyrepeat 액션을 수행하도록 합니다.
    [bird runAction:actionFlyrepeat];
    // 2초간 (300,160)으로 직선 이동하는 액션 actionMoveTo를 만듭니다.
    id actionMoveTo    = [CCMoveTo actionWithDuration:2 position:ccp(300, 160)];
    //bird 스프라이트가 actionMoveTo 액션을 수행하도록 합니다.
    [bird runAction:actionMoveTo];
}


-(id) init
{
	if( (self=[super init])) {
        //배경 이미지를 표시하기 위해 Sprite를 이용합니다.
        CCSprite *back = [CCSprite spriteWithFile:@"back.png"];
        //배경 이미지의 위치를 지정합니다.
        [back setPosition:ccp(240, 160)];
        //GameLayer에 배경 Sprite를 Child로 넣습니다. z-index는 0으로 설정합니다.
        [self addChild:back z:0];
        
        //건물 이미지를 표시하기 위해 Sprite를 이용합니다.
        CCSprite *setting = [CCSprite spriteWithFile:@"setting.png"];
        //건물 이미지의 위치를 지정합니다.
        [setting setPosition:ccp(240, 160)];
        //GameLayer에 배경 Sprite를 Child로 넣습니다. z-index는 2으로 설정합니다.
        [self addChild:setting z:2];
        
        //전봇대 이미지를 표시하기 위해 Sprite를 이용합니다.
        CCSprite *pole = [CCSprite spriteWithFile:@"pole.png"];
        //이미지 변환할 때 사용되는 anchorPoint를 오른쪽 중간 (0.5,0.0)로 잡습니다.
        [pole setAnchorPoint:ccp(0.5f, 0.0f)];
        //전봇대 이미지의 위치를 지정합니다.
        [pole setPosition:ccp(240, 0)];
        //GameLayer에 배경 Sprite를 Child로 넣습니다. z-index는 2으로 설정합니다.
        [self addChild:pole z:2];

        //creatCloudWithSize함수 호출합니다. 넓이는 FRONT_CLOUD_SIZE로 높이는 FRONT_CLOUD_TOP로 fileName은 cloud_front.png로 interval은 15초로 z는 2로 creatCloudWithSize함수로 보냅니다.
        [self createCloudWithSize:FRONT_CLOUD_SIZE top:FRONT_CLOUD_TOP fileName:@"cloud_front.png" interval:15 z:2];
        //creatCloudWithSize함수 호출합니다. 넓이는 BACK_CLOUD_SIZE로 높이는 BACK_CLOUD_TOP로 fileName은 cloud_back.png로 interval은 30초로 z는 1로 creatCloudWithSize함수로 보냅니다.
        [self createCloudWithSize:BACK_CLOUD_SIZE  top:BACK_CLOUD_TOP  fileName:@"cloud_back.png"  interval:30 z:1];
        //createBird 메소드를 호출합니다.
        [self createBird];
    }
	return self;
}

@end
