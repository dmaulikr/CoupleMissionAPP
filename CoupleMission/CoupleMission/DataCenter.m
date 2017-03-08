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

@property (nonatomic) NSArray *tagNameArr;

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
        [self setMissionListByDocument];      // (종료 후, 다시) 앱 실행시 싱글톤 데이터 센터 싱글톤 객체 init하며 MissionList 얻어옴
    }
    
    return self;
}

- (void)initialSetting {
    
    // missionList 초기화
    self.missionList = [[NSMutableArray alloc] init];
    
    // missionTagStatusArr 초기화 세팅 (Tag 개수만큼, NO값으로)
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0 ; i < NumOfMissionTag ; i++) {
        [tempArr addObject:[NSNumber numberWithBool:NO]];
    }
    self.missionTagStatusArr = tempArr;     // Tag 개수만큼 초기화 된 배열로 프로퍼티로 배열 세팅
    
    
    // Tag Name 세팅      // 더 좋은 방법 없나?
    self.tagNameArr = @[@"요리하기",
                        @"꽃주기",
                        @"안마하기"];
    
}


// Document에 있는 MissionList.plist로부터 미션리스트 받아옴
- (void)setMissionListByDocument {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths objectAtIndex:0];
    self.docuPath = [basePath stringByAppendingPathComponent:@"MissionList.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:self.docuPath]) {
        
        // 도큐먼트 없을시, 간단히 초기화 및 생성
        [self setMissionListByMissionTagStatusArr];     // MissionTagStatusArr 초기화
        [self.missionList writeToFile:self.docuPath atomically:NO];
        
//        // 앱 최초 시작할 때, 기본적으로 할당 된 미션리스트 있을시 아래 bundle에 MissionList.plist 부분 추가 ver.
//        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"MissionList" ofType:@"plist"];
//        [fileManager copyItemAtPath:bundlePath toPath:self.docuPath error:nil];
    }
    
    // 미션리스트 프로퍼티로 set
    self.missionList = [NSMutableArray arrayWithContentsOfFile:self.docuPath];
}






/////////////////// 미션 관련 ///////////////////

- (void)setMissionListByMissionTagStatusArr {       // missionTagStatusArr에 완료된 설정된 대로 missionList 세팅

    for (NSInteger i = 0 ; i < NumOfMissionTag ; i++) {

        NSNumber *status = self.missionTagStatusArr[i];
        self.missionList[i] = @{@"Name":self.tagNameArr[i], @"Status":status};
    }
    
//    NSLog(@"%@", self.missionList);
    
    // document에 Write
    [self.missionList writeToFile:self.docuPath atomically:NO];

}

- (void)addMissionListWithMissionName:(NSString *)missionName {  // 미션명으로 추가, 우선, 추가시 무조건 Status : @1 (YES)
    
    [self setMissionListByMissionTagStatusArr];     // 혹시라도, tag 인덱스 부분 초기화 및 세팅 안되어 있으면 error 나므로.. (그런 상황이 생겼다면, 뭔가 이상한 것)
    
    self.missionList[self.missionList.count] = @{@"Name":missionName, @"Status":@1};

    
    // document에 Write
    [self.missionList writeToFile:self.docuPath atomically:NO];
}


@end
