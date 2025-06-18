-- JOIN : 하나 이상의 테이블에서 데이터를 조회하기 위해 사용하며 수행 결과는 RESULT SET 하나를 반환.
--**같은 데이터로 연결**할 수 있다. (FOREIGN KEY이런거랑 전혀 상관없음)
-- 사번, 사원명 , 부서코드, 부서 명 조회
--<EMPLOYEE>-----------
--              -----<DEPARTMENT>--

--<1> 내부조인, 등가조인, 이너조인 : 컬럼의 값이 일치하는 행들만 조회
--일치하지 않으면 조인X
--조인 : 오라클 전용구문, ANSI구문 (둘다 중요)
SELECT EMP_NAME, EMP_ID, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_ID = DEPT_CODE;  --오라클 전용 구문
--DEPT_CODE가 NULL인 애들은 제외한 결과.(21개나옴)


--<연습문제>
--사번, 사원명, 직급코드, 직급 명 조회
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE; 

--테이블 별칭 정하기
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE; 

--<ANSI구문>
--사번, 사원명 , 부서코드, 부서 명 조회
SELECT EMP_ID, EMP_NAME, DEPT_ID, DEPT_TITLE
FROM EMPLOYEE
     JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

--사번, 사원명, 직급코드, 직급 명 조회
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM  EMPLOYEE
      JOIN JOB USING (JOB_CODE); --컬럼명이 같을 때는 USING(같은 이름의 컬럼)
      
--부서 명(DEPARTMENT : DEPT_TITLE) 과 해당 부서의 지역 명(LOCATION : LOCAL NAME) 조회
--오라클 전용구문버전
SELECT DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

--ANSI구문 버전
SELECT DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT
     JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);
     
     
     
--외부조인 (OUTER JOIN) : 컬럼의 타입이 일치하지 않아도 조인에 포함

--<1> LEFT(OUTER) JOIN
--사원 명, 부서명 조회 (ANSI),기준 테이블을 정하면 그 테이블 기준으로 값이 나옴.
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE 
    LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
    --하동운   (NULL) 얘네둘은 DEPT_TITLE없어도 EMPLOYEE(기준 테이블)기준으로 나오게 댐
    --이오리   (NULL)
--<오라클 구문> : 기준이 아닌 테이블의 조건식 컬럼에 (+) 붙여주기
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);



--<2> RIGHT(OUTER) JOIN
SELECT EMP_NAME, DEPT_TITLE 
FROM EMPLOYEE 
    RIGHT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
--   NULL 마케팅부
--   NULL 국내영업부
--   NULL 해외영업3부   

--오라클 전용구문 버전 무조건 (+)만 붙일 수 있음.
SELECT EMP_NAME, DEPT_TITLE 
FROM EMPLOYEE, DEPARTMENT  
WHERE (DEPT_CODE(+) = DEPT_ID);
    
    
    
--<3> FULL (OUTER) JOIN : 오라클 버전 불가
SELECT EMP_NAME, DEPT_TITLE 
FROM EMPLOYEE 
    FULL JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

--<4> 자체조인 (SELF JOIN) - 자기가 자기를 조인하는 것
-- 사번, 사원이름, 부서 코드, 관리자 사번, 관리자 이름
--오라클 버전
SELECT E1.EMP_ID, E1.EMP_NAME, E1.DEPT_CODE, E1.MANAGER_ID, E2.EMP_NAME "관리자 이름"
FROM EMPLOYEE E1, EMPLOYEE E2 --별칭으로 시점정해주고 SELECT의 컬럼들의 시점 정해주기
WHERE (E1.MANAGER_ID = E2.EMP_ID);
--일반사원이 갖는 매니저 아이디랑 관리자의 사번이 같아야 되니까



--ANSI 
SELECT E.EMP_ID, E.EMO_NAME, E.DEPT_CODE, E.MANAGER_ID, E2.EMP_NAME --일반사원의 매니저 아이디를 보고 관리자 이름을 찾아야 되니까
FROM EMPLOYEE E
     JOIN EMPLOYEE E2 ON (E.MANAGER_ID = E2.EMP_ID);


--<5> 다중조인
--사번, 사원 이름, 부서 코드, 부서 명, 해당 부서의 지역 명
--<오라클 전용>
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE (DEPT_CODE = DEPT_ID)AND (LOCATION_ID = LOCAL_CODE);

--<ANSI>
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE 
     JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID) --, 이거 안해도됨
     JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);
--다중조인에서 ANSI : 순서 유의하기. 1->2 -> 3

--직급이 대리이면서 아시아지역에 근무하는 직원의 사번, 이름, 직급(EP-JOB_CODE), 직급 명(JOB - JOBNAME), 
--                                  부서 명(DEPARTMENT - DEPT_TITLE), 근무 지역명(LOCATION - LOCAL NAME), 급여 조회
--<오라클>
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME, DEPT_TITLE, LOCAL_NAME, SALARY
FROM EMPLOYEE E, JOB J, DEPARTMENT D, LOCATION L
WHERE (E.JOB_CODE = J.JOB_CODE) AND (E.DEPT_CODE = D.DEPT_ID) 
        AND (LOCATION_ID = LOCAL_CODE)
        AND JOB_NAME = '대리'
        AND LOCAL_NAME LIKE 'ASIA%';
        
--E의 JOB_CODE와 J의JOB_CODE가 겹치니까 그거 보고 JOB_NAME을 뽑음
--DEPT_CODE와 DEPT_ID = 부서코드로 겹치므로 그거보고 D의 DEPT TITLE을 뽑음
--D의 LOCATION ID지역코드는 L의 LOCAL CODE지약코드와 겹치므로 같다고 해주면 L의 LOCAL_NAME을 뽑음


--<ANSI>
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME, DEPT_TITLE,LOCAL_NAME, SALARY
FROM EMPLOYEE E JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
                JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
                JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE  JOB_NAME = '대리' AND LOCAL_NAME LIKE 'ASIA%';














