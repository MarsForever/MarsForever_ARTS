record micro shortcut
alt + t + r + m

shortcut open visual basic
alt + f11

excute module
f5

execute module line by line
f8

put your corsor on the function and press f1 to see guide
f1

イミディエイト　=> enter key
?activecell.Address
?selection.address

why vba si difficutl
1) it has many control must use grafhpic interface
2) sometimes you have to write Code and need to set userform's property

```vba
'show type'
?range("c6").Interior.ColorIndex
?range("c7").Interior.Color
'put the value to range, change the color'
range("c6").Interior.ColorIndex=1
range("c7").Interior.Color= 15202815 
range("C6").Interior.Color=RBG(255, 249, 231)
```

#### Set cell value
```vba
Sub ReferToCells()
Cells.Clear

' Setting A1 to 1st
'Range("A1").Value = "1st"
Cells(1, 1) = "1st"

' Setting from A2 to C2 as 2nd
Range("A2:C2").Value = "2nd"

' Setting from a3 to c3,e3 to f3 as "3rd"
Range("A3:c3,e3:f3").Value = "3rd"

' Setting a4 and c4 to "4th"
Range("A4,C4") = "4th"

' Setting from a5 to c5 as "5th"
Range("A5", "C5") = "5th"
' Setting from a6 to c6 as "6th"
'Range("A" & 6, "C" & 6) = "6th"

Range(Cells(6, 1), Cells(6, 3)).Value = "6th"
' Setting range A4:C7 = 0,0
' You can access single cells via Item(row, column)
' A4:C7 = 0, 0
' A4:C7 + row:4,column:2 = A7 + clumn:2 = C7

Range("A4:C7").Cells(4, 2).Value = "7th"
' A as 1, 1 as 1
' Setting C8 as "8th"
' A1 + row:7 =  A8 , A8 + column:2 = C8

Range("A1").Offset(7, 2).Value = "8th"

'Setting C8 as as "8th"
Range("A1").Offset(7, 2).Range("A1").Value = "8th"

'Setting C8:C11 as "8th"
'Range("A1").Offset(7, 2).Range("A1:A4").Value = "8th"
' expression.Offset (RowOffset, ColumnOffset)
'A1 + row:8,B1+ row:8 = > A9:B9
' A9:B9 + column:1 => B9:C9
' Setting B9:C9 as "9th"
Range("A1:B1").Offset(8, 1).Value = "9th"

' Setting A10 as LastOne
' A10's value is "10"
Range("Lastone").Value = "10"

' Setting rowheight
Rows("12:14").RowHeight = 30
' Setting rowheight
 Range("16:16,18:18,20:20").RowHeight = 30
 
' Setting columwidth
Columns("E:F").ColumnWidth = 20
Range("H:H,J:J").ColumnWidth = 10
Range(Columns(1), Columns(3)).ColumnWidth = 5
Cells.Columns.AutoFit

End Sub

Sub Range_Property_method_Examples()
' Example of Property --> Text Property
'-----------------------------------------
Range("B6").Value = Range("B5").Value
Range("B6").Value = Range("B5").Text
'-----------------------------------------
'Example of Method --> Delete
'-----------------------------------------
' Delete cell 左方向へシフト
Range("B7").Delete xlShiftToLeft
' Delete entire row
Range("b9").EntireRow.Delete
'-----------------------------------------
'Select cell A1 on Tab "Purpose"
'-----------------------------------------
Worksheets("Purpose").Select
Range("A1").Select
```

### add new sheet

```vba
Private Sub btInsert_Click()
  Sheets.Add after:=Sheets(Sheets.Count)
End Sub
```

### add data to user form

#### create add button and delete button

```
Private Sub btAdd_Click()
  Dim ctr As Control
  Dim InReq As Boolean

Private Sub cbScreen_Click()
  Application.DisplayFullScreen = Not Application.DisplayFullScreen
  With Application.ActiveWindow
        .DisplayHeadings = Not .DisplayHeadings
        .DisplayWorkbookTabs = Not .DisplayWorkbookTabs
        .DisplayHorizontalScrollBar = Not .DisplayHorizontalScrollBar
        .DisplayVerticalScrollBar = Not .DisplayVerticalScrollBar
  End With
  If cbScreen.Value Then
    Me.ScrollArea = "A1:N30"
  Else
    Me.ScrollArea = ""
  End If
End Sub

Private Sub chhelp_Click()
  Dim HelpShapes()
  HelpShapes = Array("GroupHelp1", "GroupHelp2", "GroupHelp3")
End Sub

Sub Customer_Master()
  FmlnputMaster.Show
End Sub


Private Sub btCancel_Click()
  Unload Me
End Sub
```



ThisWorkbook => Workbook => Open

```vba
Private Sub Workbook_Open()
If ActiveSheet.Name = "ActiveX" Then
  Worksheets("Purpose").Select
  Worksheets("ActiveX").Select
End If
End Sub
```



checkbox

LinkedCell => 反映するcell

ListFillRange => 参照するリスト一覧

Some property is important

Name,tag,value,font

Array
Dim HelpShart()
HelpShart = Array("GroupHelp1", "GroupHelp2", "GroupHelp3")



vba grammer
Unload me
control
isnumberic

meの使い方をまとめる
