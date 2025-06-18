--데이터 검색 : SELECT(SELECT, FROM 필수)

-- EMPLOYEE 테이블에서 사번, 이름, 급여 조회하기

SELECT EMP_ID, ENP_NAME, SALARY
FROM EMPLOYEE;


--EMPLOYEE테이블의 모든 정보 조회하기
SELECT *FROM EMPLOYEE; --* + TABLE명 : 전체 불러오기(직접 다쓰면 순서 내가 지정가능)

--JOB 테이블의 모든 정보 조회
SELECT * FROM  JOB;

--JOB 테이블의 직급, 이름 조회
SELECT JOB_NAME FROM JOB;

--DEPARTMENT의 모든 정보조회
SELECT * FROM DEPARTMENT;

--EMPLOYEE 테이블의 직원이름 이메일 전번 고용일 조회
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE
FROM EMPLOYEE;

--EMPLOYEE테이블의 고용일, 사원명, 월급 조회
SELECT HIRE_DATE, EMP_NAME, SALARY FROM EMPLOYEE;

--컬럼 값 산술 연산
--EMPLOYEE테이블에서 직원 명, 연봉조회(연봉 = 급여 * 12)
SELECT EMP_NAME, 12 * SALARY FROM EMPLOYEE;

--EMPLOYEE테이블에서 직원명, 연봉, 보너스를 추가한 연봉
SELECT EMP_NAME, 12*SALARY, 12*(SALARY+(BONUS*SALARY)) FROM EMPLOYEE;

--EMPLOYEE 테이블에서 이름,고용일, 근무일수(오늘날짜SYSDATE - 고용일) 조회.
SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE
FROM EMPLOYEE;

-- 컬럼 별칭달기(RESULT SET의 컬럼 이름 변경)
--  :   컬럼명 AS 별칭 / 컬럼명 "별칭"/ 컬럼명 AS "별칭" / 컬럼명 별칭
-- "" 은 별칭에 특수문자 포함되거나 숫자로 시작할 경우에 사용, 나머지 문자열은 ''로 감싼다

--EMPLOYEE테이블에서 직원명(별칭 : 이름), 연봉( 별칭 : 연봉(원)), 보너스를 추가한 연봉(별칭 : 총소득(원))
SELECT EMP_NAME 이름 , 12*SALARY AS "연봉(원)", 
        12*(SALARY+(BONUS*SALARY)) "총소득(원)" FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, SALARY, '원' AS 단위 -- ''은 리터럴로 인식되고 단위는 원이라는 컬럼명의 별칭으로 인식됨.
FROM EMPLOYEE;

-- DISTINCT : 중복을 제거해서 보여주기
--EMPLOYEE 테이블에서 직원의 직급코드를 중복제거해서 조회
SELECT DISTINCT JOB_CODE FROM EMPLOYEE;

--EMPLOYEE테이블에서직원의 직급코드, 부서코드를 중복제거해서 조회하기
SELECT DISTINCT JOB_CODE, DEPT_CODE --DISTINCT는 SELECT 절에서 한번만 사용가능
FROM EMPLOYEE;

--WHERE절 삽입 : 조건 제시 절
-- = 같다/ != ^= <> 같지않다 / 나머진 같음. 
--EMPLOYEE테이블에서 급여가 4000000이상인 직원의 이름, 급여 조회하기
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY >= 4000000;

--EMPLOYEE테이블에서 부서코드가 D9인 직원의 이름, 부서코드 조회하기
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';  --D9라고 하면 컬럼명으로 인식함. (대소문자 구분)

--EMPLOYEE테이블에서 코드가 D9이 아닌 사원의 사번, 이름, 부서코드 조회
SELECT EMP_ID, EMP_NAME 이름, DEPT_CODE 부서코드
FROM EMPLOYEE
WHERE DEPT_CODE != 'D9';

--EMPLOYEE테이블에서 퇴사여부가 N인 ㅅ직원을 조회하고 근무여부를 재직중으로 표시하여
--사번, 이름, 고용일, 근무여부 조회하기

SELECT EMP_ID 사번, EMP_NAME "이름", HIRE_dATE AS "입사일",'재직중' 근무여부
FROM EMPLOYEE
WHERE ENT_YN = 'N';

--EMPLOYEE테이블에서 월급이 3000000이상인 사원의 이름, 월급, 고용일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY >= 3000000;


--EMPLOYEE테이블에서 SAL_LEVEL이 S1인 사원의 이름, 월급, 고용일, 연락처 조회
SELECT EMP_NAME, SALARY, HIRE_DATE, PHONE
FROM EMPLOYEE
WHERE SAL_LEVEL = S1;
--EMPLOYEE테이블에서 실수령핵 (총수령 - (연봉*세금 3%)이 5천만원 이상인 
-- 사원의 이름, 월급, 실수령액,고용일 조회
SELECT EMP_NAME, SALARY, SALARY*(1+BONUS)*12-(SALARY*12*0.03) 실수령액, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY*(1+BONUS)*12-(SALARY*12*0.03) >= 50000000;

--EMPLOYEE테이블에서 연봉이 4500000초과인 사원의 이름, 월급, 연봉 조회
SELECT EMP_NAME, SALARY, SALARY*12 연봉
FROM EMPLOYEE
WHERE SALARY*12 > 4500000;
--논리연산자 : AND, OR
--EMPLOYEE테이블에서 부서코드가 'D6'이고 급여를 3백만 보다 많이 받는 직원의 이름,
--부서코드 , 급여조회하기
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE='D6' AND SALARY>=3000000;

--EMPLOYEE테이블에서 부서코드가 'D6'이거나 급여를 3백만 보다 많이 받는 직원의 이름, 부서코드 , 급여 조회하기
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6' OR SALARY > 3000000;

--EMPLOYRR테이블에서 급여를 350만원이상 600만원 이하를 받는 직원의 사번, 이름, 급여, 부서코드, 직급코드
SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND SALARY <= 6000000;



--EMPLOYEE테이블에서 월급이 400만 이상 JOB CODE가 J2인 사원의 전체내용 조회
SELECT * FROM EMPLOYEE
WHERE SALARY >= 4000000 AND JOB_CODE ='J2';




--EMPLOYEE테이블에 DEPT_CODE가 D9이거나 D5인 사원 중 고용일이 02년 1월 1일보다 빠른 사원의 이름, 부서코드, 고용일 조회
SELECT EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE = 'D9' OR DEPT_CODE = 'D5')AND HIRE_DATE < '02/01/01';


--BETWEEN AND : 컬럼명 BTW A AND B : 컬럼이 A이상B이하라는 뜻
--EMPLOYRR테이블에서 급여를 350만원이상 600만원 이하를 받는 직원의 사번, 이름, 급여, 부서코드, 직급코드
SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000;


--EMPLOYRR테이블에서 급여를 350만원 미만, 또는 600만원 초과를 받는 직원의 사번, 이름, 급여, 부서코드, 직급코드
SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE SALARY NOT BETWEEN 3500000 AND 6000000;
-- WHERE NOT SALARY BETWEEN 3500000 AND 6000000;

--EMPLOYEE 테이블에 고용일이 90/01.01 ~ 01.01.01인 사원의 전체내용을 조회
SELECT * FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';

--LIKE : 비교하려는 값이 특정 패턴(%, _)을 만족하는지 검사.
-- 형식 : 컬럼명 LIKE '문자패턴'
-- % : 0글자 이상/ _ : 1글자(_자체)
--'N%' : N으로 시작하는 값 
--'%N': N으로끝나는 값
--'N%B' : N 시작해서 B로 끝나는 값.
--'%N%' :  N을 포함하는 값
-- _ : 한 글자 단어.
-- __ : 두 글자 단어


--EMPLOYEE테이블에서 성이 전씨인 사원의 사번, 이름, 고용일 조회하기
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '전%';

--EMPLOYEE테이블에서 이름에 '하'가 포함된직원의 이름, 주민번호, 부서코드 조회
SELECT EMP_NAME, EMP_NO, DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%';

--EMPLOYEE 테이블에서 전화번호 4번째 자리가 9로 시작하는 사원의 사번, 이름,전화번호조회
SELECT EMP_ID, EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE LIKE '___9%';

--EMPLOYEE테이블에서 이메일 중 _의 앞 글자가 3자리인 이메일 주소를 가진 사원의 사번
--, 이름, 이메일 주소 조회하기
--EX. sun_di@kh.or.kr 
SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '____%'; 
--ESCAPE OPTION으로 해결 : 검색하고자 하는 데이터와 패턴이 일치하는 경우,
--                       어떤 것이 패턴이고 어떤 것이 특수문자인지 구분하지 못하기 때문에
--                       데이터로 처리할 기호 앞에 임의의 문자를 사용해서 ESCAPE처리 해주기
SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '___ _%'ESCAPE ' '; --임의의 문자 뒤에 있는 건 패턴이 아니다. 라는 뜻 

--EMPLOYEE테이블에서 이메일 중 _의 앞 글자가 3자리가 <아닌> 이메일 주소를 가진 사원의 사번

SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL NOT LIKE '___ _%'ESCAPE ' ';
-- WHERE NOT EMAIL LIKE '___ _%'ESCAPE ' ';

--EMPLOYEE 테이블에서 김씨 성이 아닌 직원의 사번, 이름, 고용일 조회하기
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE NOT EMP_NAME LIKE '김%';


--1.EMPLOYEE 테이블에서 이름 끝이'연'으로 끝나는 사원의 이름 조회
SELECT EMP_NAME
FROM EMPLOYEE 
WHERE EMP_NAME LIKE '%연';


--2. EMPLOYEE 테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';

--3. EMPLOYEE테이블에서 메일주소 '_'의 앞이 4자이면서 DEPT CODE가 D9또는 D6이고 
--  고용일이 90/01/01 ~ 00/12/01이며 급여가 270만 이상인 사원의 전체를 조회하기.
SELECT * FROM EMPLOYEE
WHERE (EMAIL LIKE '____ _%' ESCAPE ' ') AND (DEPT_CODE='D9' OR DEPT_CODE='D6')
AND (HIRE_DATE BETWEEN '90/01/01' AND '00/12/01') AND SALARY >= 2700000;


-- IS NULL / IS NOT NULL
--EMPLOYEE테이블에서 보너스를 받지않는 사원의 사번, 이름, 급여, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NULL; --오라클은 =NULL, 혹은 ==NULL이라고 안하고 IS NULL을 씀

--EMPLOYEE테이블에서 보너스를 받는 사원의 사번, 이름, 급여, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;

--EMPLOYEE테이블에서 관리자도 없고 부서 배치도 받지 않은 직원의 이름, 관리자 , 부서코드 조회
SELECT EMP_NAME, MANAGER_ID, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;

--EMPLOYEE테이블에서 부서 배치를 받지 않았지만 보너스 받는 직원의 이름, 보너스, 부서코드 조회
SELECT EMP_NAME, BONUS, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;


-- IN : 비교하려는 값이 목록에 있으면 TRUE로 반환하는 연산자 (조건일치)

--D6부서와 D9부서원들의 이름, 부서코드, 급여조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
--WHERE DEPT_CODE = 'D9' OR DEPT_CODE = 'D6';
WHERE DEPT_CODE IN ('D6', 'D9'); --DEPT_CODE가 D6 D9안에 있으면 된다~

--직급코드가 J1, J2, J3, J4인 사람들의 이름, 직급코드 , 급여조회하기
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
--WHERE JOB_CODE = 'J1' OR JOB_CODE = 'J2' OR JOB_CODE = 'J3' OR JOB_CODE = 'J4';
WHERE JOB_CODE IN ('J1''J4');
--WHERE JOB CODE BTWEEN 'J1' AND 'J4';

--연결 연산자 : || 
SELECT EMP_ID || EMP_NAME || SALARY
FROM EMPLOYEE;

SELECT EMP_NAME || ' 님의 월급은 ' || SALARY ||'원 입니다.'
FROM EMPLOYEE;




--J7 또는 J2직급의 급여 200만원 이상 받는 직원의 이름, 급여, 직급코드 조회
-- [ORDER BY] : 정렬기능

SELECT EMP_NAME 이름 , SALARY, JOB_CODE
FROM EMPLOYEE
WHERE (JOB_CODE IN( 'J2', 'J7')) AND SALARY >= 2000000
ORDER BY 이름  DESC; --내림차순(DESC) /기본 오름차순.(ASC - 생략가능)
--ORDER BY JOB_CODE ASC, SALARY DESC; 이렇게 기준두고 정렬가능

--SELET 5
--FROM 1
-- WHERE 2
-- GROUP BY 3
-- HAVING 4
--ORDER BY 6 순서로 실행하므로 SELECT별칭을 기준으로 ORDER BY 실행 가능





















