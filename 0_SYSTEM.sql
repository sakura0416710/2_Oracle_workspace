--select sysdate from dual; (현재 날짜 가져오기)

CREATE USER c##KH IDENTIFIED BY KH; --사용자계정 생성. (user 계정명 identified by 비번)
DROP USER C##KH; --Literal값, 비번은 대소문자를 가림

ALTER SESSION SET"_ORACLE_SCRIPT" = TRUE; --C##안붙여도 계정생성 가능하게 해주는 명령어
CREATE USER KH IDENTIFIED BY KH; --순차대로 실행시켜두기 (쓰기만 하면 실행안됨)

--관리자 계정 : 데이터베이스의 생성, 관리를 담당하는 슈퍼유저 계정. 
                --오브젝터 생성, 변경, 삭제 등의 작업이 가능하면
                --데이터 베이스 대한 모든 권한과 책임을 가지는 계정
                
--사용자 계정 : 데이터베이스에 대하여 질의, 갱신 등의 작업을 수행하는 계정
--          일반계정은 보안을 위해 업무에 필요한 최소한의 권한만 가지는 것이 원칙.

GRANT CONNECT, RESOURCE TO KH; --권한을 부여하고 데이터 저장이 '가능'하도록 하는 명령어