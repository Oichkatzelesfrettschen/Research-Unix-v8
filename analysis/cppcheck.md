# cppcheck

```
Checking v8/usr/src/cmd/2621.c ...
1/1346 files checked 0% done
Checking v8/usr/src/cmd/300.c ...
v8/usr/src/cmd/300.c:68:16: error: Allocation with calloc, setbuf doesn't release it. [leakNoVarFunctionCall]
 setbuf(stdin, calloc(BUFSIZ,1));
               ^
2/1346 files checked 0% done
Checking v8/usr/src/cmd/300s.c ...
v8/usr/src/cmd/300s.c:67:16: error: Allocation with calloc, setbuf doesn't release it. [leakNoVarFunctionCall]
 setbuf(stdin, calloc(BUFSIZ,1));
               ^
3/1346 files checked 0% done
Checking v8/usr/src/cmd/4014.c ...
4/1346 files checked 0% done
Checking v8/usr/src/cmd/450.c ...
v8/usr/src/cmd/450.c:64:16: error: Allocation with calloc, setbuf doesn't release it. [leakNoVarFunctionCall]
 setbuf(stdin, calloc(BUFSIZ,1));
               ^
5/1346 files checked 0% done
Checking v8/usr/src/cmd/512restor.c ...

```
