unit Cmd;

interface
procedure printMatrix(matrix: array[,] of real);
function readBasicElementIndexes(): (integer, integer);

implementation

procedure printMatrix(matrix: array[,] of real);
begin
  for var i := 0 to Length(matrix, 0) - 1 do
  begin
    Write(matrix[i, 0]:7:2, '│');
    for var j := 1 to Length(matrix, 1) - 1 do
      Write(matrix[i, j]:7:2, ' ');
    Writeln();
  end;     
end;

function readBasicElementIndexes(): (integer, integer);
var
  a, b: integer;
begin
  Readln(a, b);
  Result := (a - 1, b) // первый столбец является левой частью уравнений (b - 1 + 1 = b)
end;
  
end.