# Prompt 2

<br>

<details>
  <summary><b>bat_ind data</b></summary>
  <div markdown="1">
    <ul>
      <li>Player: 이름</li> <li>teamID: 팀약어</li>  <li>avg: batting average (타율)</li>
      <li>gp: games played (경기 출장)</li> <li>gs: games started (경기 선발 출장)</li>
      <li>avg: batting average (타율)</li> <li>ab: at bats (타수)</li> <li>r: runs (득점)</li>
      <li>h: hits (안타)</li> <li>X2b: doubles (2루타)</li> <li>X3b: triples (3루타)</li>
      <li>hr: home runs (홈런)</li> <li>rbi: Runs batted in (타점)</li> <li>tb: Total Bases Allowed (총 루타를 허용한 갯수)</li>
      <li>slg. : Slugging percentage (장타율)</li> <li>bb: walks (볼넷)</li> <li>hbp: hit batters (몸에 맞는 볼)</li>
      <li>so: strikeouts (삼진)</li> <li>gdp: Batters Grounded Into Double Plays (병살타 유도)</li>
      <li>ob. : Obstruction (주루 방해)</li> <li>sf: sacrifice hits (희생플라이)</li> <li>sh: sacrifice hits (희생타)</li>
      <li>sb: Stolen bases (도루)</li> <li>year: 연도</li>
    </ul>
  </div>
</details>

<details>
  <summary><b>bat_team data</b></summary>
  <div markdown="1">
    <ul>
      <li>Team: 팀 이름</li> <li>teamID: 팀 약어</li>  <li>avg: batting average (타율)</li>
      <li>G: games (경기 수)</li> <li>ab: at bats (타수)</li> <li>r: runs (득점)</li>
      <li>h: hits (안타)</li> <li>X2b: doubles (2루타)</li> <li>X3b: triples (3루타)</li>
      <li>hr: home runs (홈런)</li> <li>rbi: Runs batted in (타점)</li> <li>tb: Total Bases Allowed (총 루타를 허용한 갯수)</li>
      <li>slg. : Slugging percentage (장타율)</li> <li>bb: walks (볼넷)</li> <li>hbp: hit batters (몸에 맞는 볼)</li>
      <li>so: strikeouts (삼진)</li> <li>gdp: Batters Grounded Into Double Plays (병살타 유도)</li>
      <li>ob. : Obstruction (주루 방해)</li> <li>sf: sacrifice hits (희생플라이)</li> <li>sh: sacrifice hits (희생타)</li>
      <li>sb: Stolen bases (도루)</li> <li>att : (= SBA) Stolen base attempts (도루 시도)</li> <li>a : Assist (보살)</li>
      <li>e : Errors (실책)</li> <li>fld. : fielding percentage (수비율)</li> <li>year: 연도</li>
    </ul>
  </div>
</details>

<details>
  <summary><b>pitch_team data</b></summary>
  <div markdown="1">
    <ul>
      <li>Team: 팀 이름</li> <li>teamID: 팀 약어</li>  <li>era: Earned Run Average (방어율)</li>
      <li>w: Win (우승)</li> <li>l: Lose (패배)</li> <li>cg: Complete Games (완투)</li>
      <li>sho: Shutouts (완봉승)</li> <li>cbo: Combined Shutouts (combined 완봉승)</li> <li>ip: Inning Pitched (던진 이닝)</li>
      <li>ha : hit allowed (안타 허용)</li> <li>ra: runs_allowed (허용한 득점)</li> <li>er : earned Runs (자책점)</li>
      <li>bb: Walks (볼넷허용)</li> <li>so: Strikeouts (삼진)</li> <li>2b: Doubles (2루타)</li>
      <li>3b: Triples (3루타)</li> <li>hr: homeruns (홈런)</li> <li>ab : at bat (타석)</li>
      <li>b/avg : b / batting average (b / 타율)</li> <li>wp : wild pitches (폭투)</li> <li>hbp: hit by pitch (몸에 맞는 공)</li>
      <li>bk: balks (보크, 부정 투구 동장으로 인한 투수의 반칙 행위)</li> <li>sfa: Sacrifice Flies Allowed (희생플라이 허용)</li>
      <li>sha: Sacrifice Hits Allowed (희생타 허용)</li> <li>year: 연도</li>
    </ul>
  </div>
</details>

<br>

### 1. Run Value of a Win (Run Differential Model을 사용하여 value of a win 계산)

1-1. ARC_pitch_team 데이터에서 필요한 변수 추출
- **W_pct (Win percentage; 승률)** = Wins(승리) / Games(게임)
- **cs (Caught Stealing; 도루 실패)** = Stolen Base Attempts (도루 시도) - Stolen Bases (도루)
- **RD (Run Differential)** = Run Scored (득점) - Runs Allowed (실점)

<br>

1-2. RD와 W_pct 사이의 관계를 시각화하고 회귀 분석 결과를 선으로 표시
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_2/img/RD_Wpct_1.jpg" width="583px" height="360px">
</div>

RD가 높을 승률도 높아지는 **강한 양의 상관관계**를 보여줌

<br>

<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_2/img/RD_Wpct_2.jpg" width="486px" height="126px">
</div>

RD의 추정값은 **0.0017**임. 이는 RD가 1 증가할 때 평균적으로 W_pct(승률)이 0.0017 증가한다는 것을 의미  

<br>

1-3. 실제 잔차와 예측 잔차를 나타내는 그래프 추가
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_2/img/RD_Wpct_3.jpg" width="573px" height="354px">
</div>

빨간 점선은 잔차가 0인 지점을 나타내며, 실제 값과 예측 값 사이에 차이가 없음을 나타냄  
따라서 빨간색 선과 일치하는 값은 예측값과 실제값이 매우 가까운 값이고, 선 위/아래 값은 예측값과 실제값의 차이(잔차)를 나타냄

<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_2/img/RD_Wpct_4.jpg" width="573px" height="354px">
</div>

<br>
<br>
<br>

### 2. Run Value of Events (공격 변수가 득점(R)에 미치는 영향 분석)

1-1. Run Values를 사용하여 BB, HBP, 1B, 2B, 3B, HR, SB, CS와 같은 요소의 기여도를 측정
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_2/img/RV_of_Event_1.jpg" width="573px" height="354px">
</div>

3루타와 홈런의 기여도가 가장 높고, CS는 가장 낮은 음의 값을 가짐

<br>
<br>
<br>

### 3. wOBA(wOBA;가중출루율 계산)
3-1. 연간 wOBA  

<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_2/img/RV_of_Event_2.jpg" width="573px" height="354px">
</div>

<br>

3-2. wOBA 데이터의 평균값  
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_2/img/RV_of_Event_3.jpg" width="573px" height="354px">
</div>

<br>
<br>
<br>

### 4. Analyze ARC vs. MLB (ARC와 MLB의 run values 차이 분석)

<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_2/img/ARC_MLB_1.jpg" width="573px" height="354px">
</div>

MLB 데이터의 RD와 W_pct 변수 간의 상관관계는 ARC 데이터와 유사항 **강한 양의 상관관계**를 보여줌  

<br>
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_2/img/ARC_MLB_2.jpg" width="486px" height="126px">
</div>

ARC와 MLB 데이터는 모두 RD와 W_pct 사이에 양의 상관관계를 보여주며, RD가 높을수록 W_pct가 높아지는 경향이 있음을 보여줌  
그러나 ARC 데이터의 RD 추정치는 0.0017인 반면 MLB 데이터의 RD 추정치는 0.0006  
이는 RD와 W_pct 사이의 양의 선형 관계가 MLB 데이터보다 ARC 데이터에서 더 강함을 뜻함  

<br>
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_2/img/ARC_MLB_3.jpg" width="573px" height="354px">
</div>

MLB 회귀계수 추정치도 ARC과 같이 3B와 HR은 추정치가 높지만 CS는 음의 값을 가짐  
하지만 ARC는 MLB 추정치에 비해 상대적으로 극단적인 값이 더 많음  

<br>
<br>
<br>

### 5. Stolen Base Analysis (도루 성공률과 승률 사이의 관계)
도루 성공률과 W_pct의 상관관계 분석

<br>
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_2/img/StolenBase_1.jpg" width="573px" height="354px">
</div>

<br>
<br>
<br>

### 6. Calculate Metrics (고급 야구 통게 계산)
- **wRAA**  
  리그 평균과 비교하여 선수가 팀에 기여한 실점을 측정하는 지표  
  wRAA 0은 리그 평균을 나타내고, 양의 값은 **평균 이상**의 기여, 음의 값은 **평균 이하**의 기여를 나타냄

- **wRC**  
  타자가 팀에 얼마나 많은 득점을 기여하는지에 대한 추정치

- **wRC_100**  
  리그 평균이 100으로 설정된 wRC 값  
  100 이상은 **평균 이상**을 나타내고, 100 미만은 **평균 미만**을 나타냄

<br>
<div align="center">
  <img src="https://github.com/kbr1218/Sports_Analytics/blob/main/prompt/Prompt_2/img/Metrics_1.jpg" width="471px" height="194px">
</div>
