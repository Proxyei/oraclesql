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
-- 4����������
SET serveroutput ON;
-- ����ĳ������
DECLARE
  v_ename emp.ename%TYPE;
  v_empno emp.empno%TYPE;
BEGIN
  v_empno:=&eno;
  SELECT ename INTO v_ename FROM emp WHERE empno = v_empno;
  -- �����ֵ��������д��select ename,deptno into v_ename,v_deptno from emp;
  dbms_output.put_line('���Ϊ��'||v_empno||' �Ĺ�Ա����Ϊ��'||v_ename);
END;
/
--- ����Ϊ������ ROWTYPE
DECLARE
  v_emp emp%ROWTYPE;
BEGIN
  SELECT * INTO v_emp FROM emp WHERE empno=7369;
  dbms_output.put_line(v_emp.empno||': '||v_emp.ename);
END;
/
-- ���̿���
SET serveroutput ON;
DECLARE
  v_count NUMBER(4);
BEGIN
  SELECT COUNT(empno) INTO v_count FROM emp;
  IF v_count > 10 THEN
    dbms_output.put_line('������̫��');
  END IF;
  IF 'java'='java' THEN
    dbms_output.put_line('helloworld');
  END IF;
END;
/
-- ѭ��
DECLARE
  v_num NUMBER;
BEGIN
  v_num := 10;
  LOOP
  --��Ϊ���˸��ֺ�;���˰���Ū����
    dbms_output.put_line(v_num);
    EXIT
  WHEN v_num <= 0;
    v_num  := v_num - 1;
  END LOOP;
END;
/

DECLARE 
  v_i NUMBER := 10;
BEGIN
  while(v_i>0) 
  
  loop
    dbms_output.put_line(v_i);
    v_i := v_i - 1;
  end loop;
END;
/

-- for ʹ��

DECLARE 
  v_i NUMBER ;
BEGIN
  FOR v_i IN 1 .. 3 
  loop
    dbms_output.put_line(' '||v_i);
  end loop;
END;
/

-- �쳣����
set serveroutput on;
-- 1 ����exception����

-- 1.1 ����������exception���� ʹ��others���񣬴�ʱoracle�������Ϊ1
DECLARE
  v_empno NUMBER;
  v_myexception exception; 
  
BEGIN
  v_empno := &eno;
  IF v_empno>=1 AND v_empno<=10000 THEN
    dbms_output.put_line('���������������');
    raise v_myexception;
  END IF;
exception
  WHEN others THEN
       dbms_output.put_line('��������');
       dbms_output.put_line('sqlcode: '||SQLCODE);
       dbms_output.put_line('sqlerrm '||SQLERRM);
END;
/

-- 1.2 �������Ķ�������Ч��oracle���������ϵ����
DECLARE
  v_empno NUMBER;
  v_myexception exception;
  PRAGMA exception_init(v_myexception,-20789);
BEGIN
  v_empno:=&eno;
  IF v_empno>=0 AND v_empno<=11110 THEN
    dbms_output.put_line('�����쳣�����');
    raise v_myexception;
  END IF;
  
exception
  when v_myexception then
    dbms_output.put_line('��������');
    dbms_output.put_line('sqlcode: '||sqlcode);
    dbms_output.put_line('sqlerrm: '||sqlerrm);
END;
/

DECLARE 
  v_data NUMBER;
  v_myexp exception;
  pragma exception_init (v_myexp, -20789);
BEGIN
  v_data := &inputData;
  IF v_data>0 AND v_data<100 THEN
    raise v_myexp;
  END IF;
  
exception
  WHEN v_myexp THEN
  dbms_output.put_line('�������');
  dbms_output.put_line('sqlcode'||sqlcode);
  dbms_output.put_line('sqlerrm'||sqlerrm);
END;
/


-- 2 ʹ�� raise_appliaction_error������̬���쳣 raise_application_error(����ţ�������Ϣ���Ƿ���ӵ�����ջ��);
DECLARE
  v_empno NUMBER;
  v_ename VARCHAR2(20);
  v_exception exception;
  pragma exception_init (v_exception, -20001);
BEGIN
  v_empno :=&inputData;
  SELECT ename INTO v_ename FROM emp WHERE empno=v_empno;
  IF v_ename='SMITH' THEN
    dbms_output.put_line('�����������');
    raise_application_error(-20001, '�ҵ��˴����Ա��');
  end if;
exception
  WHEN v_exception THEN
    dbms_output.put_line('����һ�����쳣');
    dbms_output.put_line('sqlcode'||sqlcode);
    dbms_output.put_line('sqlerrm'||sqlerrm);
END;
/



------------------end PL/SQL���------------




---------start ����----------------������α������м�¼-
-- type is record ����һ��j��¼���ͣ�����C�Ľṹ��
set serveroutput on;
DECLARE 
  TYPE empType Is record(
    empno emp.empno%type,
    ename emp.ename%TYPE,
    empjob emp.job%type
  );
  emprow empType;
  v_empno number;
BEGIN
  v_empno:=&eno;
  SELECT empno,ename,JOB INTO emprow FROM emp WHERE empno=v_empno;
  -- ����ֻ��emprow
  dbms_output.put_line(emprow.empno||emprow.ename||emprow.empjob);
  exception
    WHEN others THEN
      dbms_output.put_line('no datas');
END;
/


---2 Ƕ�����ͼ�¼����
DECLARE
  
BEGIN
END;
/


-- 3����
set serveroutput on;

-- �����±�

DECLARE 
  TYPE v_type IS TABLE OF VARCHAR(21) INDEX BY pls_integer;
  v1 v_type;
  
BEGIN
  v1(0) :='java';
  v1(11):='c';
  dbms_output.put_line(v1(0));
  dbms_output.put_line(v1(11));
END;
/

-- �ַ����±�
DECLARE 
  TYPE v_string IS TABLE OF VARCHAR2(30) INDEX BY VARCHAR2(20);
  v1 v_string;
BEGIN
  v1('a'):='hello';
  v1('b'):='world';
  dbms_output.put_line(v1('a'));
  dbms_output.put_line(v1('b'));
END;
/

-- ��¼����
DECLARE
  TYPE v_dept_type IS TABLE OF dept%rowtype INDEX BY pls_integer;
  v1 v_dept_type;
BEGIN
  v1(0).deptno:=22;
  v1(0).dname :='java';
  v1(0).loc:='hh';
  dbms_output.put_line(v1(0).deptno||v1(0).dname||v1(0).loc);
END;
/

select * from dept;

show ERROR;



/* start �α� */
set serveroutput on;
-- ��ѯ��emp����Ա������Ϣ
-- while
DECLARE 
  CURSOR cursor_emp IS SELECT * FROM emp;
  --�����
  v_emprow emp%rowtype;
BEGIN
-- �ж��α�״̬ ���α�
  IF cursor_emp%ISOPEN THEN
    NULL;
  ELSE
    open cursor_emp;
  END IF;
  fetch cursor_emp INTO v_emprow;
  while  cursor_emp%found loop
      dbms_output.put_line('row: '||cursor_emp%rowcount||' empno:'||v_emprow.empno||' ename:'||v_emprow.ename||' job:'||v_emprow.JOB||' sal:'||v_emprow.sal);
      fetch cursor_emp into v_emprow;-- ָ����һ����¼
    end loop;  
  IF cursor_emp%isopen THEN
    close cursor_emp;
  end if;
END;
/

-- ʹ��loop
DECLARE 
  CURSOR cursor_emp IS SELECT * FROM emp; --��ʾ�����α�
  v_emprow emp%rowtype; -- ȡ����
BEGIN
  -- ���α�
  IF cursor_emp%isopen THEN
    NULL;
  ELSE
    open cursor_emp;
  END IF;
  
  fetch cursor_emp INTO v_emprow;--�α�ָ���һ��
    loop
      dbms_output.put_line('row: '||cursor_emp%rowcount||' empno:'||v_emprow.empno||' ename:'||v_emprow.ename||' job:'||v_emprow.JOB||' sal:'||v_emprow.sal);
      exit WHEN cursor_emp%notfound;
        fetch cursor_emp INTO v_emprow;--�α�ָ����һ��
    end loop;
  
  close cursor_emp;
END;
/

-- for ��Ҫʹ��for��ϵͳ���Զ��򿪹ر�cursor
DECLARE
  CURSOR cursor_emp IS SELECT * FROM emp;  
BEGIN
  -- ����������������Ҳ������
  FOR v_emprow IN cursor_emp
    loop
      dbms_output.put_line('row: '||cursor_emp%rowcount||' empno:'||v_emprow.empno||' ename:'||v_emprow.ename||' job:'||v_emprow.JOB||' sal:'||v_emprow.sal);
    end loop;
END;
/
show error;

-- ���������α� ��ѯ������Ϊ10������Ա����Ϣ*/
DECLARE
   CURSOR cursor_emp (cs_deptno emp.deptno%TYPE) IS SELECT * FROM emp where deptno=cs_deptno;
   v_deptno emp.deptno%TYPE;
   v_ename emp.ename%type;
BEGIN
  FOR v_emprow IN cursor_emp(&deptno) 
    loop
       --dbms_output.put_line('����'||v_ename);
        dbms_output.put_line('row: '||cursor_emp%rowcount||' empno:'||v_emprow.empno||' ename:'||v_emprow.ename||' job:'||v_emprow.JOB||' sal:'||v_emprow.sal);
    end loop;
END;
/


/*�α� end*/


--------end--------


---������start-------


--dml������
--��������
CREATE OR REPLACE TRIGGER trigger_myemp
BEFORE INSERT OR UPDATE OR DELETE
ON myemp
DECLARE 
  val_nowdate VARCHAR2(10);
BEGIN
  SELECT to_char(SYSDATE,'dd') INTO val_nowdate FROM dual;
  IF val_nowdate !='10' THEN
    raise_application_error(-20008,'ֻ��10�Ÿ���emp��');
  END IF;
  
END;
/
show error;
select * from myemp;
insert into myemp values(1111,'name','job',7369,sysdate,800,10,20);

-- �м�������
CREATE OR REPLACE TRIGGER trigger_myemp2
BEFORE INSERT OR UPDATE OR DELETE 
ON myemp
FOR EACH ROW
DECLARE
  v_jobCount NUMBER;
BEGIN
  SELECT count(empno) INTO v_jobCount FROM myemp WHERE :NEW.JOB IN (SELECT DISTINCT JOB FROM myemp);
  IF v_jobCount<=0 THEN
    raise_application_error(-20008,'û���ҵ����ְλ');
  ELSIF :NEW.sal>500 THEN
    raise_application_error(-20008,'�Ƿ�����');
  END IF; 
END;
/
DROP TRIGGER trigger_myemp;
insert into myemp values(1111,'name','CLERK',7369,sysdate,800,10,20);

--���嵽һ���ֶ� ��Ա�ǹ��ʷ��Ȳ��ܳ���10%
CREATE OR REPLACE trigger tg_myemp_sal
BEFORE UPDATE OF sal 
ON myemp
FOR EACH ROW
BEGIN
  IF ((:NEW.sal-:OLD.sal)/:OLD.sal)>0.1 THEN
    raise_application_error(-20008,'�Ƿ�̫��');
  END IF;
END;
/
UPDATE myemp SET sal=10000 WHERE empno=7369;
show error;


-- �洢����--
-- �޲��� 
CREATE or replace PROCEDURE  p_helloworld AS 
BEGIN 
  dbms_output.put_line('helloworld!');
END;
/
exec p_helloworld;

-- �в��� in����ʡ�ԣ�out����д
--  ���ʣ����������м�¼
-- create or replace procedure p_findEnameByEmpNO(p_empno in number, p_ename out varchar2)
 create or replace procedure p_findEnameByEmpNO(p_empno in emp.empno%type, p_ename out emp.ename%type)
AS 
BEGIN
  SELECT ename INTO p_ename FROM emp WHERE empno=p_empno ;
END;
/
 
DECLARE 
  v_ename emp.ename%TYPE;
  v_empno emp.empno%type;
BEGIN
  v_empno := &empno;
  p_findEnameByEmpNO(v_empno,v_ename);
  dbms_output.put_line(v_ename);
END;
/

-- �洢����

-- ����empno��ѯ��Ա����нˮ
-- 
create or replace function getSalByEmpNO(func_empno in number )
RETURN NUMBER
AS func_sal NUMBER;
BEGIN
  SELECT sal INTO func_sal from emp WHERE empno=func_empno;
  return func_sal;
END;
/

select getsalbyempno(7369) from dual;

--�洢�������ض��ֵ���

CREATE OR REPLACE FUNCTION getEmpnameSalByID(func_empno IN NUMBER,func_sal out NUMBER) RETURN VARCHAR2
AS func_empname emp.ename%type;
BEGIN
  SELECT ename,sal INTO func_empname,func_sal FROM emp WHERE empno=func_empno;
  RETURN func_empname;
END;
/

DECLARE 
  v_empname emp.ename%TYPE;
  v_sal emp.sal%TYPE;
BEGIN
  v_empname:=getEmpnameSalByID(&empno,v_sal);
  dbms_output.put_line(v_empname||'��н'||v_sal);
END;
/






































