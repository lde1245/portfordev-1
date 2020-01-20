/* test 파일 */

DROP USER SCOTT CASCADE;
CREATE USER SCOTT IDENTIFIED BY TIGER;
GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE TRIGGER,
CREATE SYNONYM
TO SCOTT;

ALTER USER SCOTT
QUOTA UNLIMITED ON SYSTEM;
CONN SCOTT/TIGER


create table user_table(
	today date,
	user_name varchar2(20)
);

insert into user_table values(sysdate, '홍길동');

select to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'), user_name from user_table;

create table member_test3(
	num varchar2(20),
	name varchar2(30),
	email varchar2(20),
	tel varchar2(20),
	addr varchar2(30),
	today date
);
select * from dept;

select * from MEMBER;
select * from BOARD_COMMENT inner join MEMBER using(MEMBER_ID) where BOARD_ID = 1;
select * from board;
update (select * from MEMBER inner join BOARD using(MEMBER_ID) where board_id = 1) set MEMBER_ACT = MEMBER_ACT + 5;
insert into board values(3, '117421623799109543474', '0','1234', '제목','내용',1, 0, 0, 0, sysdate);
insert into board_comment values(board_comment_seq.nextval, 1, '117421623799109543474', '내용2', sysdate);
insert into BOARD_RECOMMEND values(BOARD_RECO_ID.nextval, '117421623799109543474', 1, sysdate);
select * from board;
select * from board_recommend;
select * from board_file;
select * from (select rownum rnum, b.* from 
					(select * from board inner join BOARD_COMMENT using(board_id) 
					 group by board_id where category = '0' order by BOARD_RE_REF desc,BOARD_RE_SEQ asc) 
					 b 
				) where rnum >= 0 and rnum <= 10; 

select *, count(select * from board_comment where board_id = 1) from board;
select * from board inner join (select board_id, count(*) BOARD_COMMENT from board inner join BOARD_COMMENT using(board_id) group by board_id) using(board_id);


select board_id, count(BOARD_RECO_ID) from board left outer join board_recommend using(board_id) group by board_id;
select board_id, count(BOARD_CO_ID) from board left outer join BOARD_COMMENT using(board_id) group by board_id;
select * from BOARD_FILE;
insert into BOARD_RECOMMEND values(BOARD_RECO_ID.NEXTVAL, '117421623799109543474', 4, SYSDATE);
select * from (select rownum rnum, b.* from (select * from (select * from board inner join MEMBER using(member_id)) inner join (select * from (select board_id, count(BOARD_RECO_ID) BOARD_RECO from board left outer join board_recommend using(board_id) group by board_id) inner join (select board_id, count(BOARD_CO_ID) BOARD_COMMENT from board left outer join BOARD_COMMENT using(board_id) group by board_id) using(board_id)) using(board_id) where BOARD_CATEGORY = '0' order by BOARD_RE_REF desc, BOARD_RE_SEQ asc) b) where rnum >=0 and rnum <= 10;
select * from (select board_id, count(BOARD_RECO_ID) from board left outer join board_recommend using(board_id) group by board_id) inner join (select board_id, count(BOARD_CO_ID) from board left outer join BOARD_COMMENT using(board_id) group by board_id) using(board_id)) using(board_id) where BOARD_CATEGORY = '0' order by BOARD_RE_REF desc, BOARD_RE_SEQ asc
select board_id, count(*) BOARD_RECO from board inner join BOARD_RECOMMEND using(board_id) group by board_id

/*회원 점수 정렬로 다섯명 뽑아오기*/
select * from (select rownum r, b.* from( select * from MEMBER where MEMBER_ID  like '%' ||  'user' || '%' order by MEMBER_ACT desc)b ) 
natural join 
where r < 6 order by r;

select * from MEMBER;
select * from profile;
/*회원 검색 결과+최근 피드백 활동일*/
select m.MEMBER_ID,MEMBER_PASSWORD,MEMBER_NAME,MEMBER_POWER ,MEMBER_POINT,MEMBER_ACT,REG_DATE from 
			(select rownum r, b.* from
				( select * from MEMBER where MEMBER_ID  like '%' ||  'user' || '%' order by MEMBER_ACT desc)b
			 )m left outer join (select MEMBER_ID ,nvl(MAX(REG_DATE),null) REG_DATE  from	PORT_FEEDBACK group by MEMBER_ID) p on p.MEMBER_ID=m.MEMBER_ID 
			 where r < 6 order by r asc ,REG_DATE DESC;
			 
/*게시판 검색 결과*/
select * from 
			(select rownum r, b.* from
				( select BOARD_SUBJECT,BOARD_CONTENT,BOARD_DATE from  BOARD where BOARD_SUBJECT  like '%' || '어' || '%' 
					or BOARD_CONTENT like '%' ||  '어' || '%' order by BOARD_DATE desc)b
			 )
			 where r < 6 order by r asc 			 
			 
select MEMBER_ID , MAX(REG_DATE)  from	PORT_FEEDBACK group by MEMBER_ID ;		 
select* from BOARD;
delete from BOARD;

select * from 
			(select rownum r, b.* from
				( select BOARD_SUBJECT, SUBSTR(BOARD_CONTENT,(instr(BOARD_CONTENT,'연어초밥',1,1)),LENGTH(BOARD_CONTENT)) BOARD_CONTENT,BOARD_DATE,MEMBER_ID from  BOARD where  (BOARD_SUBJECT  like '%' ||  '연어초밥' || '%' 
					or BOARD_CONTENT like '%' ||  '연어초밥' || '%' or MEMBER_ID like '%' || '연어초밥' || '%') and BOARD_CATEGORY = '0' order by BOARD_DATE desc)b
			 )
			 where r < 6 order by r asc 
select instr(BOARD_CONTENT,'연어초밥',1,1)-6 from BOARD;
			 
select * from emp where ename='SCOTT';
