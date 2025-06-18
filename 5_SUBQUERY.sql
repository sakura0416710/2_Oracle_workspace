--SUBQUERY
--메인 쿼리(기존 쿼리)를 위해 보조 역할을 하는 쿼리문

--맛보기
--노옹철 사원과 같은 소속의 직원 명단 조회하기
--1)노옹철 사원의 부서 찾기
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철'; -- D9

--2) 부서코드가 D9인 직원조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

--1) + 2)  : 최종 목적이 주요, 기준이 서브
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE 
                   FROM EMPLOYEE 
                   WHERE EMP_NAME = '노옹철');

--전 직원의 평균 급여보다 많이 받는 직원의 사번, 이름, 직급코드 , 급여조회
--1)전 직원의 평균 급여
SELECT AVG(SALARY)
FROM EMPLOYEE;
--2)그 급여보다 많은 직원의 ~ 기준
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3047662.60869565217391304347826086956522 ;

--1) + 2)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);

--<1>단일행 서브쿼리 : 서브쿼리의 조회 결과 행 개수가 1개일 경우 (즉, 기준이 1개일 경우)
-- 일반적으로 단일행 서브쿼리 앞에는 일반 연산자 사용
--EX. 노옹철 사원의 급여보다 많이 받는 직원의 사번, 이름 , 직급코드, 급여조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY = (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME = '노옹철');

--EX. 전 직원의 평균 급여보다 적은 급여를 받는 직원의 이름, 직급코드, 부서코드, 급여 조회 
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY = (SELECT AVG(SALARY) FROM EMPLOYEE);

--EX. 가장 적은 급여를 받는 직원의 사번, 이름, 직급코드, 부서코드, 입사일 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = ( SELECT MIN(SALARY) FROM EMPLOYEE ) ;

--EX. 부서 별 급여의 합계 중 가장 큰 부서의 부서명, 급여 합계 조회
SELECT DEPT_TITLE, SUM(SALARY)
FROM DEPARTMENT JOIN EMPLOYEE ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) = (SELECT MAX (SUM(SALARY)) FROM EMPLOYEE GROUP BY DEPT_CODE);


--다중행 서브쿼리 : 서브쿼리의 조회 결과 행 개수가 여러 개일 때
--IN, NOT IN : 여러 개의 결과 값 중에서 1개라도 일치하는 값이 있다면/없다면
-- > ANY, < ANY : 여러 개의 결과 값 중에서 1개라도 큰 /작은 경우
--               = 가장 작은 값보다 큰 지, 가장 큰 값보다 작은지
-- >ALL, < ALL : 모든 값보다 크거나, 모든 값보다 작거나
--               = 가장 큰 값보다 큰지, 가장 작은 값보다 작은지
-- EX. 부서별 최고 급여를 받는 직원의 이름, 직급코드, 부서코드, 급여조회
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (SELECT MAX(SALARY) FROM EMPLOYEE GROUP BY DEPT_CODE);

--EX. 관리자와 일반 직원에 해당하는 사원 정보 추출 : 
--사번, 이름, 부서명, 직급, 구분(관리자/ 직원)
--관리자 : MANAGER_ID => EMP_NAME
--1) 관리자에 해당하는 사원 번호 조회
SELECT DISTINT MANAGER_ID --중복제거
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL; --NULL이 아닌 것 제외

--2) 관리자에 해당하는 정보 추출
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '관리자' 구분
FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON( DEPT_CODE = DEPT_ID)
    JOIN JOB USING (JOB_CODE)
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID
                 FROM EMPLOYEE
                 WHERE MANAGER_ID IS NOT NULL);
                
--3) 관리자에 해당하지 않는 사원 -> 관리자에 NOT붙이기
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '직원' 구분
FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON( DEPT_CODE = DEPT_ID)
    JOIN JOB USING (JOB_CODE)
WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID
                FROM EMPLOYEE
                WHERE MANAGER_ID IS NOT NULL);


--4) 2+3번 합치기
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '관리자' 구분
FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON( DEPT_CODE = DEPT_ID)
    JOIN JOB USING (JOB_CODE)
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID
                FROM EMPLOYEE
                WHERE MANAGER_ID IS NOT NULL);
UNION
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '직원' 구분
FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON( DEPT_CODE = DEPT_ID)
    JOIN JOB USING (JOB_CODE)
WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID
                FROM EMPLOYEE
                WHERE MANAGER_ID IS NOT NULL);

--위에꺼 짧게 만들기
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
        CASE WHEN EMP_ID IN (SELECT DISTINCT MANAGER_ID
                            FROM EMPLOYEE
                            WHERE MANAGER_ID IS NOT NULL) THEN '관리자'
                                                          ELSE '직원'
        END 구분                                                 
FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
    JOIN JOB USING (JOB_CODE);

--EX. 대리 직급의 직원들 중에서 과장 직급의 최소 급여보다 많이 받는 직원의 사번, 이름, 직급, 급여 조회
--1)과장 직급의 최소 급여
SELECT MIN(SALARY)
FROM EMPLOYEE
WHERE JOB_CODE = '과장';


--2)과장 최소 급여보다 많이 받는 대리 직급 직원들 정보 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT MIN(SALARY)
                FROM EMPLOYEE
                WHERE JOB_CODE = '과장')
GROUP BY JOB_CODE; 
HAVING JOB_CODE = '대리' 

--쌤 답안
SELECT EMP_ID, EMP_NAME,JOB_NAME, SALARY
FROM EMPLOYEE JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리'
    AND SALARY > (SELECT MIN(SALARY) FROM EMPLOYEE 
                JOIN JOB USING (JOB_NAME)
                WHERE JOB_NAME = '과장');

--ANY이용해서 바꿔보기
SELECT EMP_ID, EMP_NAME,JOB_NAME, SALARY
FROM EMPLOYEE JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리'
    AND SALARY > ANY (SELECT SALARY --급여 중 가장 작은것 보다 크기만 하면 돼 라는 뜻이니까 MIN삭제 가능
                      FROM EMPLOYEE 
                      JOIN JOB USING (JOB_NAME)
                      WHERE JOB_NAME = '과장');
                      
--<ALL> 쓰기
--EX. 차장 직급의 급여의 가장 큰 값보다 많이 받는 과장 직급의 사번, 이름, 직급, 급여조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
     JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '과장' 
    AND SALARY > ALL (SELECT SALARY  --이중에서 제일 큰거보다 크면 돼
                      FROM EMPLOYEE 
                      JOIN JOB USING (JOB_CODE)
                      WHERE JOB_NAME = '차장');




--다중열 서브쿼리 : 서브쿼리의 SELECT절에 나열된 항목 수가 여러개일때
--EX.퇴사한 여직원과 같은 부서, 같은 직급에 해당하는 사원의 이름, 직급 코드, 부서코드 입사일 조회하기
--다중열 안 쓰고 풀면 (단일행을 여러 개 써서)
SELECT EMP_NAME, DEPT_CODE,JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE 
                   FROM EMPLOYEE
                   WHERE SUBSTR(EMP_NO, INSTR(EMP_NO,'-')+1,1) =2
                    AND ENT_YN = 'Y')
    AND JOB_CODE = (SELECT JOB_CODE
                     FROM EMPLOYEE
                     WHERE SUBSTR(EMP_NO, INSTR(EMP_NO, '-')+1,1 ) = 2
                      AND ENT_YN = 'Y')

    AND EMP_NAME !=  (SELECT EMP_NAME
                      FROM EMPLOYEE
                      WHERE SUBSTR(EMP_NO, INSTR(EMP_NO, '-')+1,1 ) = 2
                        AND ENT_YN = 'Y');
                        
--다중열로 바꾸기
SELECT EMP_NAME, DEPT_CODE,JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE( DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE , JOB_CODE
                               FROM EMPLOYEE
                               WHERE SUBSTR(EMP_NO, INSTR(EMP_NO,'-')+1,1) =2
                                      AND ENT_YN = 'Y')

    AND EMP_NAME != (SELECT EMP_NAME
                      FROM EMPLOYEE
                      WHERE SUBSTR(EMP_NO, INSTR(EMP_NO, '-')+1,1 ) = 2
                            AND ENT_YN = 'Y');
                        
                    
                        
--다중행 다중열 서브쿼리
--EX.자기 직급의 평균 급여를 받고 있는 직원의 사번, 이름, 직급코드 , 급여조회
--단, 급여 평균은 십만원 단위로 계산 : TRUNC(컬럼명, -5)
--1)직급 별 평균 급여
SELECT JOB_CODE, AVG(SALARY), TRUNC(AVG(SALARY), -5)
FROM EMPLOYEE
GROUP BY JOB_CODE;

--2)자기 직급의 평균 급여를 받는 사원
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, TRUNC(AVG(SALARY, -5)
                             FROM EMPLOYEE
                             GROUP BY JOB_CODE);
--CF !! SUBQUERY는 SELECT, FROM, WHERE, HAVING에 들어감

--FROM절에 서브쿼리 사용 : 인라인 뷰(INLINE-VIEW)
--EX. 전 직원 중 급여가 높은 상위 5명의 이름, 급여, 순위 (숫자가 붙음)
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE 
ORDER BY SALARY DESC; --선동일,송종기, 정중하, 대북혼, 노옹철

SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5
ORDER BY SALARY DESC; --선동일, 송종기 ,노옹철, 유재식, 송은희
 
--뽑은 결과가 다름
/* 이유 : 실행된 순서때문! 두번째꺼는
WEHRE이 먼저 실행되서 먼저 5명을 뽑은 뒤 -> 정리
첫번째꺼 : WHERE 이 없으므로  내림차순을 실행 
해결방법 : INLINE-VIEW
5.SELECT
1.FROM
2 WHERE
3 GROUP BY
4 HAVING
6 ORDER BY
*/

--해결방법 : INLINE-VIEW (판 깔기)
SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT EMP_NAME, SALARY  --여기서 먼저 준비한게 이거 뿐이라  위 SELECT에 DEPT_CODE추가해도 안 나옴.
      FROM EMPLOYEE 
      ORDER BY SALARY DESC)
WHERE ROWNUM <= 5;

--FROM 내 인라인 뷰에서 컬럼 별칭으로 정하면
--위쪽 SELECT에도 별칭으로 적어야 나옴 ! 내가 FROM에서 준비한 만큼 SELECT할 수 있음

--인라인뷰 연습문제
--급여 평균 3위 안에 드는 부서의 부서코드와 부서명, 평균급여 조회
SELECT DEPT_CODE, DEPT_TITLE, ROWNUM, CEIL(AVG(SALARY))
FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE ROWNUM >=3 
GROUP BY DEPT_CODE 
ORDER BY SALARY DESC;

SELECT DEPT_CODE, DEPT_TITLE, 평균급여
FROM (SELECT DEPT_CODE, DEPT_TITLE,AVG(SALARY)평균급여
      FROM EMPLOYEE
      LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
      GROUP BY DEPT_CODE, DEPT_TITLE
      ORDER BY AVG(SALARY)DESC)

WHERE ROWNUM <=3; 

--순위 메겨주는 애들 :RANK()OVER / DENSE_RANK() OVER
--(1)같은 값 있으면 개수만큼 뛰고 다음 순위 메겨주기
SELECT RANK() OVER(ORDER BY SALARY DESC)"RANK",
    EMP_NAME, SALARY
FROM EMOLOYEE;
    
    
--(2)겹치는 값 잇어도 안 뛰어넘고 다음 숫자로 메겨줌 19,19 ,20일케
SELECT DENSE_RANK() OVER (ORDER BY SALARY DESC) "DENSE",
    EMP_NAME, SALARY
FROM EMPLOYEE;

--(3) :합친버전
SELECT DENSE_RANK() OVER (ORDER BY SALARY DESC) "RANK",
    EMP_NAME, SALARY
    RANK() OVER(ORDER BY SALARY DESC) "RANK"
    
FROM EMPLOYEE;

--WITH : 서브쿼리에 이름을 붙여서 사용시 이름을 쓰게함
--아래와 같은 SELECT가 있다면
SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY DESC);

--FROM에 있는 서브쿼리를 WITH 이름 AS 서브쿼리 로 지정 후
--그 아래에 SELECT ~ FROM 아까 쓴 이름대입.
WITH DESC_SALARY AS (SELECT EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY DESC)
SELECT ROWNUM, EMP_NAME, SALARY
FROM DESC_SALARY;

