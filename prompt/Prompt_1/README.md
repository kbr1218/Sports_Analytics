# Prompt 1
### 스포츠를 선택하고 그 스포츠에 대한 "더 나은 측정법(better metric)" 개발하기

- **Sports**: Baseball
- **Stakeholder**: General Manager of the baseball team
- **Needs**: 타율, 장타율, 출루율, OPS 등 전통적인 통계를 넘어 GM이 선수의 공격 생산을 평가하는 데 도움이 될 수 있는 지표
- **data source**: [2022 MLB Player Batting](https://baseballsavant.mlb.com/), [2022 MLB Team Batting](https://www.fangraphs.com/)

<br>

## Player's Overall Offensive Production

### 1. Load Data
1-1. 2022년 MLB batters의 데이터 로드
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_1/img/batter_table_1.JPG" width="578px" height="116px">
</div>
<br>

1-2. first_name + last_name으로 name 칼럼 만들기
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_1/img/batter_table_2.JPG" width="578px" height="116px">
</div>
<br>

1-3. 칼럼명을 약어로 수정 (e.g. batting_avg -> BA, slg_percent -> SLG 등)
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_1/img/batter_table_3_rename.JPG" width="578px" height="116px">
</div>
<br>
<br>


### 2. Normalization
2-1. 각 통계량을 해당 범주의 리그 평균으로 나누는 정규화를 하기 위해 필요한 데이터의 각 범주의 평균을 구하기
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_1/img/batter_table_4_mean.JPG" width="582px" height="86px">
</div>
<br>

2-2. 각 통계량을 0에서 1의 척도로 정규화
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_1/img/batter_table_5_normalization.JPG" width="578px" height="116px">
</div>
<br>
<br>


### 3. Correlation
3-1. 가중치를 계산하기 위해 각각 해당 범주의 상관관계 계산
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_1/img/batter_table_6_cor.JPG" width="582px" height="86px">
</div>

- BA: 0.451
- OBP: 0.554
- SLG: 0.655
- OPS: 0.687

<br>

3-2. 상관관계 시각화
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_1/img/batter_table_7_cor_graph.JPG" width="583px" height="360px">
</div>
<br>
<br>


### 4. Weight
4-1. 공격력을 측정하는 데 있어 상대적인 중요성을 기반으로 각 지표에 가중치를 할당. 가중치는 네 범주의 상관관계의 합에 대한 각 범주의 비율로 계산
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_1/img/batter_table_8_weight.JPG" width="582px" height="86px">
</div>

- BA: 0.192
- OBP: 0.235
- SLG: 0.279
- OPS: 0.293  

<br>


### 5. overall_data
5-1. 정규화된 각 데이터에 가중치를 곱해 새로운 지표(overall_data)를 만듦
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_1/img/batter_table_9_overalldata.JPG" width="589px" height="170px">
</div>
<br>
    
5-2. 가중치를 사용하여 생성된 overall_data와 R(run) 사이의 상관관계 계산
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_1/img/batter_table_10_cor.JPG" width="582px" height="86px">
</div>

- BA: 0.
- OBP: 0.259
- SLG: 0.270
- OPS: 0.276

<br>

5-3. 상관관계 시각화
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_1/img/batter_table_11_cor.JPG" width="583px" height="360px">
</div>
overall_data의 상관관계는 0.680으로 OPS(0.687)와 유사한 수치를 보임
<br>
<br>
<br>
<br>
    

## Team Data로 같은 과정 진행
### 1. Load Data
1-1. 2022년 MLB team batting 데이터 로드
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_1/img/team_table_1.JPG" width="578px" height="116px">
</div>
<br>

1-2. AVG 칼럼명을 BA로 수정
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_1/img/team_table_2.JPG" width="578px" height="116px">
</div>
<br>
<br>


### 2. Normalization
2-1. 각 통계량을 해당 범주의 리그 평균으로 나누는 정규화를 하기 위해 필요한 데이터의 각 범주의 평균을 구하기
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_1/img/team_table_3_mean.JPG" width="582px" height="86px">
</div>
<br>

2-2. 각 통계량을 0에서 1의 척도로 정규화
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_1/img/team_table_4_nor.JPG" width="578px" height="116px">
</div>
<br>
<br>


### 3. Correlation
3-1. 가중치를 계산하기 위해 각각 해당 범주의 상관관계 계산
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_1/img/team_table_5_cor.JPG" width="582px" height="86px">
</div>

- BA: 0.675
- OBP: 0.897
- SLG: 0.933
- OPS: 0.954

<br>

3-2. 상관관계 시각화
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_1/img/team_table_6_cor.JPG" width="583px" height="360px">
</div>
<br>
<br>


### 4. Weight
4-1. 공격력을 측정하는 데 있어 상대적인 중요성을 기반으로 각 지표에 가중치를 할당. 가중치는 네 범주의 상관관계의 합에 대한 각 범주의 비율로 계산
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_1/img/team_table_7_weight.JPG" width="582px" height="86px">
</div>

- BA: 0.195
- OBP: 0.259
- SLG: 0.270
- OPS: 0.276

<br>


### 5. overall_data
5-1. 정규화된 각 데이터에 가중치를 곱해 새로운 지표(overall_data)를 만듦
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_1/img/team_table_8_overall.JPG" width="589px" height="170px">
</div>
<br>
    
5-2. 가중치를 사용하여 생성된 overall_data와 R(run) 사이의 상관관계 계산
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_1/img/team_table_9_cor.JPG" width="582px" height="86px">
</div>
<br>

5-3. 상관관계 시각화
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_1/img/team_table_10_cor.JPG" width="583px" height="360px">
</div>
overall_data의 상관관계는 0.945으로 높지만 OPS(0.954)보다 낮은 수치를 보임
<br>
<br>
<br>
<br>


## Conclusion
이 종합 점수(overall_data)를 사용하여 여러 통계 범주에서 플레이어를 비교하고 전체 공격적인 생산을 평가할 수 있다. 
종합점수가 높을수록 선수의 공격력이 좋아지지만, 이 지표는 방어 또는 베이스 러닝 기여를 고려하지 않으며, 다른 지표 및 플레이어 성능의 정성적 평가와 함께 사용되어야 한다는 단점이 있다.  

<br>

+) feedback: OPS는 이미 Runs와 가장 상관관계가 높기 때문에 Runs와 상관관계가 낮은 지표로 가중 평균을 사용하면 상관관계가 낮은 지표가 생성된다는 것은 놀라운 일이 아닙니다.
