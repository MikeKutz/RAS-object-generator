create user tePLSQL$SYS identified by Change0nInstall
default tablespace data
quota 50M ON DATA
ACCOUNT UNLOCK;

grant create session,
    create table,
    create view,
    create sequence,
    create procedure,
    create public synonym,
    create role
to tePLSQL$SYS;