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
SELECT *
FROM emp,
  dept;
SELECT e.*,
  DECODE(sg.grade,1,'A',2,'B',3,'C',4,'D',5,'E') ���ʵȼ�
FROM emp e,
  salgrade sg
WHERE e.sal BETWEEN sg.losal AND sg.hisal;
SELECT e.ename,
  e.job,
  e.sal,
  d.dname,
  sg.grade
FROM emp e,
  dept d,
  salgrade sg
WHERE e.deptno=d.deptno
AND e.sal BETWEEN sg.losal AND sg.hisal;
--insert into emp values (9299,'��ү','coder','7369',sysdate,800,100,null);
SELECT *
FROM emp
LEFT JOIN dept
ON emp.deptno = dept.deptno;
SELECT * FROM emp e ,dept d WHERE e.deptno=d.deptno(+);
SELECT e1.empno,
  e1.ename,
  e1.mgr,
  e2.ename
FROM emp e1,
  emp e2
WHERE e1.mgr = e2.empno(+);
SELECT * FROM emp FULL OUTER JOIN dept ON emp.deptno=dept.deptno;
SELECT * FROM emp WHERE empno IN (7369,7499);
SELECT deptno ���ű��,COUNT(*) �������� FROM emp GROUP BY deptno ORDER BY deptno;
SELECT job,MAX(sal) ��߹���,MIN(sal) ��͹��� FROM emp GROUP BY job;
SELECT MAX((ROUND(AVG(sal),2))) g FROM emp GROUP BY deptno ;
SELECT d.dname,
  COUNT(e.deptno),
  ROUND(AVG(sal)),
  ROUND(AVG((sysdate-e.hiredate)/365))
FROM emp e
LEFT JOIN dept d
ON e.deptno=d.deptno
GROUP BY d.dname;
SELECT s.grade ,
  COUNT(s.grade),
  ROUND(AVG(e.sal))
FROM salgrade s ,
  emp e
WHERE e.sal BETWEEN s.losal AND s.hisal
GROUP BY s.grade;
CREATE TABLE myempbak AS
SELECT * FROM emp;
CREATE TABLE mydept AS
SELECT * FROM dept;
INSERT INTO mydept
  (deptno,dname,loc
  )
SELECT * FROM dept;
SELECT rowid, mydept.* FROM mydept;
CREATE TABLE mydeptgroup AS
SELECT deptno,dname,loc FROM mydept GROUP BY deptno,dname,loc;
INSERT ALL
INTO mydept VALUES
  (
    20,
    'ACCOUNTING2',
    'NEW YORK'
  )
INTO mydept VALUES
  (
    20,
    'ACCOUNTING',
    'NEW YORK2'
  )
INTO mydept VALUES
  (
    20,
    'ACCOUNTING3',
    'NEW YORK'
  )
INTO mydept VALUES
  (
    20,
    'ACCOUNTING',
    'NEW YORK6'
  )
SELECT 1 FROM dual;
SELECT * FROM mydept
UNION
SELECT * FROM mydept;
SELECT deptno,dname,loc, COUNT(deptno) FROM mydept GROUP BY deptno,dname,loc;
CREATE TABLE testunion AS
SELECT * FROM mydept;
SELECT * FROM testunion;
UPDATE testunion
SET
  (
    deptno,
    dname,
    loc
  )
  =
  (SELECT * FROM mydept WHERE deptno=10
  );-- ����ģ���Ϊ�Ƕ��н���������Ϊ���о�����ȷ��
-- ʹ��rownum��ҳ select * from (select rownum rnum, table1.* from table1 where rownum<=(currentpage)*pagsize) temp where temp.rnum>(currentpage-1)*pagesize ;
-- ���ʣ�������Ǵ�2������������ҵ�1.9��֮���ʮ����¼���ǲ���oracle�Ȳ��1.9��+10����¼��Ȼ����ɸѡ��Ҫ���10���������������������ô�ڴ�����ص�ס������ǰ1.9�������ݲ���һ���Ӳ������ֻ���α��Զ����ҵ���1.9�������ݺ����10����
SELECT *
FROM
  (SELECT rownum rn, mydept.* FROM mydept WHERE rownum<=3*5
  ) temp
WHERE temp.rn>(3-1)*5;
-- oracle 12c��ʼʹ��fetch��ҳ select * from table offset (currentpage-1)*pagesize rows fetch net pagesize row only;ע�⣬�����һ���Ǵ�0��ʼ
SELECT rownum,
  a.*
FROM myemp a offset 3 rows
FETCH NEXT 3 rows only;
-- ����ҳ����
SELECT rownum, myemp.* FROM myemp offset (3-1)*3 rows
FETCH NEXT 3 rows only;
-- rowҲ����
SELECT rownum, myemp.* FROM myemp offset (3-1)*3 rows
FETCH NEXT 3 row only;
SELECT rownum, myemp.* FROM myemp offset (2-1)*3 rows
FETCH NEXT 3 rows only;
-- ���Բminus���ڷ�ҳ��������޷�������
(
SELECT rownum,
  myemp.*
FROM myemp
WHERE rownum <=(3)*3
)
INTERSECT
  (SELECT rownum,myemp.* FROM myemp WHERE rownum>(3-1)*3
  );
---------------------------------------- start  PL/SQL���----------------------------------
-- �򿪷��������ʾ
SET serveroutput ON;
-- 1��ʾ��
BEGIN
  dbms_output.put_line('helloworld');
END;
/
-- 2,����ʹ��
DECLARE
  v_name VARCHAR2(20);
BEGIN
  v_name := 'ΤС��';
  dbms_output.put_line('��������ǣ�'||v_name);
END;
/
-- 3,����������� ����������û���Ų����û�����
DECLARE
  v_empno NUMBER(10);
  v_ename VARCHAR2(20);
BEGIN
  v_empno := &eno;
  SELECT ename INTO v_ename FROM emp WHERE empno=v_empno;
  dbms_output.put_line('��� '||v_empno||' �Ĺ�Ա������Ϊ '||v_ename);
EXCEPTION
  dbms_output.put_line('û�ҵ�����');
END;
/
