VERSION 5.00
Begin VB.Form PatEditor 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Mini Pattern Editor"
   ClientHeight    =   4680
   ClientLeft      =   5850
   ClientTop       =   4740
   ClientWidth     =   4275
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   312
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   285
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton Command2 
      Caption         =   "Transfer to grid"
      Height          =   300
      Left            =   555
      TabIndex        =   2
      Top             =   4320
      Width           =   3165
   End
   Begin VB.CommandButton Command1 
      BackColor       =   &H00000000&
      Height          =   210
      Index           =   1
      Left            =   255
      Style           =   1  'Graphical
      TabIndex        =   1
      Top             =   45
      Width           =   210
   End
   Begin VB.CommandButton Command1 
      BackColor       =   &H00000000&
      Height          =   210
      Index           =   0
      Left            =   45
      Style           =   1  'Graphical
      TabIndex        =   0
      Top             =   45
      Width           =   210
   End
End
Attribute VB_Name = "PatEditor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim patt() As Integer
Public loaded As Boolean
Private Sub Command1_Click(Index As Integer)
If Command1(Index).BackColor = vbBlack Then
patt(Index Mod 20, Index \ 20) = 1
Command1(Index).BackColor = vbWhite
ElseIf Command1(Index).BackColor = vbWhite Then
patt(Index Mod 20, Index \ 20) = 0
Command1(Index).BackColor = vbBlack
End If
End Sub

Public Sub Command2_Click()
Dim i As Integer, j As Integer
PatEditor.Visible = False
DoEvents
For i = 0 To 19
    For j = 0 To 19
    If patt(i, j) = 1 Then
    Form1.PSet (i, j), vbWhite
    End If
    Next j
Next i
Unload PatEditor
End Sub

Private Sub Form_Load()
Dim i As Integer, j As Integer, num As Integer
ReDim patt(0 To 19, 0 To 19) As Integer
loaded = True
Form1.Cls
Form1.cmdRefresh.Enabled = False
Form1.Command3.Enabled = False
Form1.Command2.Enabled = False
Form1.cmdStop.Enabled = False
Form1.Command6.Enabled = False
For i = 2 To 19
Load Command1(i)
Command1(i).Width = 14
Command1(i).Height = 14
Command1(i).Top = 3
Command1(i).Left = 3 + 14 * i
Command1(i).Visible = True
Command1(i).BackColor = vbBlack
Next i
num = 19
For i = 1 To 19
    For j = 0 To 19
    num = num + 1
    Load Command1(num)
    Command1(num).Width = 14
    Command1(num).Height = 14
    Command1(num).Top = 3 + 14 * i
    Command1(num).Left = 3 + 14 * j
    Command1(num).Visible = True
    Command1(num).BackColor = vbBlack
    Next j
Next i
End Sub

Private Sub Form_Unload(Cancel As Integer)
loaded = False
Form1.cmdRefresh.Enabled = True
Form1.Command3.Enabled = True
Form1.Command2.Enabled = True
Form1.cmdStop.Enabled = True
Form1.Command6.Enabled = True
End Sub
