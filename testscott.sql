--select * from emp where ename like 'JAM%';
--select * from emp where substr(ename,1,3)='JAM';
--select ename,substr(ename,3) from emp where deptno=10;
--select substr('XXYY',-1) from dual;
--SELECT ename,substr(ename, (length(ename)-3+1)) FROM emp;
--
--select nvl(1,0) ,nvl(null,1110) from dual;
--select nvl2(sal,1,2),nvl2(1,2,3) from dual;

--SELECT * FROM emp;

--select decode(1,1,'��',2,'��') from dual;

--select ename,job,sal, 
--nvl
--(
--decode(
-- job,
--'CLERK','ҵ��Ա',
--'SALESMAN','������Ա',
--'MANAGER','����',
--
--'PRESIDENT','�ܲ�'
--),'��') ���Ĺ����� 
--from emp;

-- ����ѯ

select * from emp,dept;
select e.*,  decode(sg.grade,1,'A',2,'B',3,'C',4,'D',5,'E') ���ʵȼ� from emp e, salgrade sg where e.sal between sg.losal and  sg.hisal; 

select e.ename, e.job,e.sal, d.dname,sg.grade from emp e,dept d,salgrade sg where e.deptno=d.deptno and e.sal between sg.losal and sg.hisal;

--insert into emp values (9299,'��ү','coder','7369',sysdate,800,100,null);

select * from emp left join dept on emp.deptno = dept.deptno;

select * from emp e ,dept d where e.deptno=d.deptno(+);

select e1.empno, e1.ename, e1.mgr,e2.ename from emp e1, emp e2 where e1.mgr = e2.empno(+);

select * from emp full outer join dept on emp.deptno=dept.deptno;

select * from emp where empno in (7369,7499);

select deptno ���ű��,count(*) �������� from emp group by deptno order by deptno;

select job,max(sal) ��߹���,min(sal) ��͹��� from emp group by job;

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

update testunion set (deptno,dname,loc)=(select * from mydept where deptno=10);-- ����ģ���Ϊ�Ƕ��н���������Ϊ���о�����ȷ��

-- ʹ��rownum��ҳ select * from (select rownum rnum, table1.* from table1 where rownum<=(currentpage)*pagsize) temp where temp.rnum>(currentpage-1)*pagesize ;
-- ���ʣ�������Ǵ�2������������ҵ�1.9��֮���ʮ����¼���ǲ���oracle�Ȳ��1.9��+10����¼��Ȼ����ɸѡ��Ҫ���10���������������������ô�ڴ�����ص�ס������ǰ1.9�������ݲ���һ���Ӳ������ֻ���α��Զ����ҵ���1.9�������ݺ����10����
select * from (select rownum rn, mydept.* from mydept where rownum<=3*5) temp where temp.rn>(3-1)*5;

-- oracle 12c��ʼʹ��fetch��ҳ select * from table offset (currentpage-1)*pagesize rows fetch net pagesize row only;
select rownum, a.* from myemp a offset 3 rows fetch next 3 row only;
select rownum, myemp.* from myemp offset (3-1)*3 rows fetch next 3 row only;
























