# iOS-Picterest
- 원티드 프리온보딩 1기 세 번째 과제
- Unsplash API를 활용한 이미지 가져오기 및 가변 세로 길이의 레이아웃 구성
- FileManager, CoreData를 통해 원하는 사진을 선택해 저장하는 기능 구현

# 팀원
|숭어|
|--|
|[<img src="https://avatars.githubusercontent.com/u/31765530?v=4" width="200">](https://github.com/hhhan0315)|

# 개발환경
![개발1](https://img.shields.io/badge/iOS-13.1-silver)

# 기능
|이미지 Pagination|재실행 시 저장된 이미지 표시|
|--|--|
|<img src="https://github.com/hhhan0315/ios-wanted-Picterest/blob/main/스크린샷/이미지_Pagination.gif" width="220">|<img src="https://github.com/hhhan0315/ios-wanted-Picterest/blob/main/스크린샷/저장된_사진_표현.gif" width="220">|

|이미지 저장 성공|이미지 저장 실패|이미지 삭제|
|--|--|--|
|<img src="https://github.com/hhhan0315/ios-wanted-Picterest/blob/main/스크린샷/이미지_저장_성공.gif" width="220">|<img src="https://github.com/hhhan0315/ios-wanted-Picterest/blob/main/스크린샷/이미지_저장_실패.gif" width="220">|<img src="https://github.com/hhhan0315/ios-wanted-Picterest/blob/main/스크린샷/이미지_삭제.gif" width="220">|

# 회고
## FileManager
- 프로젝트 조건에 CoreData에 id, 메모, 사진 원본 url, 사진 저장 위치를 저장하도록 제시
- 사진 저장 위치에 documentDirectory를 포함한 이미지 파일 주소 전체를 저장했지만 시뮬레이터에서 앱을 재실행할 경우 documentDirectory가 계속 바뀌는 문제가 발생해 이미지 로딩 실패
- 저장 시 id, data를 통해 해당 id를 제목으로 가지는 이미지 파일 저장
- 불러올 경우 전체 주소가 아닌 id를 통해서만 해당 directory에서 탐색
- 조건과 다르게 CoreData에는 id, 메모, 사진 원본 url, 생성 날짜 저장 

## UICollectionViewDiffableDataSource
- CollectionView reloadData or reloadSections 시 깜빡임 현상 발생
- iOS 13.0부터 가능
- 데이터가 달라진 부분을 추적하여 자연스럽게 UI를 업데이트
- Hash value를 활용해 달라진 부분을 파악
- 첫 번째 화면, 두 번째 화면 모두 UICollectionViewDiffableDataSource 활용

## 이미지 중복 발생
- 첫 번째 화면에서 page가 하나씩 증가하면서 Pagination 구현
- 중복이 발생한 경우
  - 15개의 사진을 불러올 경우 발생 -> 10개, 13개 등 15개가 아닌 것으로 수정했을 때는 발생하지 않음
  - 잠시 기다리면 새로운 사진이 추가되면 그 뒤로는 중복 발생하지 않음
  - 네트워크의 문제라고 생각
- UICollectionViewDiffableDataSource 사용 시 사용하는 모델이 서로 구분할 수 있는 Hash value를 가져야 함
  - 처음에는 네트워크 요청 후 받는 id String 값으로 설정
  - 하지만 의도치 않은 경우에 이미지 중복 발생해 Hash value가 unique하지않아 앱 실행 불가
  - UUID를 사용해 unique하도록 구현

## NotificationCenter, Delegate
- NotificationCenter를 사용한 이유
  - 첫 번째 화면에서 별 버튼 클릭 -> 메모 입력 -> 저장 완료 -> 두 번째 화면에서 CoreData fetch
  - 두 번째 화면에서 삭제 -> 삭제 성공 -> 첫 번째 화면에서 별 버튼 새로고침 위해 컬렉션 뷰 새로고침
- 멘토분과 질문 후 NotificationCenter는 Notification.Name에서 실수가 발생할 수도 있고 많아지면 호출하는 부분도 헷갈릴 수 있는 문제 발생 가능
- 두 개의 ViewController에 delegate 생성 후 해당 기능 구현

## iOS 13.1로 개발한 이유
- iOS 13.0 시뮬레이터 실행 시 UIAlertController의 title, message가 한글이면 오류 발생하며 나타나지 않는 발생
- 내 컴퓨터만의 문제인지 모르겠지만 iOS 13.1부터는 정상 동작 확인
