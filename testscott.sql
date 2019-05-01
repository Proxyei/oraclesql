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
SELECT *
FROM emp,
  dept;
SELECT e.*,
  DECODE(sg.grade,1,'A',2,'B',3,'C',4,'D',5,'E') 工资等级
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
--insert into emp values (9299,'爵爷','coder','7369',sysdate,800,100,null);
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
SELECT deptno 部门编号,COUNT(*) 部门人数 FROM emp GROUP BY deptno ORDER BY deptno;
SELECT job,MAX(sal) 最高工资,MIN(sal) 最低工资 FROM emp GROUP BY job;
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
  );-- 错误的，因为是多行结果，如果改为单行就是正确的
-- 使用rownum分页 select * from (select rownum rnum, table1.* from table1 where rownum<=(currentpage)*pagsize) temp where temp.rnum>(currentpage-1)*pagesize ;
-- 疑问：如果我是从2亿数据里面查找第1.9亿之后的十条记录，是不是oracle先查出1.9亿+10条记录，然后再筛选出要求的10条出来，如果是这样，那么内存如何守得住？还是前1.9亿条数据不会一下子查出来，只是游标自动查找到第1.9亿条数据后面的10条？
SELECT *
FROM
  (SELECT rownum rn, mydept.* FROM mydept WHERE rownum<=3*5
  ) temp
WHERE temp.rn>(3-1)*5;
-- oracle 12c开始使用fetch分页 select * from table offset (currentpage-1)*pagesize rows fetch net pagesize row only;注意，下面第一条是从0开始
SELECT rownum,
  a.*
FROM myemp a offset 3 rows
FETCH NEXT 3 rows only;
-- 第三页数据
SELECT rownum, myemp.* FROM myemp offset (3-1)*3 rows
FETCH NEXT 3 rows only;
-- row也可以
SELECT rownum, myemp.* FROM myemp offset (3-1)*3 rows
FETCH NEXT 3 row only;
SELECT rownum, myemp.* FROM myemp offset (2-1)*3 rows
FETCH NEXT 3 rows only;
-- 测试差集minus用于分页，结果是无法做到的
(
SELECT rownum,
  myemp.*
FROM myemp
WHERE rownum <=(3)*3
)
INTERSECT
  (SELECT rownum,myemp.* FROM myemp WHERE rownum>(3-1)*3
  );
---------------------------------------- start  PL/SQL编程----------------------------------
-- 打开服务输出显示
SET serveroutput ON;
-- 1，示例
BEGIN
  dbms_output.put_line('helloworld');
END;
/
-- 2,变量使用
DECLARE
  v_name VARCHAR2(20);
BEGIN
  v_name := '韦小宝';
  dbms_output.put_line('你的名字是：'||v_name);
END;
/
-- 3,键盘输入变量 根据输入的用户编号查找用户名字
DECLARE
  v_empno NUMBER(10);
  v_ename VARCHAR2(20);
BEGIN
  v_empno := &eno;
  SELECT ename INTO v_ename FROM emp WHERE empno=v_empno;
  dbms_output.put_line('编号 '||v_empno||' 的雇员的名字为 '||v_ename);
EXCEPTION
  dbms_output.put_line('没找到数据');
END;
/
-- 4，声明类型
SET serveroutput ON;
-- 声明某列类型
DECLARE
  v_ename emp.ename%TYPE;
  v_empno emp.empno%TYPE;
BEGIN
  v_empno:=&eno;
  SELECT ename INTO v_ename FROM emp WHERE empno = v_empno;
  -- 多个列值可以这样写：select ename,deptno into v_ename,v_deptno from emp;
  dbms_output.put_line('编号为：'||v_empno||' 的雇员名字为：'||v_ename);
END;
/
--- 声明为行类型 ROWTYPE
DECLARE
  v_emp emp%ROWTYPE;
BEGIN
  SELECT * INTO v_emp FROM emp WHERE empno=7369;
  dbms_output.put_line(v_emp.empno||': '||v_emp.ename);
END;
/
-- 流程控制
SET serveroutput ON;
DECLARE
  v_count NUMBER(4);
BEGIN
  SELECT COUNT(empno) INTO v_count FROM emp;
  IF v_count > 10 THEN
    dbms_output.put_line('城里人太多');
  END IF;
  IF 'java'='java' THEN
    dbms_output.put_line('helloworld');
  END IF;
END;
/
-- 循环
DECLARE
  v_num NUMBER;
BEGIN
  v_num := 10;
  LOOP
  --因为少了个分号;找了半天弄不好
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

-- for 使用

DECLARE 
  v_i NUMBER ;
BEGIN
  FOR v_i IN 1 .. 3 
  loop
    dbms_output.put_line(' '||v_i);
  end loop;
END;
/

-- 异常处理
set serveroutput on;
-- 1 声明exception对象

-- 1.1 引用声明的exception对象 使用others捕获，此时oracle错误代码为1
DECLARE
  v_empno NUMBER;
  v_myexception exception; 
  
BEGIN
  v_empno := &eno;
  IF v_empno>=1 AND v_empno<=10000 THEN
    dbms_output.put_line('进入错误输入代码块');
    raise v_myexception;
  END IF;
exception
  WHEN others THEN
       dbms_output.put_line('错误输入');
       dbms_output.put_line('sqlcode: '||SQLCODE);
       dbms_output.put_line('sqlerrm '||SQLERRM);
END;
/

-- 1.2 将声明的对象与有效的oracle错误代码联系起来
DECLARE
  v_empno NUMBER;
  v_myexception exception;
  pragma exception_int(v_myexcption,-20789);
BEGIN
  v_empno:=&eno;
  IF v_empno>=0 AND v_empno<=11110 THEN
    dbms_output.put_line('进入异常代码块');
    raise v_myexception;
exception
  when v_myexception then
    dbms_output.put_line('错误输入');
    dbms_output.put_line('sqlcode: '||sqlcode);
    dbms_output.put_line('sqlerrm: '||sqlerrm);
END;
/




-- 2 使用 raise_appliaction_error构建错动态的异常 raise_application_error(错误号，错误信息，是否添加到错误栈中);




------------------end PL/SQL编程------------






























































