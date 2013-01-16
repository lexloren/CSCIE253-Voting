-- ******************************************************
-- llorenfinal.sql
--
-- Loader for L. Loren final DB
--
-- Description:	This script contains the DDL to load
--              the tables of the VOTING database. Final
--				project for CSCI E-253.
--
-- Author:  Lisa Loren
--
-- Modified:   November 20, 2012
--
--Changes from proposal:
--
--Adding a reference table for votecast
--votecast should not be part of tbvote's primary key
--Adding a reference table for electionstatus
--Altered tbvoter table to conform with ColdFusion cflogin standards.
--Allowed more text for question descriptions.
--
-- ******************************************************

-- ******************************************************
--    SPOOL SESSION
-- ******************************************************

spool llorenfinal.lst


-- ******************************************************
--    DROP TABLES
-- Note:  Issue the appropiate commands to drop tables
-- ******************************************************

DROP table tbvote;
DROP table tbvoteassign;
DROP table tbquestion;
DROP table tbvoteref;
DROP table tbelection;
DROP table tbelectstatref;
DROP table tbvoter;

-- ******************************************************
--    DROP SEQUENCES
-- Note:  Issue the appropiate commands to drop sequences
-- ******************************************************

DROP sequence seqquestionid;
DROP sequence seqelectionid;
DROP sequence seqvoterid;

-- ******************************************************
--    CREATE TABLES
-- ******************************************************

CREATE table tbvoter (
		voterid				varchar2(4)				not null
			constraint pk_tbvoter primary key,
		UserID				varchar2(64)			not null,
		Password			varchar2(40)			not null
			constraint passlength check (length(password) > 6),
		Roles				char(5)					null	
);

CREATE table tbelectstatref (
		electionsymbol		char(1)					not null
			constraint pk_tbelectstatref primary key,
		electionstatus		varchar2(8)				not null
);

CREATE table tbelection (
		electionid			varchar2(4)				not null
			constraint pk_tbelection primary key,
		electionstatus		char(1)					not null
			constraint fk_electionstatus references tbelectstatref (electionsymbol),
		electionname		varchar2(255)			null
);

CREATE table tbvoteassign (
		voterid				varchar2(4)				not null
			constraint fk_voterid_assign references tbvoter (voterid),
		electionid			varchar2(4)				not null
			constraint fk_electionid_assign references tbelection (electionid),
			constraint pk_tbvoteassign primary key (voterid, electionid)
);

CREATE table tbquestion (
		questionid			varchar2(4)				not null
			constraint pk_tbquestion primary key,
		electionid			varchar2(4)				not null
			constraint fk_electionid_q references tbelection (electionid),
		questiontext		varchar2(255)			null
);

CREATE table tbvoteref (
		votesymbol			char(1)					not null
			constraint pk_tbvoteref primary key,
		votetext			varchar2(12)			not null
);

CREATE table tbvote (
		voterid				varchar2(4)				not null
			constraint fk_voterid_vote references tbvoter (voterid),
		questionid			varchar2(4)				not null
			constraint fk_questionid_vote references tbquestion (questionid),
		votecast			char(1)					not null
			constraint fk_votecast_vote references tbvoteref (votesymbol),
			constraint pk_tbvote primary key (voterid, questionid)
);


-- ******************************************************
--    CREATE SEQUENCES AND SEQUENCE TRIGGERS
-- ******************************************************

-- Sequence for voterid:
CREATE sequence seqvoterid
	increment by 1
	start with 1;

--Trigger for seqvoterid, insertion of random starting password:
CREATE or REPLACE trigger TR_voter
	before insert on tbvoter
	for each row
	begin
		SELECT seqvoterid.nextval
		into :new.voterid
		FROM dual;
		SELECT DBMS_RANDOM.string('x',10)
		into :new.password
		FROM dual;
	end TR_voter;
 /
	
-- Sequence for electionid:	
CREATE sequence seqelectionid
	increment by 1
	start with 1;

--Trigger for seqelectionid:
CREATE or REPLACE trigger electionid_sequencer
	before insert on tbelection
	for each row
	begin
		SELECT seqelectionid.nextval
		into :new.electionid
		FROM dual;
	end electionid_sequencer;
 /

-- Sequence for questionid:	
CREATE sequence seqquestionid
	increment by 1
	start with 1;

--Trigger for seqquestionid:
CREATE or REPLACE trigger questionid_sequencer
	before insert on tbquestion
	for each row
	begin
		SELECT seqquestionid.nextval
		into :new.questionid
		FROM dual;
	end questionid_sequencer;
 /
 
-- ******************************************************
--    POPULATE TABLES
--
-- ****************************************************** 

--Populating reference tables:
INSERT INTO tbelectstatref values ('o', 'open');
INSERT INTO tbelectstatref values ('p', 'pending');
INSERT INTO tbelectstatref values ('c', 'closed');

INSERT INTO tbvoteref values ('y', 'yes');
INSERT INTO tbvoteref values ('n', 'no');
INSERT INTO tbvoteref values ('a', 'abstain');
INSERT INTO tbvoteref values ('x', 'not cast');

INSERT INTO tbvoter values ('1', 'admin', 'password', 'admin');
INSERT INTO tbvoter values ('2','demo@demo.com', 'password', 'voter');
INSERT INTO tbvoter values ('3','cindy@nomail.com', 'password', 'voter');
INSERT INTO tbvoter values ('4','alpha@company.com', 'password', 'voter');

INSERT INTO tbelection values ('1','c', 'Committee 2011');
INSERT INTO tbelection values ('2','p', 'Treasurer 2013');
INSERT INTO tbelection values ('3','o', 'Membership Questions');
 
INSERT INTO tbquestion values ('1', '1', 'Do you vote for Mary to occupy the empty fifth seat on the committee?');
INSERT INTO tbquestion values ('2', '2', 'Should June act as our treasurer in 2013?');
INSERT INTO tbquestion values ('3', '3', 'Should we have a holiday party this year?');
 
INSERT INTO tbvoteassign values ('2', '1');
INSERT INTO tbvoteassign values ('2', '2');
INSERT INTO tbvoteassign values ('2', '3');
INSERT INTO tbvoteassign values ('3', '2');
INSERT INTO tbvoteassign values ('3', '3');
INSERT INTO tbvoteassign values ('4', '1');
INSERT INTO tbvoteassign values ('4', '2');
INSERT INTO tbvoteassign values ('4', '3');

INSERT INTO tbvote values ('2', '1', 'y');
INSERT INTO tbvote values ('2', '3', 'y');
INSERT INTO tbvote values ('3', '3', 'y');
INSERT INTO tbvote values ('4', '1', 'a');
INSERT INTO tbvote values ('4', '3', 'n'); 

-- All passwords are currently random values. Set admin and demo passwords to something easy to remember.

UPDATE tbvoter SET Password='adminpass' WHERE voterid = 1;
UPDATE tbvoter SET Password='password' WHERE voterid = 2;
 
-- ******************************************************
--    VIEW TABLES
--
-- Note:  Issue the appropiate commands to show your data
-- ******************************************************



-- ******************************************************
--    QUALITY CONTROLS
--
-- Note:  Test the following constraints:
--        *) Entity integrity
--        *) Referential integrity
--        *) Column constraints
-- ******************************************************




-- ******************************************************
--    END SESSION
-- ******************************************************

spool off
