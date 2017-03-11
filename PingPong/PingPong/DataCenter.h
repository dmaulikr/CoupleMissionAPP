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

@interface DataCenter : NSObject

+ (instancetype)sharedData;     // 싱글턴


/////////////////// 미션 관련 ///////////////////

@property (nonatomic, readonly) NSMutableArray *missionList;   // 추가한 순서대로 NSString 값의 Mission List들이 쌓임
@property (nonatomic) NSInteger currentMissionIndex;


// 미션 태그
@property (nonatomic, readonly) NSArray *tagTextList;

- (void)addMissionByMissionTag:(NSInteger)tagIndex;
- (void)deleteMissionByMissionTag:(NSInteger)tagIndex;


// 커스텀 미션
- (void)addMissionWithMissionText:(NSString *)missionName;  // 미션명으로 추가
- (void)deleteMissionWithMissionText:(NSString *)missionName;


// Document plist에 저장
- (void)setDocuPlistByMissionList;

@end
