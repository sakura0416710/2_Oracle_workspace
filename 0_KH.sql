--데이터 저장'하기' : TABLE필요. 행과 컬럼으로 구성되는 가장 기본적인 데이터베이스의 객체.
            --  데이터베이스 내에서 모든 데이터는 테이블을 통해 저장됨.
CREATE TABLE TEST(
    T_NO NUMBER,    --정수 자료형
    T_NAME VARCHAR2(20) --문자열 자료형. 모든 문자와 문자열은 ''로 감싼다.
    );
    
INSERT INTO TEST1 VALUES(0, 'TEST'); --데이터를 넣는 명령어
DROP TABLE TEST;