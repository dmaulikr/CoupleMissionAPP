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

@property (nonatomic) NSTimer *missionTimer;
@property (nonatomic) BOOL runingTimer;

@property (nonatomic) NSDate *missionDeadLine;
@property (nonatomic) NSString *restTimeStr;
@property (nonatomic) CGFloat percent;

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
    
    
    
    [self getInfoData];
    
    if (_currentReceivedMission == nil) {   // 앱 최초 실행시만 들어감
        _currentReceivedMission = @"";  // 초기화
        _didSendedMissionDone = YES;    // 초기값 YES
        _didReceivedMissionDone = YES;  // 초기값 YES
    }
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
- (void)saveDocuPlistByMissionList {

    [self.missionList writeToFile:self.docuPath atomically:NO];

}

// UserDefaults에 저장
- (void)saveInfoData {
        
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:_didSendedMissionDone] forKey:@"didSendedMissionDone"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:_didReceivedMissionDone] forKey:@"didReceivedMissionDone"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:_currentSendedMissionIndex] forKey:@"currentSendedMissionIndex"];
    [[NSUserDefaults standardUserDefaults] setObject:_currentReceivedMission forKey:@"currentReceivedMission"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.missionDeadLine forKey:@"missionDeadLine"];
    [[NSUserDefaults standardUserDefaults] setObject:self.restTimeStr forKey:@"restTimeStr"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:self.percent]  forKey:@"percent"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:_missionFailed] forKey:@"missionFailed"];

}

// UserDefaults에서 불러오기
- (void)getInfoData {
    _didSendedMissionDone = [[[NSUserDefaults standardUserDefaults] objectForKey:@"didSendedMissionDone"] boolValue];
    _didReceivedMissionDone = [[[NSUserDefaults standardUserDefaults] objectForKey:@"didReceivedMissionDone"] boolValue];
    _currentSendedMissionIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentSendedMissionIndex"] integerValue];
    _currentReceivedMission = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentReceivedMission"];
    
    self.missionDeadLine = [[NSUserDefaults standardUserDefaults] objectForKey:@"missionDeadLine"];
    self.restTimeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"restTimeStr"];
    self.percent = [[[NSUserDefaults standardUserDefaults] objectForKey:@"percent"] doubleValue];
    
    _missionFailed = [[[NSUserDefaults standardUserDefaults] objectForKey:@"missionFailed"] boolValue];
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

- (void)deleteMissionWithMissionListIndex:(NSInteger)missionListIndex {
    
    [self.missionList removeObject:self.missionList[missionListIndex]];
    
}


// 미션 보내기
- (void)sendMissionWithIndex:(NSInteger)missionListIndex {
    
    _currentSendedMissionIndex = missionListIndex;
    _didSendedMissionDone = NO;
    [self.delegate hasSendedMission:YES];
    
    // 미션 대상에게 보내는 부분 추가해야함     // 일단 네트웍 없으니, 내 미션으로 받음
    
    _currentReceivedMission = self.missionList[missionListIndex];
    _didReceivedMissionDone = NO;
    _missionFailed = NO;
    [self.delegate hasReceivedMission:YES];
    [self setDeadLine];     // 보낼 때, 데드라인 설정

}

// 미션 완료
- (void)completeMission {
    [self missionTimerStop];
    
    _didReceivedMissionDone = YES;
    [self.delegate hasReceivedMission:NO];
    
    // 완료됐음을 상대방에게 보냄       // 일단 네트웍 없으니, 혼자 보낸 미션 끝났다고 알림

    [self deleteMissionWithMissionListIndex:_currentSendedMissionIndex];
    _didSendedMissionDone = YES;
    [self.delegate hasSendedMission:NO];
}



// 미션 타이머 관련

- (void)setDeadLine {
      
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    self.missionDeadLine = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];     // 24시간
    
}


- (void)missionTimerStart {
    
    if (!self.runingTimer && !self.didReceivedMissionDone) {

        self.missionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0     //60.0
                                                             target:self
                                                           selector:@selector(updateTime:)
                                                           userInfo:@"missionTimer"
                                                            repeats:YES];
        
        self.runingTimer = YES;  // 종료 후, 다시 App 실행한 상황엔 다시 startedMission = nil이 되어있음
    }
    
    if (self.runingTimer) {
        [self updateTime:self.missionTimer];    // 세팅하면서 한번 실행
    }

}


- (void)updateTime:(NSTimer *)timer {
    NSLog(@"Inside updateTime method");

    NSTimeInterval restTime = [self.missionDeadLine timeIntervalSinceNow];
    
    if (restTime > 24*60*60) {      // 타임 초과, 미션 실패
        [self missionTimerStop];
        self.restTimeStr = @"00:00";
        self.percent = 1;
        _missionFailed = YES;
        
    } else {
        NSInteger hour = (NSInteger)restTime / 3600;
        NSInteger min = ((NSInteger)restTime % 3600) / 60;
        NSInteger sec = ((NSInteger)restTime % 3600) % 60;
        
        if (hour < 10) {        // 한자리 수 일때, String 깨짐..
            self.restTimeStr = [NSString stringWithFormat:@"0%ld", hour];
        } else {
            self.restTimeStr = [NSString stringWithFormat:@"%ld", hour];
        }
        
        if (min < 10) {
            self.restTimeStr = [NSString stringWithFormat:@"%@:0%ld", self.restTimeStr, min];
            NSLog(@"min : %@",[NSString stringWithFormat:@":0%ld", min]);
        } else {
            self.restTimeStr = [NSString stringWithFormat:@"%@:%ld", self.restTimeStr, min];
            NSLog(@"min : %@",[NSString stringWithFormat:@":%ld", min]);
        }
        
        if (sec < 10) {
            self.restTimeStr = [NSString stringWithFormat:@"%@:0%ld", self.restTimeStr, sec];
            NSLog(@"sec : %@",[NSString stringWithFormat:@":0%ld", sec]);
        } else {
            self.restTimeStr = [NSString stringWithFormat:@"%@:%ld", self.restTimeStr, sec];
            NSLog(@"sec : %@",[NSString stringWithFormat:@":%ld", sec]);
        }
        
        self.percent = ((24*60*60.0 + 1) - restTime) / (24*60*60.0);
    
    }
    
    NSLog(@"restTime : %lf, percent : %lf", restTime, self.percent);
    [self.timerDelegate timeUpdate:self.restTimeStr withPercent:self.percent];
}


- (void)missionTimerStop {
    _didReceivedMissionDone = YES;
    self.runingTimer = NO;
    [self.missionTimer invalidate];
    self.missionTimer = nil;
}


@end
