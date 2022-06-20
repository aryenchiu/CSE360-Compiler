program test;
var 
(* one line comment *)
  i: integer;
  j: integer;
  ans: array[0 .. 10] of integer;
begin
    i := -1+3;
    j := +7*8;
    ans[0] := 7;
    (* 
    multiple lines comments
    do not show comments
    *)
    for i:=1 to 9 do 
    begin
        for j:=1 to i do
            write(i*j);
    end;
end.