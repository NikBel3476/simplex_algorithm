uses System;
uses Matrix;

const
  matrixRowsAmount: integer = 3;
  matrixColumnsAmount: integer = 4;

var
  pivotRowIndex: integer;
  pivotColumnIndex: integer;
  matrix: array[,] of real;
  resultMatrix: array[,] of real;
  extendedResultMatrix: ExtendedMatrix;
  tempMatrix: array[,] of real;
  originFuncCoefficients: array of real;
  
  matrixTransformationCount: integer := 1;
  matrixExample1 := new real[5, 6] (
    (  3.0,  1.0, -4.0,  2.0, -5.0,  9.0),
    (  6.0,  0.0,  1.0, -3.0,  4.0, -5.0),
    (  1.0,  0.0,  1.0, -1.0,  1.0, -1.0),
    (  0.0,  2.0,  6.0, -5.0,  1.0,  4.0),
    (-10.0, -1.0,  2.0,  2.0,  0.0, -3.0)
  );
  
  extendedMatrixExample1: ExtendedMatrix := (
    baseMatrix: matrixExample1;
    rowX: new string[5] ('-x1', '-x2', '-x3', '-x4', '-x5');
    columnX: new string[5] ('x6=', 'x7=', 'x8=', 'f=', 'g=');
  );
  
  matrixExample2 := new real[5, 5] (
    ( 3.0,   1.0,  2.0,  3.0,   4.0),
    ( 1.0,   6.0,  2.0,  4.0,   8.0),
    ( 5.0,   3.0,  2.0,  1.0,   2.0),
    ( 0.0,   3.0,  1.0,  5.0,   4.0),
    (-9.0, -10.0, -6.0, -8.0, -14.0)
  );
  
  extendedMatrixExample2: ExtendedMatrix := (
    baseMatrix: matrixExample2;
    rowX: new string[4] ('-x1', '-x2', '-x3', '-x4');
    columnX: new string[5] ('x5=', 'x6=', 'x7=', 'f=', 'g=');
  );
  
  matrixExample3 := new real[5, 4] (
    ( 4.0, -3.0,   8.0,  1.0),
    ( 2.0, -5.0,  -3.0, -1.0),
    ( 3.0, 15.0,  10.0, -2.0),
    ( 0.0, -2.0,   1.0,  3.0),
    (-9.0, -7.0, -15.0,  2.0)
  );
  
  extendedMatrixExample3: ExtendedMatrix := (
    baseMatrix: matrixExample3;
    rowX: new string[3] ('-x1', '-x2', '-x3');
    columnX: new string[5] ('x4=', 'x5=', 'x6=', 'f=', 'g=');
  );
  
  matrixExample4 := new real[4, 6] (
    ( 1.0, -1.0, -1.0, -2.0, -3.0,  2.0),
    (-1.0, -1.0,  2.0, -3.0, -2.0,  2.0),
    ( 0.0,  1.0,  1.0,  2.0,  3.0, -1.0),
    ( 0.0,  0.0, -1.0,  5.0,  5.0, -4.0)
  );
  
  extendedMatrixExample4: ExtendedMatrix := (
    baseMatrix: matrixExample4;
    rowX: new string[5] ('-x1', '-x2', '-x3', '-x4', '-x5');
    columnX: new string[4] ('x6=', 'x7=', 'f=', 'g=');
  );

begin
//  Console.OutputEncoding := System.Text.Encoding.GetEncoding(866);
  
  extendedResultMatrix := extendedMatrixExample4;
  
  originFuncCoefficients := extendedResultMatrix.baseMatrix
    .Row(extendedResultMatrix.baseMatrix.GetLength(0) - 2).Skip(1).ToArray();
  
  Writeln('Исходная матрица');
  extendedResultMatrix.Print();
  Writeln('------------------------------------------------------------------');
  
  // part 1
  while (true) do
  begin
    pivotColumnIndex := extendedResultMatrix.FindPivotColumnIndex();
    
    // поиск отрицательного элемента в столбце. begin
    var isAllColumnElementsNegative := true;
    for var i := 0 to extendedResultMatrix.baseMatrix.GetLength(0) - 3 do
    begin
      if (extendedResultMatrix.baseMatrix[i, pivotColumnIndex] > 0) then
      begin
        isAllColumnElementsNegative := false;
        break;
      end;
    end;
    
    if (isAllColumnElementsNegative) then
    begin
      Writeln('Нет решений');
      exit;
    end;
    // поиск отрицательного элемента в столбце. end
    
    pivotRowIndex := extendedResultMatrix.FindPivotRowIndex(pivotColumnIndex);
    Writeln('Индекс разрешающего элемента: (', pivotRowIndex + 1, ', ', pivotColumnIndex, ')');
    Writeln('Разрешающий элемент: ', extendedResultMatrix.baseMatrix[pivotRowIndex, pivotColumnIndex]);
    
    tempMatrix := GaussianElimination(extendedResultMatrix.baseMatrix, (pivotRowIndex, pivotColumnIndex));
    extendedResultMatrix.baseMatrix := tempMatrix;
    extendedResultMatrix.SwapRowAndColumnVariables(pivotRowIndex, pivotColumnIndex - 1);
    
    Writeln('Преобразование ', matrixTransformationCount);
    extendedResultMatrix.Print();
    
    if (extendedResultMatrix.IsAllRowElementsNotNegative(
        extendedResultMatrix.baseMatrix.GetLength(0) - 1))
    then
      break;
    
    matrixTransformationCount += 1;
    Writeln('------------------------------------------------------------------');
  end;
  
  // part 2
  while (true) do
  begin
    // поиск индекса столбца, в котором элемент из строки g равен 0, а из строки f меньше 0. begin
    pivotColumnIndex := -1;
    for var i := 1 to extendedResultMatrix.baseMatrix.GetLength(1) - 1 do
      if (
        (extendedResultMatrix.baseMatrix[extendedResultMatrix.baseMatrix.GetLength(0) - 1, i] = 0)
        and (extendedResultMatrix.baseMatrix[extendedResultMatrix.baseMatrix.GetLength(0) - 2, i] < 0)
      ) then
      begin
        pivotColumnIndex := i;
        break;
      end;
    // поиск индекса столбца, в котором элемент из строки g равен 0, а из строки f меньше 0. end
    
    if (pivotColumnIndex > 0) then
    begin
      // поиск отрицательного элемента в столбце. begin
      var isAllColumnElementsNegative := true;
      for var i := 0 to extendedResultMatrix.baseMatrix.GetLength(0) - 3 do
      begin
        if (extendedResultMatrix.baseMatrix[i, pivotColumnIndex] > 0) then
        begin
          isAllColumnElementsNegative := false;
          break;
        end;
      end;
      
      if (isAllColumnElementsNegative) then
      begin
        Writeln('Нет решений');
        exit;
      end;
      // поиск отрицательного элемента в столбце. end
      
      pivotRowIndex := extendedResultMatrix.FindPivotRowIndex(pivotColumnIndex);
      Writeln('Индекс разрешающего элемента: (', pivotRowIndex + 1, ', ', pivotColumnIndex, ')');
      Writeln('Разрешающий элемент: ', extendedResultMatrix.baseMatrix[pivotRowIndex, pivotColumnIndex]);
      
      tempMatrix := gaussianElimination(extendedResultMatrix.baseMatrix, (pivotRowIndex, pivotColumnIndex));
      extendedResultMatrix.baseMatrix := tempMatrix;
      extendedResultMatrix.SwapRowAndColumnVariables(pivotRowIndex, pivotColumnIndex - 1);
      
      Writeln('Преобразование ', matrixTransformationCount);
      extendedResultMatrix.Print();
      
      matrixTransformationCount += 1;
      Writeln('------------------------------------------------------------------');
    end
    else
    begin
      Writeln('Ответ:');
      
      // исключаем строки g, f и столбец уравнения, поэтому длина - 3
      var xValues := ArrFill(
        extendedResultMatrix.baseMatrix.GetLength(0) + extendedResultMatrix.baseMatrix.GetLength(1) - 3,
        0.0
      );
      
      // обход столбца
      for var i := 0 to extendedResultMatrix.columnX.Length - 3 do
      begin
        var variableName := extendedResultMatrix.columnX[i];
        var index := StrToInt(variableName.Substring(1, variableName.Length - 2)) - 1;
        var columnXIndex := extendedResultMatrix.columnX.IndexOf(variableName);
        xValues[index] := extendedResultMatrix.baseMatrix[i, 0];
      end;
      
      // вывод ответа
      Write('x = ( ');
      for var i := 0 to xValues.Length - 1 do
      begin
        Write(xValues[i]:0:2, '  ');
      end;
      Writeln(')');
      
      if (xValues.TakeLast(extendedResultMatrix.baseMatrix.GetLength(0) - 2).All(x -> x = 0)) then
      begin
        var answer := 0.0;
        for var i := 0 to extendedResultMatrix.baseMatrix.ColCount() - 2 do
          answer += -originFuncCoefficients[i] * xValues[i];
        Writeln('F(x) = ', answer:0:3)
      end
      else        
        Writeln('Исходная задача не имеет опорного плана');
      
      exit;
    end;
  end;
end.