# Data Competition 1
#### Q: 선수와 포지션의 수비 가치를 평가하는 방법을 만들고 그 평가를 사용하여 포지션의 순위 매기기

<br>

### 0. Intro
0-1. 사용한 데이터
- Fangraphs Fielder Data from 2000 to 2019
- Fangraphs Pitcher Data from 2000 to 2019
- Lahman Fielding Data
- Lahman People Data
- Fangraphs Fielder Data from 2020 to 2022

<br>

0-2. 용어 정리
- 1B: 1st Baseman (1루수)
- 2B: 2nd Baseman (2루수)
- 3B: 3rd Baseman (3루수)
- C: Catcher (포수)
- OF: Outside Fielder (외야수)
- P: Pitcher (투수)
- SS: Short Stop (유격수)
- POS: position
- InnOuts (선수가 기록한 아웃 수)
- PO (Put Out; 자살)
- A (Assist; 보살)
- E (Error; 실책)
- OAA: Outs Above Average (평균 대비 아웃 기여)

<br>

0-3. 공식 

$$
InnOuts = Inn \times 3
$$

<br>

$$
Error\,per\,Out = \frac{number\,of\,errors}{number\,of\,InnOuts}
$$

<br>
<br>

### 1. 전처리

1-1. Load Data (from 2000 to 2019)
- Pitcher(투수)를 제외한 수비수 데이터
<div align="center">
  <img src="DataCompetition1/img/1_1_dataset_fielding.jpg" width="592px" height="146px">
</div>
<br>

- Pitcher 데이터
<div align="center">
  <img src="DataCompetition1/img/1_2_dataset_pitcher.jpg" width="586px" height="149px">
</div>
<br>

- Lahman Fielding (수비) 데이터  
  Pitcher 데이터에 없는 InnOuts과 Error를 사용하기 위해 POS == pitcher인 행만 가져오기
<div align="center">
  <img src="DataCompetition1/img/1_3_dataset_LahmanFielding.jpg" width="584px" height="241px">
</div>
<br>

- Lahman People (선수) 데이터
<div align="center">
  <img src="DataCompetition1/img/1_4_dataset_LahmanPlayer.jpg" width="592px" height="149px">
</div>
<br>
<br>

1-2. 데이터셋 병합  
- [playerID]을 기준으로 Lahman Fielding에 Lahman Player의 [Name] 칼럼 추가
<div align="center">
  <img src="DataCompetition1/img/2_1_join_name.jpg" width="586px" height="151px">
</div>
<br>

- 필요한 칼럼(Name, InnOuts, E)만 선택
<div align="center">
  <img src="DataCompetition1/img/2_2_join_drop.jpg" width="586px" height="151px">
</div>
<br>

- [Name]을 기준으로 pitcher와 Lahman_fielding 데이터셋 결합
<div align="center">
  <img src="DataCompetition1/img/2_3_join_InnOutsE.jpg" width="586px" height="151px">
</div>
<br>
<br>
<br>


### 2. 포지션별 InnOuts과 Error의 합계 계산
2-1. InnOuts 칼럼 생성
<div align="center">
  <img src="DataCompetition1/img/3_1_InnOuts.jpg" width="590px" height="154px">
</div>
<br>

2-2. 각 포지션별 InnOuts 합계 계산  
- fielding 데이터셋
<div align="center">
  <img src="DataCompetition1/img/3_2_fieldingOuts.jpg" width="585px" height="198px">
</div>
<br>

- pitcher 데이터셋
<div align="center">
  <img src="DataCompetition1/img/3_3_pitcherOuts.JPG" width="586px" height="78px">
</div>
<br>

- fielding + pitcher
<div align="center">
  <img src="DataCompetition1/img/3_4_FieldingOuts.JPG" width="582px" height="218px">
</div>
<br>

2-3. 각 포지션별 Error 합계 계산
- fielding 데이터셋
<div align="center">
  <img src="DataCompetition1/img/4_1_fieldingErrors.JPG" width="583px" height="196px">
</div>
<br>

- pitcher 데이터셋
<div align="center">
  <img src="DataCompetition1/img/4_2_pitcherErrors.JPG" width="586px" height="82px">
</div>
<br>

- fielding + pitcher
<div align="center">
  <img src="DataCompetition1/img/4_3_FieldingErrors.JPG" width="586px" height="221px">
</div>
<br>
<br>
<br>


### 3. error/out 비율 계산
- error/out을 구하고 비율 계산
<div align="center">
  <img src="DataCompetition1/img/5_1_rate.JPG" width="586px" height="218px">
</div>
<br>

- 내림차순 정렬
<div align="center">
  <img src="DataCompetition1/img/5_2_rank.JPG" width="590px" height="218px">
</div>
<br>
<br>
<br>

### 4. 시각화
<div align="center">
  <img src="DataCompetition1/img/6_1_visualization.jpg" width="583px" height="360px">
</div>

- 'error/out'값이 높다 == error의 비율이 높다
- 'error/out'값이 낮다 == error의 비율이 낮다

<br>
<br>
<br>


### 5. OAA (Outs Above Average; 평균 대비 아웃 기여)
5-1. OAA 칼럼이 있는 fielding 데이터셋 불러오기
<div align="center">
  <img src="DataCompetition1/img/7_1_OAA.JPG" width="586px" height="145px">
</div>

catcher(포수)의 OAA는 Null이므로 제외

<br>

5-2. 포지션별 OAA의 평균 계산
<div align="center">
  <img src="DataCompetition1/img/7_2_OAAmean.JPG" width="588px" height="188px">
</div>
<br>

5-3. 시각화
<div align="center">
  <img src="DataCompetition1/img/7_3_visualization.JPG" width="583px" height="360px">
</div>
<br>
