-- SEQUENCE시퀀스 : 자동 번호 발생기
/*

CREATE SEQUENCE 시퀀스 이름
[INCREMENT BY 숫자] ->다음값에 대한 증가차. 생략하면 1이 DEFAULT
[START BY 숫자] ->처음 발생시킬 시작 값. 생략시 1이 디폴트
[MAXVALUE 숫자 | NOMAXVALUE] 발생시킬 최대 값 지정 (최대 10^27-1승까지)
[MINVALUE 숫자 | NOMINVALUE] 발생시킬 최소 값 지정, -10^27-1승
[CYCLE | NOCYCLE] 순환여부.CYCLE로 햇을 때 MAX를 넘으면 MIN으로 돌아감
[CACHE 바이트크기 | NOCACHE] 캐시메모리 기본값은 20바이트. 최소값은 2바이트 


*/

CREATE SEQUENCE SEQ_TEST
START WITH 300
INCREMENT BY 5
MAXVALUE 320
NOCYCLE 
NOCACHE;

select * from user_sequences; --사용자가 만든 시퀀스 확인
/*
시퀀스명.currval  :현재 생성된 시퀀스의 값(=마지막으로 호출된 nextval의 값을 저장해서 보여주는 임시값)
시퀀스명.nextval : 최초로 시퀀스 실행, 기존 시퀀스 값에서 증가치만큼 증가한 값

*/
select seq_test.currval from dual;
--가상 테이블에서 뽑아내기dual
--ORA-08002: 시퀀스 SEQ_TEST.CURRVAL은 이 세션에서는 정의 되어 있지 않습니다
select seq_test.nextval from dual; --먼저 실행해야 현재 값currval확인 가능

/*
        currval     nextval     last_number(user_sequences)
생성 시    x           x           300(1)
nextval  300(3)      300(2)       305(4)
nextval2  305(6)     305(5)       310(7)

<변경>
alter sequence 시퀀스명
[INCREMENT BY 숫자] 
[MAXVALUE 숫자 | NOMAXVALUE]
[MINVALUE 숫자 | NOMINVALUE] 
[CYCLE | NOCYCLE] 
[CACHE 바이트크기 | NOCACHE] 
**start with는 변경불가. drop 후 재생성해야한다.

*/

alter sequence seq_test
increment by 20
maxvalue 400
minvalue 200
cycle;

select * from user_sequences;
--활용처 : insert, create table default(11g버전은X)

ALTER TABLE emp DROP PRIMARY KEY;

alter table emp
add primary key(empno);

create table board(
    board_no number primary key,
    title varchar2(60) not null,
    content clob not null,
    writer number not null,
    count number default 0,
    create_date date default sysdate,
    update_date date default sysdate,
    status char(1) default 'Y' check(status in('Y','N')),
    is_notice char(1) default 'N' check(is_notice in('Y','N')),
    foreign key(writer) references emp(empno)
);
create sequence seq_board nocache;

create table reply(
    reply_no number primary key,
    content varchar2(3000) not null,
    writer number not null,
    create_date date default sysdate,
    update_date date default sysdate,
    ref_board number not null,
    status char(1) default 'Y' check(status in('Y','N')),
    foreign key(writer) references emp(empno),
    foreign key(ref_board) references board(board_no)
);
create sequence seq_reply nocache;

SELECT 
    b.board_no, 
    b.title, 
    b.content, 
    b.writer AS empno, 
    e.ename AS writer,
    b.count, 
    b.create_date, 
    b.update_date, 
    b.is_notice,
    b.status
FROM board b
JOIN emp e ON b.writer = e.empno
WHERE b.status = 'Y'
ORDER BY b.board_no DESC;


--더미데이터 만들기 : 오라클에서 반복문 만들기 => procedural language extension to SQL)
--오라클에 내장되어 있는 절차적 언어 (변수정의, 조건처리, 반복처리 등을 지원함)
/*

    선언부 : 변수/상수 선언(declare) 
    실행부 : 로직 기술 (제어문, 반복문 등)(begin)
    예외처리부 : 예외 발생 시 해결하기 위한 문장기술(exception)

*/
BEGIN
    FOR i IN 1..37 LOOP
        INSERT INTO board (
            board_no, title, content, writer, count, create_date, update_date, status, is_notice
        ) VALUES (
            seq_board.NEXTVAL,
            '제목 ' || i,                          -- title (varchar2)
            '내용 ' || TO_CHAR(i + 100),          -- content (clob이지만 간단 텍스트 가능)
            7839,                                 -- writer (empno)
            DEFAULT,                              -- count (default 0)
            DEFAULT,                              -- create_date (default sysdate)
            DEFAULT,                              -- update_date (default sysdate)
            DEFAULT,                              -- status (default 'Y')
            DEFAULT                               -- is_notice (default 'N')
        );
    END LOOP;
END;
/
COMMIT;


SELECT * FROM board;

CREATE SEQUENCE seq_board NOCACHE;

select * from board;

UPDATE board SET status='Y' WHERE status IS NULL OR status != 'Y';
















