uses Matrix;

const
  matrixRowsAmount: integer = 3;
  matrixColumnsAmount: integer = 4;

var
  matrix: array[,] of real;
  resultMatrix: array[,] of real;
  extendedResultMatrix: ExtendedMatrix;
  tempMatrix: array[,] of real;
  basicElementIndexes: (integer, integer);
  matrixTransformationCount: integer := 0;
  matrixExample1 := new real[5, 6] (
    (3.0, 1.0,  -4.0,  2.0,  -5.0, 9.0),
    (6.0, 0.0,  1.0,  -3.0,  4.0, -5.0),
    (1.0, 0.0, 1.0, -1.0, 1.0, -1.0),
    (0.0, 2.0, 6.0, -5.0, 1.0, 4.0),
    (-10.0, -1.0, 2.0, 2.0, 0.0, -3.0)
  );
  
  extendedMatrixExample1: ExtendedMatrix := (
    baseMatrix: matrixExample1;
    rowX: new string[5] ('-x1', '-x2', '-x3', '-x4', '-x5');
    columnX: new string[5] ('x6=', 'x7=', 'x8=', 'f=', 'g=');
  );
  
//  matrixExample2 := new real[3, 4] (
//    (1.0, 1.0, 2.0,  3.0),
//    (1.0, 1.0, 1.0,  1.0),
//    (2.0, 1.0, 0.0, -1.0)
//  );
//  
//  extendedMatrixExample2: ExtendedMatrix := (
//    baseMatrix: matrixExample2;
//    rowX: new string[3] ('-x1', '-x2', '-x3');
//    columnX: new string[3] ('0=', '0=', '0=');
//  );
//  
//  matrixExample3 := new real[3, 4] (
//    (5.0, 1.0, 3.0,  -4.0),
//    (0.0, -1.0, 1.0,  1.0),
//    (9.0, 2.0, 1.0, 1.0)
//  );
//  
//  extendedMatrixExample3: ExtendedMatrix := (
//    baseMatrix: matrixExample3;
//    rowX: new string[3] ('-x1', '-x2', '-x3');
//    columnX: new string[3] ('0=', '0=', '0=');
//  );

begin
  Console.OutputEncoding := System.Text.Encoding.GetEncoding(866);
  extendedResultMatrix := extendedMatrixExample1;
  
  Writeln('Исходная матрица');
  extendedResultMatrix.Print();
  
  while (true) do
  begin
    var pivotColumnIndex := extendedResultMatrix.FindPivotColumnIndex();
    Writeln('Индекс разрешающего столбца: ', pivotColumnIndex);
    
    var pivotRowIndex := extendedResultMatrix.FindPivotRowIndex(pivotColumnIndex);
    Writeln('Индекс разрешающей строки: ', pivotRowIndex);
    
    Writeln('Разрешающий элемент: ', extendedResultMatrix.baseMatrix[pivotRowIndex, pivotColumnIndex]);
    tempMatrix := GaussianElimination(extendedResultMatrix.baseMatrix, (pivotRowIndex, pivotColumnIndex));
    
    extendedResultMatrix.baseMatrix := tempMatrix;
    Writeln('Преобразование ', matrixTransformationCount);
    extendedResultMatrix.Print();
    
    var isAllColumnElementsNegative := true;
    for var i := 0 to extendedResultMatrix.baseMatrix.GetLength(0) - 2 do
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
    
    matrixTransformationCount += 1;
    
    // TODO: remove break;
//    break;
  end;
  
//  matrixTransformationCount := 0;
//  while (true) do
//  begin
//    Writeln('Введите индекс разрешающего элемента в формате "i j" (без кавычек)');
//    basicElementIndexes := readBasicElementIndexes();
//    Writeln(
//      'Разрешающий элемент = ',
//      extendedResultMatrix.baseMatrix[basicElementIndexes[0], basicElementIndexes[1]]
//    );
//    
//    tempMatrix := gaussianElimination(extendedResultMatrix.baseMatrix, basicElementIndexes);
//    extendedResultMatrix.baseMatrix := deleteColumn(tempMatrix, basicElementIndexes[1]);
//    
//    extendedResultMatrix.columnX[basicElementIndexes[0]] := extendedResultMatrix.rowX[basicElementIndexes[1] - 1].Substring(1) + '='; 
//    extendedResultMatrix.rowX := extendedResultMatrix.rowX
//                                  .Where((element, i) -> i <> basicElementIndexes[1] - 1).ToArray();
//    
//    matrixTransformationCount += 1;
//    Writeln('Преобразование ', matrixTransformationCount);
//    extendedResultMatrix.Print();
//    Writeln('------------------------------------------------------------------');
    
    // проверка найден ли ответ
    // проверка противоречий
//    for var i := 0 to extendedResultMatrix.baseMatrix.GetLength(0) - 1 do
//      if (
//        (extendedResultMatrix.columnX[i] = '0=')
//        and (rowSum(extendedResultMatrix.baseMatrix, i) - extendedResultMatrix.baseMatrix[i, 0] = 0)
//        and (extendedResultMatrix.baseMatrix[i, 0] <> 0)
//      ) then
//      begin
//        Writeln('Нет решений');
//        exit;
//      end;
      
//    for var i := 0 to extendedResultMatrix.baseMatrix.GetLength(0) - 1 do
//      if (extendedResultMatrix.columnX[i] = '0=') then
//      begin
//        if (rowSum(extendedResultMatrix.baseMatrix, i) = 0) then
//        begin
//          Writeln('Ответ:');
//          printAnswer(extendedResultMatrix);
//          exit;
//        end;
//      end;
        
//    if (extendedResultMatrix.baseMatrix.GetLength(1) = 1) then
//    begin
//      Writeln('Ответ:');
//      for var i := 0 to extendedResultMatrix.baseMatrix.GetLength(0) - 1 do
//        Writeln(extendedResultMatrix.columnX[i], ' ', extendedResultMatrix.baseMatrix[i, 0]);
//      exit;
//    end; 
//  end;
end.