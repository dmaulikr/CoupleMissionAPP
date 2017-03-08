//
//  DataCenter.h
//  CoupleMission
//
//  Created by Jeheon Choi on 2017. 3. 8..
//  Copyright © 2017년 JeheonChoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCenter : NSObject

+ (instancetype)sharedData;

@property (nonatomic, readonly) NSString *docuPath;



/////////////////// 미션 관련 ///////////////////
/*
 일단, NSMutableArray에 NSDictionary로 미션을 쭉 나열해서 저장
 
 - missionList의 index은
   MissionTag 순서대로 쭉 나열된 후,
   CustomMission이 들어감
 
 - missionList의 index 속 Dictionary는 아래와 같음
   @{@"Name":<미션제목>, @"Status":<상태>};
 
    - <상태>
      NO : 리스트에 등록되어있지 않는 미션
      YES : 리스트에 등록되어있는 미션
 
 
 // 예시
 missionList = @[@{@"Name":@"요리하기", @"Status":@1},    // index : 0
                 @{@"Name":@"꽃주기", @"Status":@0},      // index : 1
                 @{@"Name":@"안마하기", @"Status":@0},   // index : 2        // Missiontag 3개가 끝일 경우
                 @{@"Name":@"커스텀미션명", @"Status":@1}   // index : 3        // CustomMission index 시작
                ];
 
 */

@property (nonatomic) NSMutableArray *missionList;


// 기본 미션 태그
typedef NS_ENUM(NSInteger, MissionTag) {
    COOKING = 0,    // 요리하기
    FLOWER,         // 꽃주기
    MASSAGE,        // 안마하기
    
    NumOfMissionTag     // 항상 마지막에 둬서, count 갯수 값으로 사용
};

@property (nonatomic) NSArray *missionTagStatusArr;    // 미션태그 세팅 어레이   NO : @0, YES : @1
- (void)setMissionListByMissionTagStatusArr;       // missionTagStatusArr에 완료된 설정된 대로 missionList 세팅



// 커스텀 미션 추가
- (void)addMissionListWithMissionName:(NSString *)missionName;  // 미션명으로 추가



@end
