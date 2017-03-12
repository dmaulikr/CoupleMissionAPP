//
//  DataCenter.h
//  CoupleMission
//
//  Created by Jeheon Choi on 2017. 3. 8..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+PRJAdditions.h"
#import "UIFont+PRJAdditions.h"


@protocol DataCenterDelegate <NSObject>

@optional
// 미션전달
- (void)hasSendedMission:(BOOL)hasSendedMission;        // 보낸 미션 상태 전달
- (void)hasReceivedMission:(BOOL)hasReceivedMission;        // 받은 미션 상태 전달


@end

@protocol TimerDelegate <NSObject>

// 미션 시간 관련
- (void)timeUpdate:(NSString *)timeStr withPercent:(CGFloat)percent;

@end





@interface DataCenter : NSObject

+ (instancetype)sharedData;     // 싱글턴

@property (nonatomic, weak) id <DataCenterDelegate> delegate;
@property (nonatomic, weak) id <TimerDelegate> timerDelegate;

/////////////////// 미션 관련 ///////////////////

@property (nonatomic, readonly) NSMutableArray *missionList;   // 추가한 순서대로 NSString 값의 Mission List들이 쌓임
@property (nonatomic, readonly) NSInteger currentSendedMissionIndex;    // 현재 보내놓은 미션 Index
@property (nonatomic, readonly) NSString *currentReceivedMission;       // 현재 받은 미션


// 미션 태그
@property (nonatomic, readonly) NSArray *tagTextList;

- (void)addMissionByMissionTag:(NSInteger)tagIndex;
- (void)deleteMissionByMissionTag:(NSInteger)tagIndex;


// 커스텀 미션
- (void)addMissionWithMissionText:(NSString *)missionName;  // 미션명으로 추가
- (void)deleteMissionWithMissionText:(NSString *)missionName;

- (void)deleteMissionWithMissionListIndex:(NSInteger)missionListIndex;


// 데이터 저장
- (void)saveDocuPlistByMissionList;     // Document plist에 저장
- (void)saveInfoData;   // UserDefaults에 저장


// 미션 보내기
- (void)sendMissionWithIndex:(NSInteger)missionListIndex;

// 미션 완료
- (void)completeMission;
@property (nonatomic, readonly) BOOL didSendedMissionDone;
@property (nonatomic, readonly) BOOL didReceivedMissionDone;

// 미션 타이머
- (void)missionTimerStart;
- (void)missionTimerStop;

@property (nonatomic, readonly) BOOL runingTimer;
@property (nonatomic, readonly) NSString *restTimeStr;
@property (nonatomic, readonly) CGFloat percent;

@property (nonatomic, readonly) BOOL missionFailed;     // 시간 초과


@end

