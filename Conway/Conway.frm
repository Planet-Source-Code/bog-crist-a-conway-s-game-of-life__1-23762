VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "COMCTL32.OCX"
Begin VB.Form Form1 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Conway's Game of LIFE"
   ClientHeight    =   10080
   ClientLeft      =   45
   ClientTop       =   360
   ClientWidth     =   13080
   ForeColor       =   &H00FFFFFF&
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   672
   ScaleLeft       =   -436
   ScaleMode       =   0  'User
   ScaleTop        =   -336
   ScaleWidth      =   872
   StartUpPosition =   2  'CenterScreen
   Begin MSComDlg.CommonDialog SaveDialog 
      Left            =   10650
      Top             =   9150
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      Filter          =   "Life files(*.lif)"
   End
   Begin MSComDlg.CommonDialog Dialog 
      Left            =   11220
      Top             =   9150
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      Filter          =   "Life files(*.lif)|*.lif"
   End
   Begin ComctlLib.StatusBar Bar1 
      Align           =   2  'Align Bottom
      Height          =   240
      Left            =   0
      TabIndex        =   9
      Top             =   9840
      Width           =   13080
      _ExtentX        =   23072
      _ExtentY        =   423
      Style           =   1
      SimpleText      =   ""
      _Version        =   327682
      BeginProperty Panels {0713E89E-850A-101B-AFC0-4210102A8DA7} 
         NumPanels       =   1
         BeginProperty Panel1 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Key             =   ""
            Object.Tag             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.Frame Frame1 
      Height          =   9930
      Left            =   12165
      TabIndex        =   0
      Top             =   -90
      Width           =   915
      Begin VB.CommandButton Command6 
         Caption         =   "Editor"
         Height          =   270
         Left            =   90
         TabIndex        =   16
         Top             =   780
         Width           =   720
      End
      Begin VB.CommandButton Command5 
         Caption         =   "About"
         Height          =   270
         Left            =   90
         TabIndex        =   15
         Top             =   6045
         Width           =   720
      End
      Begin VB.CommandButton Command4 
         Caption         =   "Tip of all days"
         Height          =   435
         Left            =   90
         TabIndex        =   14
         Top             =   9390
         Width           =   720
      End
      Begin VB.CommandButton Command2 
         Caption         =   "Save"
         Height          =   270
         Left            =   90
         TabIndex        =   13
         Top             =   1095
         Width           =   720
      End
      Begin VB.Frame Frame2 
         Caption         =   "Zoom"
         Height          =   855
         Left            =   135
         TabIndex        =   10
         Top             =   3405
         Width           =   645
         Begin VB.OptionButton Option2 
            Caption         =   "x 2"
            Height          =   285
            Left            =   60
            TabIndex        =   12
            Top             =   480
            Width           =   555
         End
         Begin VB.OptionButton Option1 
            Caption         =   "x 1"
            Height          =   285
            Left            =   60
            TabIndex        =   11
            Top             =   210
            Width           =   555
         End
      End
      Begin VB.CommandButton cmdStop 
         Caption         =   "Stop"
         Height          =   270
         Left            =   90
         TabIndex        =   8
         Top             =   5610
         Width           =   720
      End
      Begin VB.CommandButton Command3 
         Caption         =   "Load"
         Height          =   270
         Left            =   90
         TabIndex        =   7
         Top             =   465
         Width           =   720
      End
      Begin VB.CommandButton cmdRefresh 
         Caption         =   "Refresh"
         Height          =   270
         Left            =   90
         TabIndex        =   3
         Top             =   1410
         Width           =   720
      End
      Begin VB.TextBox Text1 
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   360
         Left            =   90
         TabIndex        =   2
         Top             =   1995
         Width           =   705
      End
      Begin VB.CommandButton Command1 
         Caption         =   "Start"
         Height          =   270
         Left            =   90
         TabIndex        =   1
         Top             =   150
         Width           =   720
      End
      Begin VB.Label Label3 
         AutoSize        =   -1  'True
         Caption         =   "Gen. nr."
         Height          =   195
         Left            =   135
         TabIndex        =   6
         Top             =   1800
         Width           =   645
      End
      Begin VB.Label Label2 
         AutoSize        =   -1  'True
         Caption         =   "Nr. of cells"
         Height          =   195
         Left            =   15
         TabIndex        =   5
         Top             =   2595
         Width           =   765
      End
      Begin VB.Label Label1 
         BorderStyle     =   1  'Fixed Single
         Height          =   345
         Left            =   90
         TabIndex        =   4
         Top             =   2850
         Width           =   705
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim drawcell As Byte, xx As Long, yy As Long, oriz As Long, vert As Long
Dim map() As Byte, grid() As Byte, LcellsA() As Long, nrcells As Long
Dim LcellsB() As Long, LcellsC() As Byte
Dim mapB() As Byte, getout As Byte, CanDraw As Boolean, PatSave() As Long, nrSave As Long

Private Sub Command1_Click()
Dim i As Long, j As Long, number As Long, k As Long, gen As Long, cells As Long
Dim neighbours As Byte, numberB As Long
Dim iMinus As Long, iPlus As Long, jMinus As Long, jPlus As Long
If PatEditor.loaded = True Then
PatEditor.Command2_Click
Unload PatEditor
End If
cmdRefresh.Enabled = False
Command3.Enabled = False
Command2.Enabled = False
cmdStop.Enabled = False
Command6.Enabled = False
nrSave = 0
Bar1.SimpleText = "Counting the cells..."
On Error GoTo out
getout = 0
CanDraw = False
ReDim map(-oriz To 2 * oriz, -vert To 2 * vert) As Byte
ReDim mapB(-oriz To 2 * oriz, -vert To 2 * vert) As Byte
ReDim grid(-oriz To 2 * oriz, -vert To 2 * vert) As Byte
'[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
For i = Form1.ScaleLeft To -Form1.ScaleLeft
    For j = Form1.ScaleTop To -Form1.ScaleTop
        iMinus = i - 1
        iPlus = i + 1
        jMinus = j - 1
        jPlus = j + 1
        If Form1.Point(i, j) = vbWhite Then
            ReDim Preserve PatSave(1 To 2, nrSave) As Long
            PatSave(1, nrSave) = i
            PatSave(2, nrSave) = j
            nrSave = nrSave + 1
            map(i, j) = 1
            ReDim Preserve LcellsA(1 To 2, number + 9) As Long
            If grid(i, j) = 0 Then
            grid(i, j) = 1
            number = number + 1
            LcellsA(1, number) = i
            LcellsA(2, number) = j
            End If
            
            If grid(iPlus, j) = 0 Then                         '1
                grid(iPlus, j) = 1
                number = number + 1
                LcellsA(1, number) = iPlus
                LcellsA(2, number) = j
            End If
            
            If grid(iPlus, jPlus) = 0 Then                      '2
                grid(iPlus, jPlus) = 1
                number = number + 1
                LcellsA(1, number) = iPlus
                LcellsA(2, number) = jPlus
            End If
            
            If grid(iPlus, jMinus) = 0 Then                       '3
                number = number + 1
                grid(iPlus, jMinus) = 1
                LcellsA(1, number) = iPlus
                LcellsA(2, number) = jMinus
            End If
            
            If grid(i, jPlus) = 0 Then                            '4
                number = number + 1
                grid(i, jPlus) = 1
                LcellsA(1, number) = i
                LcellsA(2, number) = jPlus
            End If
            
            If grid(i, jMinus) = 0 Then                             '5
                number = number + 1
                grid(i, jMinus) = 1
                LcellsA(1, number) = i
                LcellsA(2, number) = jMinus
            End If
            
            If grid(iMinus, j) = 0 Then                             '6
                number = number + 1
                grid(iMinus, j) = 1
                LcellsA(1, number) = iMinus
                LcellsA(2, number) = j
            End If
            
            If grid(iMinus, jPlus) = 0 Then                         '7
                number = number + 1
                grid(iMinus, jPlus) = 1
                LcellsA(1, number) = iMinus
                LcellsA(2, number) = jPlus
            End If
            
            If grid(iMinus, jMinus) = 0 Then                         '8
                number = number + 1
                grid(iMinus, jMinus) = 1
                LcellsA(1, number) = iMinus
                LcellsA(2, number) = jMinus
            End If
            
         End If
    Next j
Next i
ReDim grid(-oriz To 2 * oriz, -vert To 2 * vert) As Byte
Bar1.SimpleText = "Life goes on !"
cmdStop.Enabled = True
'[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
'[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
Do
DoEvents
k = k + 1
cells = 0
For nrcells = 1 To number
i = LcellsA(1, nrcells)
j = LcellsA(2, nrcells)
        iMinus = i - 1
        iPlus = i + 1
        jMinus = j - 1
        jPlus = j + 1
        neighbours = map(iPlus, j) + map(iPlus, jPlus) + map(iPlus, jMinus) + map(i, jPlus) + _
                     map(i, jMinus) + map(iMinus, j) + map(iMinus, jPlus) + map(iMinus, jMinus)
        
        '------------------------------------------------------------------------------------------------------
        If (neighbours < 2 Or neighbours > 3) And map(i, j) = 1 Then
            Form1.PSet (i, j), BackColor
            mapB(i, j) = 0
        ElseIf (neighbours = 3 And map(i, j) = 0) Or ((neighbours = 2 Or neighbours = 3) And map(i, j) = 1) Then
            If map(i, j) = 0 Then
            Form1.PSet (i, j), vbWhite     'By including this line in an "If...End If" block I gain a little
            End If                         '(or more,depends on the pattern) speed, but some cells will not
            mapB(i, j) = 1                 'be redrawn if the form is minimized or cover by other windows
            cells = cells + 1              'during the simulation.
            ReDim Preserve LcellsB(1 To 2, numberB + 9) As Long
'[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
            If grid(i, j) = 0 Then
                grid(i, j) = 1
                numberB = numberB + 1
                LcellsB(1, numberB) = i
                LcellsB(2, numberB) = j
            End If
            
            If grid(iPlus, j) = 0 Then                         '1
                grid(iPlus, j) = 1
                numberB = numberB + 1
                LcellsB(1, numberB) = iPlus
                LcellsB(2, numberB) = j
            End If
            
            If grid(iPlus, jPlus) = 0 Then                     '2
                grid(iPlus, jPlus) = 1
                numberB = numberB + 1
                LcellsB(1, numberB) = iPlus
                LcellsB(2, numberB) = jPlus
            End If
            
            If grid(iPlus, jMinus) = 0 Then                     '3
                numberB = numberB + 1
                grid(iPlus, jMinus) = 1
                LcellsB(1, numberB) = iPlus
                LcellsB(2, numberB) = jMinus
            End If
            
            If grid(i, jPlus) = 0 Then                         '4
                numberB = numberB + 1
                grid(i, jPlus) = 1
                LcellsB(1, numberB) = i
                LcellsB(2, numberB) = jPlus
            End If
            
            If grid(i, jMinus) = 0 Then                        '5
                numberB = numberB + 1
                grid(i, jMinus) = 1
                LcellsB(1, numberB) = i
                LcellsB(2, numberB) = jMinus
            End If
            
            If grid(iMinus, j) = 0 Then                        '6
                numberB = numberB + 1
                grid(iMinus, j) = 1
                LcellsB(1, numberB) = iMinus
                LcellsB(2, numberB) = j
            End If
            
            If grid(iMinus, jPlus) = 0 Then                    '7
                numberB = numberB + 1
                grid(iMinus, jPlus) = 1
                LcellsB(1, numberB) = iMinus
                LcellsB(2, numberB) = jPlus
            End If
            
            If grid(iMinus, jMinus) = 0 Then                   '8
                numberB = numberB + 1
                grid(iMinus, jMinus) = 1
                LcellsB(1, numberB) = iMinus
                LcellsB(2, numberB) = jMinus
            End If
'[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
        End If
Next nrcells

For nrcells = 1 To number
i = LcellsA(1, nrcells)
j = LcellsA(2, nrcells)
map(i, j) = mapB(i, j)
Next nrcells

For nrcells = 1 To numberB
i = LcellsB(1, nrcells)
j = LcellsB(2, nrcells)
grid(i, j) = 0
Next nrcells

LcellsA = LcellsB

Text1.Text = k
Label1.Caption = cells

number = numberB
numberB = 0

Loop Until getout = 1
out:
    If Err.number <> 0 Then
    Bar1.SimpleText = "RED ALERT ! The cells have tried to escape from the grid !"
    getout = 1
    CanDraw = True
    cmdRefresh.Enabled = True
    Command3.Enabled = True
    Command2.Enabled = True
    Command6.Enabled = True
    End If
End Sub

Private Sub cmdRefresh_Click()
    getout = 1
    CanDraw = True
    Form1.Cls
End Sub

Private Sub Command2_Click()
Dim fil As String, i As Long
On Error GoTo out

SaveDialog.ShowSave
fil = SaveDialog.FileName
Open fil For Output As #1
    Print #1, "Save by Bogdan's ""Conway 's Game of Life"""
    Print #1, "Version 1.0.0"
    For i = 0 To nrSave - 1
    Print #1, PatSave(1, i) & " " & PatSave(2, i)
    Next i
Close 1#

out: Exit Sub
End Sub

Private Sub Command3_Click()
cmdStop_Click
cmdRefresh_Click
Dim x As String, y As String, a As String, fis As String, desp As Long
Dim x1 As Long, y1 As Long
On Error GoTo out
ChDir App.Path & "\Life"
Dialog.ShowOpen
fis = Dialog.FileName
Open fis For Input As #1
        Line Input #1, a
        Line Input #1, a
        Do While Not EOF(1)
        Line Input #1, a
        desp = InStr(1, a, " ", vbTextCompare)
        x = Left(a, desp)
        y = Right(a, Len(a) - desp)
        x1 = CInt(x)
        y1 = CInt(y)
        Form1.PSet (x1, y1), vbWhite
        Loop
        Close #1
Exit Sub
out: Close #1

End Sub

Private Sub cmdStop_Click()
    cmdRefresh.Enabled = True
    Command3.Enabled = True
    Command2.Enabled = True
    Command6.Enabled = True
    getout = 1
    CanDraw = True
    Bar1.SimpleText = "All cells were frozen !"
End Sub

Private Sub Command4_Click()
Dim msg
msg = MsgBox("LIFE is like a box of chocolates; you never know what you gonna get ! :)", vbInformation, "The Most Important Tip of All")
End Sub

Private Sub Command5_Click()
Dim msg
msg = MsgBox("Programmed by Lucian Bogdan Cristache" & vbCrLf & "        bogcrist@pcnet.ro", vbInformation, "About this LIFE")
End Sub

Private Sub Command6_Click()
PatEditor.Show
End Sub

Private Sub Form_Load()
oriz = Form1.ScaleWidth
vert = Form1.ScaleHeight
Option1.Value = True
CanDraw = True
End Sub

Private Sub Form_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
If Button = 1 Then
    Form1.ForeColor = vbWhite
ElseIf Button = 2 Then
    Form1.ForeColor = vbBlack
End If

If CanDraw = True Then
drawcell = 1
xx = x
yy = y
Form1.PSet (x, y)
End If
End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
If CanDraw = True Then
If drawcell Then Line (xx, yy)-(x, y)
xx = x
yy = y
End If
End Sub

Private Sub Form_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
drawcell = 0
Form1.ForeColor = vbWhite
End Sub

Private Sub Form_Unload(Cancel As Integer)
cmdStop_Click
Unload PatEditor
End
Set Form1 = Nothing
End Sub

Private Sub Option1_Click()
Form1.Refresh
Form1.ScaleLeft = -436
Form1.ScaleTop = -336
Form1.ScaleWidth = oriz
Form1.ScaleHeight = vert
Form1.DrawWidth = 1
End Sub

Private Sub Option2_Click()
Form1.Refresh
Form1.ScaleLeft = -218
Form1.ScaleTop = -168
Form1.ScaleWidth = oriz / 2
Form1.ScaleHeight = vert / 2
Form1.DrawWidth = 2
End Sub
