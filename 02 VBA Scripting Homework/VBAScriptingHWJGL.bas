Attribute VB_Name = "Module1"
Sub collectData()

    'Speed adjustment
    Application.ScreenUpdating = False
    Application.Calculation = xlCalculationManual

    'Initiate Variables
    Dim dwb As Workbook: Set dwb = ThisWorkbook
    Dim dws As Worksheet
    Dim dRowCount As Long
    Dim dColumnCount As Long
    Dim cell As Range
    Dim row As Double
    Dim column As Integer
    
    'Create dictionary variable
    Dim dictStart As Scripting.Dictionary
    Set dictStart = New Scripting.Dictionary
    Dim dictEnd As Scripting.Dictionary
    Set dictEnd = New Scripting.Dictionary
    
    Dim key As Variant
    
    
    For Each dws In dwb.Worksheets
    
        'Clear dictionaries
        dictStart.RemoveAll
        dictEnd.RemoveAll
    
        'Add Concatenated Column
        dws.Range("C1").EntireColumn.Insert
        dws.Range("C1").Value = "Concatenated Ticker + Date"
    
        'Get last row and column
        dRowCount = 0
        Do While dws.Cells(dRowCount + 1, 1) <> ""
            dRowCount = dRowCount + 1
        Loop
        
        dColumnCount = 0
        Do While dws.Cells(1, dColumnCount + 1) <> ""
            dColumnCount = dColumnCount + 1
        Loop
        
        'Create Concatenated values
        For Each cell In dws.Range("C2:C" & dRowCount)
            cell.Value = cell.Offset(0, -2).Value & cell.Offset(0, -1).Value
        Next cell
        
        'Build Table
        dws.Cells(1, dColumnCount + 2).Value = "Ticker"
        dws.Cells(1, dColumnCount + 3).Value = "Yearly Change"
        dws.Cells(1, dColumnCount + 4).Value = "Percent Change"
        dws.Cells(1, dColumnCount + 5).Value = "Total Stock Volume"
        
        'Find earliest and latest dates available for each ticker
        For Each cell In dws.Range("A2:A" & dRowCount)
            'Store open price of lowest date value tied to key
            If dictStart.Exists(cell.Value) Then
                If cell.Offset(0, 1).Value < dictStart(cell.Value) Then
                    dictStart(cell.Value) = cell.Offset(0, 1).Value
                End If
            Else
                dictStart(cell.Value) = cell.Offset(0, 1).Value
            End If
            
            'Store highest date value in dictionary tied to ticker Key
            If dictEnd.Exists(cell.Value) Then
                If cell.Offset(0, 1).Value > dictEnd(cell.Value) Then
                    dictEnd(cell.Value) = cell.Offset(0, 1).Value
                End If
            Else
                dictEnd(cell.Value) = cell.Offset(0, 1).Value
            End If
        Next cell
        
        'Populate Table
        row = 2
        For Each key In dictStart.Keys
            dws.Cells(row, dColumnCount + 2).Value = key
            'Latest close date close value - Earliest date open value
            dws.Cells(row, dColumnCount + 3).Value = dws.Cells(Application.Match(key & dictEnd(key), dws.Range("C1:C" & dRowCount), 0), 7).Value - dws.Cells(Application.Match(key & dictStart(key), _
                                                    dws.Range("C1:C" & dRowCount), 0), 4).Value
            'Difference of close - open divided by earliest date open value while catching /0 error
            If dws.Cells(Application.Match(key & dictStart(key), dws.Range("C1:C" & dRowCount), 0), 4).Value = 0 Then
                dws.Cells(row, dColumnCount + 4).Value = "N/A"
            Else
                dws.Cells(row, dColumnCount + 4).Value = dws.Cells(row, dColumnCount + 3).Value / dws.Cells(Application.Match(key & dictStart(key), dws.Range("C1:C" & dRowCount), 0), 4).Value
            End If
            'Format % change as %
            dws.Cells(row, dColumnCount + 4).NumberFormat = "0.00%"
            'Sumif worksheet Function
            dws.Cells(row, dColumnCount + 5).Value = WorksheetFunction.SumIfs(dws.Range("H2:H" & dRowCount), dws.Range("A2:A" & dRowCount), key)
            
            'Color coding
            If dws.Cells(row, dColumnCount + 3).Value > 0 Then
                dws.Cells(row, dColumnCount + 3).Interior.Color = RGB(0, 255, 0)
            ElseIf dws.Cells(row, dColumnCount + 3).Value < 0 Then
                dws.Cells(row, dColumnCount + 3).Interior.Color = RGB(255, 0, 0)
            End If
            
            row = row + 1
        Next key
            
        'Build Hard Problem Table
        dws.Cells(1, dColumnCount + 8).Value = "Ticker"
        dws.Cells(1, dColumnCount + 9).Value = "Value"
        dws.Cells(2, dColumnCount + 7).Value = "Greatest % Increase"
        dws.Cells(3, dColumnCount + 7).Value = "Greatest % Decrease"
        dws.Cells(4, dColumnCount + 7).Value = "Greatest Total Volume"
        
        'Populate Hard Problem Table
        With dws.Cells(2, dColumnCount + 9)
            .Value = WorksheetFunction.Max(dws.Range("L2:L" & dRowCount))
            .NumberFormat = "0.00%"
        End With
        With dws.Cells(3, dColumnCount + 9)
            .Value = WorksheetFunction.Min(dws.Range("L2:L" & dRowCount))
            .NumberFormat = "0.00%"
        End With
        dws.Cells(4, dColumnCount + 9).Value = WorksheetFunction.Max(dws.Range("M2:M" & dRowCount))
        
        'Return ticker symbol based on value
        dws.Cells(2, dColumnCount + 8).Value = dws.Cells(Application.Match(dws.Cells(2, dColumnCount + 9).Value, dws.Range("L1:L" & dRowCount), 0), 10).Value
        dws.Cells(3, dColumnCount + 8).Value = dws.Cells(Application.Match(dws.Cells(3, dColumnCount + 9).Value, dws.Range("L1:L" & dRowCount), 0), 10).Value
        dws.Cells(4, dColumnCount + 8).Value = dws.Cells(Application.Match(dws.Cells(4, dColumnCount + 9).Value, dws.Range("M1:M" & dRowCount), 0), 10).Value
        
        dws.Cells.EntireColumn.AutoFit
    Next dws

Cleanup:
    Set dictEnd = Nothing
    Set dictStart = Nothing
    Set dws = Nothing
    Set dwb = Nothing
    
    Application.ScreenUpdating = True
    Application.Calculation = xlCalculationAutomatic

    MsgBox ("Process complete")

End Sub
