program test;
var 
(* one line comment *)
  i, j: integer;
  ans: array[0 .. 81] of integer;
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
            ans[i*9+j] := i*j;
    end;
    
    for i:=1 to 9 do 
    begin
        for j:=1 to i do
            if ( ans[i*9+j] mod 2 = 0) then
                write(i, '*', j, '=', ans[i*9+j], ' ');
        writeln;
    end;
end.