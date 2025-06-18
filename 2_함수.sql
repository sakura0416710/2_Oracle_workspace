--함수 : 컬럼의 값을 읽어서 계산한 결과를 리턴
--단일행 함수 : N개의 값을 읽어서 N개의 결과 리턴
-- 그룹 함수 : N개의 값을 읽어서 1개의 결과 리턴
--함수를 사용할 수 있는 위치 : SELECT, WHERE, GROUP BY, HAVING, ORDER BY

--<단일행함수>
--문자 관련 함수
--1.LENGTH 문자열 길이 / LENGTHB 문자열 길이에 대한 바이트 크기 리턴
SELECT LENGTH('오라클'),LENGTHB('오라클')FROM DUAL; --DUAL :가상테이블, 범위테이블, 굳이 EMPLOYEE에서 모든 데이터 뽑을 필요가 없기 때문.
SELECT LENGTH(EMAIL), LENGTHB(EMAIL) FROM EMPLOYEE; --위처럼 리터럴이 아니라 컬럼을 사용했으므로 EMPLOYEE
SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME) FROM EMPLOYEE;

--INSTR
SELECT INSTR('AABAACAABBAA', 'B'), INSTR('AABAABAABBAA','A') FROM DUAL;
SELECT INSTR('AABAACAABBAA', 'B', 5) FROM DUAL;
SELECT INSTR('AABAACAABBAA', 'A', -3) FROM DUAL; --8이 나옴.
--거꾸로 세지만 위치값은 앞에서 센것부터 나온다
SELECT INSTR ('AABAACAABBAA', 'B', 1,2)FROM DUAL;

--EMPLOYEE 테이블에서 이메일의 @ 위치 뽑기
SELECT EMAIL, INSTR(EMAIL, '@') FROM EMPLOYEE;

--LPAD / RPAD
SELECT LPAD (EMAIL, 20), RPAD(EMAIL, 20) FROM EMPLOYEE;
--     sun_di@kh.or.kr
--sun_di@kh.or.kr     
SELECT LPAD(EMAIL, 20, '@'), RPAD(EMAIL, 20, '#') FROM EMPLOYEE; --자리 만들고 빈 값을 왼쪽 / 오른쪽에 넣어라.

--LTRIM / RTRIM
SELECT LTRIM (' KH'), LTRIM('   KH     '), LTRIM('KH   ') FROM DUAL;
SELECT RTRIM (' KH'), RTRIM('   KH   '), RTRIM('KH   ')FROM DUAL;
SELECT LTRIM('00012345', '0') FROM DUAL; --왼쪽부터 0을 지워줌
SELECT LTRIM('0000123KH123', '123') FROM DUAL; --삭제할 문자를 지워줌. 꼭 순서가 일치하지 않아도 1,2,3을 지움.
--000KH123이 나옴. 
SELECT RTRIM('0000123KH123', '123') FROM DUAL; --0000123KH
--TRIM(양쪽 삭제)
SELECT TRIM ('      KH      ') A FROM DUAL; --KH.
SELECT TRIM('ZZZZKHZZZZ', 'Z') FROM DUAL; --이건 안됨
SELECT TRIM('Z' FROM 'ZZZZKHZZZ') FROM DUAL; --'KH      '
SELECT TRIM('0123456789' FROM '23456KH89') FROM DUAL; --안됨. 하나 문자만 갖고 있어야 함.
SELECT TRIM(LEADING 'Z' FROM 'ZKHZ'),
       TRIM(TRAILING 'Z' FROM 'ZKHZ'),
       TRIM(BOTH 'Z' FROM 'ZKHZ')
FROM DUAL;


--SUBSTR: 문자열 중 일부 문자열 반환SUBSTR(문자열, A,B)문자열의 A번째부터 B개를 뽑아라
SELECT SUBSTR('HEELOMYGOODFRIEND', 7) FROM DUAL; --7번째 부터 끝까지 출력
SELECT SUBSTR('HELLOMYGOODFRIEND', 5,2) FROM DUAL; --5번째부터 2개이므로 5,6번째 문자 반환.
SELECT SUBSTR('HELLOMYGOODFRIEND', 5,0) FROM DUAL; --길이가 0은 못가져오니까 NULL
SELECT SUBSTR('HELLOMYGOODFRIEND', -8,3) FROM DUAL; --ODF (거꾸로 센 순서에서 3개뽑기. 뽑는 건 앞에서부터 뽑음ㅇㅇ)
--EMPLOYRR테이블의 이름, 이메일, @이후를 제외한 아이디 조회
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL,1,INSTR(EMAIL,'@')-1 )ID FROM EMPLOYEE;

--EMPLOYEE테이블에서 이름과 주민번호에서 성별을 나타내는 부분 조회
SELECT EMP_NAME, SUBSTR(EMP_NO, 8, 1)성별 FROM EMPLOYEE;
SELECT EMP_NAME, SUBSTR(EMP_NO, INSTR(EMP_NO,'-')+1, 1)성별 FROM EMPLOYEE;
--EMPLOYEE테이블에서 직원들의 주민번호를 이용하여 사원 명, 생년, 생월, 생일 조회
SELECT EMP_NAME, SUBSTR(EMP_NO, 1, 2) 생년, SUBSTR(EMP_NO, 3, 2)생월, SUBSTR(EMP_NO, 5,2)생일 FROM EMPLOYEE;

SELECT EMP_NAME, '남자' 성별 FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, INSTR(EMP_NO, '-')+1, 1) IN (1,3,5,7);

--LOWER / UPPER/ INICAP
SELECT  LOWER('Welcome To My World'),
        UPPER ('Welcome To My World'),
        INITCAP ('welcome to my world')
FROM DUAL;

--CONCAT : 문자열 이어주기
SELECT CONCAT('가나다라', 'ABCD'), '가나다라' || 'ABCD' FROM DUAL;
--가나다라ABCD , 가나다라ABCD(둘다 이어져서 나옴)

--REPLACE
SELECT REPLACE('서울시 강남구 역삼동', '역삼동', '삼성동')FROM DUAL;
SELECT REPLACE('가나다라마바사', '다라', '아자')FROM DUAL;

--EMPLOYEE테이블에서 사원 명, 주민번호 조회
--단, 주민번호는 생년월일만 보이게 하고 '-'다음 값은 '*'로 변경
SELECT EMP_NAME, SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-'))|| '*******' 
FROM EMPLOYEE;

SELECT EMP_NAME, CONCAT(SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-')), '*******') 
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD( SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-')),LENGTH(EMP_NO),'*')
FROM EMPLOYEE;

SELECT EMP_NAME, REPLACE(EMP_NO, SUBSTR(EMP_NO, INSTR(EMP_NO,'-')+1),'*******')
FROM EMPLOYEE;



--숫자 관련 함수
--1. ABS : 절댓값 추출
SELECT ABS (10.9), ABS(-10.9), ABS(10), ABS(-10) FROM DUAL;
--2. MOD : 나머지 구하기 //나눠지는 수가 음수면 부호도 음수를 따라감. 
SELECT MOD(10,3), MOD(-10,3), MOD(10,-3), MOD(-10, -3), MOD(10.9, 3) FROM DUAL;

--3. ROUND : 반올림,자리지정가능
SELECT ROUND(123.456) FROM DUAL; --123 (소수점 첫째자리에서 반올림함)
SELECT ROUND(123.654) FROM DUAL; --124
SELECT ROUND(123.678, 0), ROUND (123.456,1), ROUND(123.456, 2), ROUND(123.456, -2) FROM DUAL;
--소수점 첫째자리는 0부터 셈!!


--FLOOR, TRUNC: 내림. 자리지정불가
SELECT FLOOR(123.456), FLOOR(123.756) FROM DUAL; --123, 123 (내림)
SELECT TRUNC(123.456), TRUNC(123.756) FROM DUAL; --123, 123(버림= 절삭)
SELECT TRUNC(123.456, 0), TRUNC (123.456, 1) FROM DUAL; --123, 123.4
SELECT FLOOR( -1.1), TRUNC(-1,1) FROM DUAL; -- -2(내림), -1(버림)


--CEIL : 올림
SELECT CEIL(123.456), CEIL(123.756) FROM DUAL;





--날짜 관련 함수
--1. MONTHS BETWEEN
--EMPLOYEE테이블에서 사원의 이름, 입사일, 근무 개월수 조회
SELECT EMP_NAME, HIRE_DATE, CEIL (ABS(MONTHS_BETWEEN(SYSDATE, HIRE_DATE))) 개월차 --인자 바꿔넣으면 음수가 나오므로 ABS넣어서 절대값으로 만들기+CEIL로 올림+MONTS BETWEEN 로 날짜받아서 몇개월 차인지 반환
FROM EMPLOYEE;




--2.ADD MONTHS : 개월 수 더하기 (년도도 같이 넘어감)
SELECT ADD_MONTHS(SYSDATE , 5), ADD_MONTHS(SYSDATE, 10) FROM DUAL; 





--3.NEXT_DAY : 가장 가까운 날 반환. 일요일이 1. 
SELECT SYSDATE, NEXT_DAY(SYSDATE, '목요일'),NEXT_DAY(SYSDATE, '목'),NEXT_DAY(SYSDATE, 5)
       ,NEXT_DAY(SYSDATE, '수박화채 냠냠') 
       -- 맨 앞글자만 보기 때문에 수요일이 나옴
       --영어는 인식을 못하기 때문에 설정을 바꿔줘야함.
FROM DUAL;

ALTER SESSION SET NLS_LANGUAGE = AMERICAN; --영어 인식을 위해 설정 바꾸기
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'MONDAT') FROM DUAL; --5/19
SELECT NEXT_DAY(SYSDATE, 'MON') FROM DUAL; -- 5/19
SELECT NEXT_DAY(SYSDATE, 'MONSTER') FROM DUAL; --5/19 (앞글자만 인식해서)

ALTER SESSION SET NLS_LANGUAGE = KOREAN;




--4.LAST_DAY : 해당 달의 마지막 날을 리턴해줌
SELECT LAST_DAY(SYSDATE) FROM DUAL; 

--EMPLOYEE 테이블에서 사원 명, 입사일, 입사한 달의 근무월수 조회
SELECT EMP_NAME 사원명,HIRE_DATE 입사일 , LAST_DAY(HIRE_DATE) - HIRE_DATE
FROM EMPLOYEE;

--EMPLOYEE테이블에서 근무년수가 20년 이상인 직원 정보 조회
SELECT * FROM EMPLOYEE
WHERE (SYSDATE - HIRE_DATE)/365 >= 20;
--WHERE MONTHS_BETWEEN(SYSDATE, HIRE_DATE)/12 >= 20;
--WHERE ADD_MONTHS(HIRE_DATE, 240) <= SYSDATE;



--5. EXTRACT
--EMPLOYEE 테이블에서 사원의 이름, 입사 년, 입사 월, 입사 일 조회
SELECT EMP_NAME, 
    EXTRACT(YEAR FROM HIRE_DATE) "입사년도",
    EXTRACT (MONTH FROM HIRE_DATE) "입사 월",
    EXTRACT (DAY FROM HIRE_DATE) "입사 일"
FROM EMPLOYEE
ORDER BY "입사년도", "입사 월", "입사 일"; --ASC가 디폴트로 오름차순 정렬. (DESC가 내림차순)

--연습문제 : EMPLOYEE테이블에서 사원의 이름, 입사일, 근무년수 (현재년도 - 입사년도) 조회하기
SELECT EMP_NAME, HIRE_DATE, EXTRACT (YEAR FROM SYSDATE) - EXTRACT( YEAR FROM HIRE_DATE)"근무년수"
FROM EMPLOYEE
ORDER BY "근무년수" DESC; --내림차순 정렬



--형변환 함수
--TO_CHAR : 날짜 / 숫자를 문자데이터로 변경 (원하는 형식으로 만들 수 있다)
SELECT 1234 "그냥숫자 1234", TO_CHAR(1234)FROM DUAL; --숫자는 오른쪽 정렬, 문자는 왼쪽 정렬
SELECT TO_CHAR(1234) + 4321 FROM DUAL; --5555 (덧셈이 됨;)
SELECT TO_CHAR(1234, '99999')A FROM DUAL; --5칸만들고 왼쪽 문자를 넣은 거라 숫자가 아님. 빈칸을 공백으로 넣겠다 라는 뜻.
SELECT TO_CHAR(1234, '00000') B FROM DUAL; --빈칸에 0넣음. 0 아님 9(공백) 만 됨.
SELECT TO_CHAR(1234, 'L99999'), TO_CHAR(1234, '$99999'),     --         ￦1234,  $1234
            TO_CHAR(1234, 'FML99999'), TO_CHAR(1234, 'FM$99999') FROM DUAL; --FM넣으면 공백없이 출력.

SELECT TO_CHAR(1234, '99,999'), TO_CHAR(1234, 'FM99,999') FROM DUAL;

SELECT TO_CHAR(1234, '999') FROM DUAL; --####

--연습문제 : EMPLOYEE테이블에서 사원명, 급여(\9,000,000 형식) 표시 조회하기
SELECT EMP_NAME, TO_CHAR(SALARY, 'FML9,999,999')급여 FROM EMPLOYEE; --9로 하면 남는 자리는 공백으로 나옴

-- TO_CHAR  날짜에 적용시키기
SELECT TO_CHAR(SYSDATE, 'YYYY"년"-MM"월"-DD"일" DAY HH:MI:SS') FROM DUAL;
--2025년-05월-12일 월요일 03:04:48
SELECT TO_CHAR(SYSDATE, 'YYYY"년"-FMMM"월"-DD"일" DAY HH:MI:SS') FROM DUAL;
--2025년-5월-12일 월요일 3:5:0 (FM이후의 0이 다 사라짐)
SELECT TO_CHAR(SYSDATE, 'YYYY"년"-MM"월"-DD"일" DAY HH24:MI:SS') FROM DUAL;
--2025년-05월-12일 월요일 15:05:23

SELECT TO_CHAR (SYSDATE, 'YYYY'), TO_CHAR(SYSDATE, 'YY'), TO_CHAR(SYSDATE, 'YEAR')FROM DUAL;
--2025   25   TWENTY TWENTY-FIVE
SELECT TO_CHAR(SYSDATE, 'MM'), TO_CHAR(SYSDATE, 'MONTH'), TO_CHAR(SYSDATE, 'MON'), TO_CHAR(SYSDATE, 'RM') FROM DUAL;
--05   5월    5월    V(로마자)
SELECT TO_CHAR(SYSDATE, 'DDD'), TO_CHAR(SYSDATE, 'DD'), TO_CHAR(SYSDATE, 'D') FROM DUAL;
--132   12(오늘 날짜)   2(주기준 일요일이 1이므로 오늘 월요일이라 2)
SELECT TO_CHAR(SYSDATE, 'Q'), TO_CHAR(SYSDATE, 'DAY'), TO_CHAR(SYSDATE, 'DY') FROM DUAL;
--2(분기)  월요일(오늘 요일)    월(=DAY)

--TO_DATE : 문자/숫자 데이터를 날짜 데이터로 변환
SELECT TO_DATE('20100101', 'YYYYMMDD'), TO_DATE(20100101, 'YYYYMMDD'),
    TO_DATE(20100101), TO_DATE('20100202')
FROM DUAL;
--10/01/01   10/01/01   10/01/01   10/02/02

--TO_CHAR, TO_DATE 섞어쓰기
SELECT TO_DATE ('250919 175014', 'YYMMDD HH24MISS') FROM DUAL;
--25/09/19 (DATE라서 시간이 안나옴)
--시분초 : TIMESTAMP이용
SELECT TO_CHAR(TO_DATE ('250919 175014', 'YYMMDD HH24MISS'), 'YY-MM-DD PM HH:MI:SS DY' ) FROM DUAL;
--25-09-19 오후 05:50:14 금
SELECT TO_CHAR(TO_DATE(980606, 'YYMMDD'), 'YYYYMMDD'), TO_CHAR(TO_DATE(980606, 'RRMMDD'), 'YYYYMMDD'),
        TO_CHAR(TO_DATE(180606, 'YYMMDD'), 'YYYYMMDD'), TO_CHAR(TO_DATE(180606, 'RRMMDD'), 'YYYYMMDD')
FROM DUAL;
--YY말고 RR로도 가능하다.

--TO_NUMBER : 문자를 숫자로 변환
SELECT TO_NUMBER ('123456') FROM DUAL; --   123456 (오른쪽 정렬 = 숫자)
SELECT '1,000,000' + '2,000,000' FROM DUAL; --안댐;머임 어떨 땐 되고 어떨 땐 안됨
SELECT TO_NUMBER('1,000,000' , '999,999,999') + TO_NUMBER ('2,000,000', '999,999,999') FROM DUAL; --3000000





--NULL 처리 함수
--EMPLOYEE테이블에서 사원명과 보너스가 포함된 연봉 조회
SELECT EMP_NAME, SALARY*(1+NVL(BONUS, 0))*12 FROM EMPLOYEE;
SELECT EMP_NAME, BONUS, NVL(BONUS, 0) FROM EMPLOYEE; ---BONUS가 NUMBER라서 문자열안댐. 처리할 때는 컬럼의 자료형을 따라야함 !!!!!!!
--EX. NVL(BONUS, "보너스 없음") 이렇게 안된단 뜻.


--선택 함수
--(1)DECODE(계산식OR 컬럼명, 조건값1, 선택값1, 조건값2, 선택값2, ....)
--조건에 맞는 값을 반환
SELECT EMP_ID, EMP_NAME, EMP_NO,
    DECODE(SUBSTR(EMP_NO, (INSTR(EMP_NO, '-')+1),1), 1, '남', 2, '여')성별1,
    DECODE(SUBSTR(EMP_NO, (INSTR(EMP_NO, '-')+1),1), 1, '남', '여') 성별2 --조건식 생략가능
FROM EMPLOYEE;

--직원의급여를 인상하고자한다.
--직급코드가 J7인 직원은 급여 10% 인상,직급코드가 J6인 직원은 급여의 15%를,
--직급코드가 J5인 사람은 20%, 그 외는 5%만 인상한다. 
--EMPLOYEE테이블에서 직원명, 직급코드 , 급여, 인상급여(위 조건) 조회

SELECT EMP_NAME, JOB_CODE, SALARY, DECODE((SALARY * '9.999'), 'J7', SALARY *1.1, 'J6', SALARY*1.15, 'J5', SALARY*1.2, SALARY*1.05)인상급여  
FROM EMPLOYEE;

SELECT EMP_NAME, JOB_CODE, SALARY, DECODE(JOB_CODE, 'J7',SALARY*1.1,
                                                    'J6',SALARY*1.15,
                                                    'J5',SALARY*1.2,
                                                         SALARY*1.05) 인상급여  
FROM EMPLOYEE;

--CASE WHEN 조건식 THEN 결과값
--     WHEN 조건식 THEN 결과값
--     ELSE 결과값
--END

SELECT EMP_ID, EMP_NAME, EMP_NO,
        CASE WHEN SUBSTR(EMP_NO, INSTR(EMP_NO, '-')+1,1) = 1 THEN '남'
             WHEN SUBSTR(EMP_NO, INSTR(EMP_NO, '-')+1,1) = 2 THEN '여'
        END 성별 --컬럼명이 길어져서 별칭 넣어주기
        
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, EMP_NO,
    CASE SUBSTR(EMP_NO, INSTR(EMP_NO, '-')+1,1) WHEN '1' THEN '남' --문자열을 뽑았기 때문에 비교는 1이 아니라 '1'로 하기
                ELSE '여'
    END 성별
FROM EMPLOYEE;



SELECT EMP_NAME, JOB_CODE, SALARY,
    CASE WHEN JOB_CODE = 'J7' THEN SALARY * 1.1 
         WHEN JOB_CODE = 'J6' THEN SALARY * 1.15
         WHEN JOB_CODE = 'J5' THEN SALARY * 1.2
         ELSE SALARY * 1.05
    END 인상된연봉
FROM EMPLOYEE;

--급여가 500만 보다 크면 1등급, 350만보다 크면 2, 200만 보다 크며 3, 나머지는 4등급
SELECT EMP_ID, EMP_NAME, SALARY,
CASE WHEN SALARY > 5000000 THEN '1등급'
     WHEN SALARY > 3500000 THEN '2등급'
     WHEN SALARY > 2000000 THEN '3등급'
     ELSE '4등급'
    END 등급
FROM EMPLOYEE;

--DECODE는 저런 범위값을 표현하는 것이 불가능함




--<그룹 함수>
--SUM ( 컬럼명 OR 계산식 등)
SELECT SUM(SALARY) FROM EMPLOYEE;
SELECT SUM(SALARY) FROM EMPLOYEE WHERE SUBSTR(EMP_NO, INSTR(EMP_NO, '-')+1,1) = 1;

--AVG :평균
SELECT AVG (SALARY) FROM EMPLOYEE; --전직원의 월급 평균
SELECT AVG( BONUS) FROM EMPLOYEE; -- 애초에 NULL빼고 계산함 (그럼 인원수가 줄잖아)
SELECT AVG(NVL (BONUS, 0)) FROM EMPLOYEE; --NULL을 0으로 처리한 다음에 해야 정확함

--MIN / MAX
SELECT MIN(SALARY), MIN(EMP_NAME), MIN(HIRE_DATE) FROM EMPLOYEE; --모든 타입 다 가능

--COUNT
SELECT COUNT (*), COUNT(BONUS)
FROM EMPLOYEE; --행을 센다.
--BONUS받고 있는 사람 (NULL이 아닌 사람)
--COUNT도 NULL 첨부터 배제

SELECT COUNT(NVL(BONUS, 0)) FROM EMPLOYEE; --일케해주면 행 23나옴












