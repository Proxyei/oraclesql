--select * from emp where ename like 'JAM%';
--select * from emp where substr(ename,1,3)='JAM';
--select ename,substr(ename,3) from emp where deptno=10;
--select substr('XXYY',-1) from dual;
--SELECT ename,substr(ename, (length(ename)-3+1)) FROM emp;
--
--select nvl(1,0) ,nvl(null,1110) from dual;
--select nvl2(sal,1,2),nvl2(1,2,3) from dual;

--SELECT * FROM emp;

--select decode(1,1,'丁',2,'美') from dual;

--select ename,job,sal, 
--nvl
--(
--decode(
-- job,
--'CLERK','业务员',
--'SALESMAN','销售人员',
--'MANAGER','经理',
--
--'PRESIDENT','总裁'
--),'空') 中文工作名 
--from emp;

-- 多表查询

select * from emp,dept;
select e.*,  decode(sg.grade,1,'A',2,'B',3,'C',4,'D',5,'E') 工资等级 from emp e, salgrade sg where e.sal between sg.losal and  sg.hisal; 

select e.ename, e.job,e.sal, d.dname,sg.grade from emp e,dept d,salgrade sg where e.deptno=d.deptno and e.sal between sg.losal and sg.hisal;

--insert into emp values (9299,'爵爷','coder','7369',sysdate,800,100,null);

select * from emp left join dept on emp.deptno = dept.deptno;

select * from emp e ,dept d where e.deptno=d.deptno(+);

select e1.empno, e1.ename, e1.mgr,e2.ename from emp e1, emp e2 where e1.mgr = e2.empno(+);

select * from emp full outer join dept on emp.deptno=dept.deptno;

select * from emp where empno in (7369,7499);

select deptno 部门编号,count(*) 部门人数 from emp group by deptno order by deptno;

select job,max(sal) 最高工资,min(sal) 最低工资 from emp group by job;

select max((round(avg(sal),2))) g from emp group by deptno ;

select d.dname,count(e.deptno),round(avg(sal)),round(avg((sysdate-e.hiredate)/365)) from emp e left join dept d on e.deptno=d.deptno group by d.dname; 

select s.grade ,count(s.grade),round(avg(e.sal)) from salgrade s , emp e where e.sal between s.losal and s.hisal group by s.grade;

create table myempbak as select * from emp;

create table mydept as select * from dept;
insert into mydept(deptno,dname,loc) select * from dept;

select rowid, mydept.* from mydept;

create table mydeptgroup as select deptno,dname,loc from mydept group by deptno,dname,loc;
insert all into mydept values(20,'ACCOUNTING2','NEW YORK') into mydept values(20,'ACCOUNTING','NEW YORK2') into mydept values(20,'ACCOUNTING3','NEW YORK') into mydept values(20,'ACCOUNTING','NEW YORK6') select 1 from dual;

select * from mydept union select * from mydept;

select deptno,dname,loc, count(deptno) from mydept group by deptno,dname,loc;

create table testunion as select * from mydept;

select * from testunion;

update testunion set (deptno,dname,loc)=(select * from mydept where deptno=10);-- 错误的，因为是多行结果，如果改为单行就是正确的

-- 使用rownum分页 select * from (select rownum rnum, table1.* from table1 where rownum<=(currentpage)*pagsize) temp where temp.rnum>(currentpage-1)*pagesize ;
-- 疑问：如果我是从2亿数据里面查找第1.9亿之后的十条记录，是不是oracle先查出1.9亿+10条记录，然后再筛选出要求的10条出来，如果是这样，那么内存如何守得住？还是前1.9亿条数据不会一下子查出来，只是游标自动查找到第1.9亿条数据后面的10条？
select * from (select rownum rn, mydept.* from mydept where rownum<=3*5) temp where temp.rn>(3-1)*5;

-- oracle 12c开始使用fetch分页 select * from table offset (currentpage-1)*pagesize rows fetch net pagesize row only;
select rownum, a.* from myemp a offset 3 rows fetch next 3 row only;
select rownum, myemp.* from myemp offset (3-1)*3 rows fetch next 3 row only;
























