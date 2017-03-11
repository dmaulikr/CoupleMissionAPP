//
//  DataCenter.m
//  CoupleMission
//
//  Created by Jeheon Choi on 2017. 3. 8..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import "DataCenter.h"


@interface DataCenter ()

@property (nonatomic) NSString *docuPath;

@end




@implementation DataCenter

// Singleton
+ (instancetype)sharedData {
        
    static DataCenter *dataCenter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataCenter = [[self alloc] init];
    });
    
    return dataCenter;
}

// init
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialSetting];
        [self setMissionListByDocument];
    }
    
    return self;
}



- (void)initialSetting {
    
    // Tag Text 세팅
    _tagTextList = @[@"요리해주기",
                     @"꽃 선물하기",
                     @"안마해주기",
                     @"한강 데이트",
                     @"명상하기",
                     @"아무것도 하지 않기",
                     @"5천원 이하 선물해주기",
                     @"같이 운동하기",
                     @"셀카찍기",
                     @"운동하기",
                     @"고양이 카페가기",
                     @"뽀뽀해주기",
                     @"허그하기",
                     @"액션영화 보러가기",
                     @"이태원가기",
                     @"집청소해주기",
                     @"설거지해주기",
                     @"소주마시기",
                     @"소원들어주기",
                     @"업어주기",
                     @"밥사주기",
                     @"머리묶어주기",
                     @"바라만보기",
                     @"탁구치기"
                    ];
}


// Document에 있는 MissionList.plist로부터 미션리스트 받아옴
- (void)setMissionListByDocument {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths objectAtIndex:0];
    self.docuPath = [basePath stringByAppendingPathComponent:@"MissionList.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (![fileManager fileExistsAtPath:self.docuPath]) {

        // 앱 최초 시작할 때, 기본적으로 할당 된 미션리스트 적용
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"InitialMissionList" ofType:@"plist"];
        [fileManager copyItemAtPath:bundlePath toPath:self.docuPath error:nil];
    }
    
    // docu plist에 있는 미션리스트 프로퍼티에 set
    _missionList = [NSMutableArray arrayWithContentsOfFile:self.docuPath];
    
}

// Document plist에 저장
- (void)setDocuPlistByMissionList {

    [self.missionList writeToFile:self.docuPath atomically:NO];

}




// 미션 태그

- (void)addMissionByMissionTag:(NSInteger)tagIndex {
    
    [self.missionList addObject:self.tagTextList[tagIndex]];

}


- (void)deleteMissionByMissionTag:(NSInteger)tagIndex {
    
    [self.missionList removeObject:self.tagTextList[tagIndex]];

}


// 커스텀 미션

- (void)addMissionWithMissionText:(NSString *)missionName {
    
    [self.missionList addObject:missionName];

}

- (void)deleteMissionWithMissionText:(NSString *)missionName {

    [self.missionList removeObject:missionName];

}

@end
