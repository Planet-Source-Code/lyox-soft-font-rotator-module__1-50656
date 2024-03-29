Attribute VB_Name = "modFontRotate"
Option Explicit
Public Const OUT_DEFAULT_PRECIS = 0
Public Const DEFAULT_QUALITY = 0
Public Const DEFAULT_PITCH = 0
Public Const DEFAULT_CHARSET = 1
Public Const FF_DONTCARE = 0
Public Const LF_FACESIZE = 32
Public FontToUse&
Type LOGFONT
        lfHeight As Long
        lfWidth As Long
        lfEscapement As Long
        lfOrientation As Long
        lfWeight As Long
        lfItalic As Byte
        lfUnderline As Byte
        lfStrikeOut As Byte
        lfCharSet As Byte
        lfOutPrecision As Byte
        lfClipPrecision As Byte
        lfQuality As Byte
        lfPitchAndFamily As Byte
        lfFaceName(LF_FACESIZE) As Byte
End Type
Type RECT
        Left As Long
        Top As Long
        Right As Long
        Bottom As Long
End Type
Declare Function CreateFontIndirect& Lib "gdi32" Alias "CreateFontIndirectA" (lpLogFont As LOGFONT)
Declare Function SelectObject& Lib "gdi32" (ByVal hdc As Long, ByVal hObject As Long)
Declare Function GetClientRect& Lib "user32" (ByVal hwnd As Long, lpRect As RECT)
Declare Function DeleteObject& Lib "gdi32" (ByVal hObject As Long)
Declare Function TextOut Lib "gdi32" Alias "TextOutA" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal lpstring As String, ByVal nCount As Long) As Long

Public Sub TextRotate(Height As Integer, Width As Integer, Angle As Integer, Weight As Integer, Italic As Boolean, Underline As Boolean, StrikeOut As Boolean, FontName As String, SourcePic As PictureBox, Text As String, tX As Integer, tY As Integer)
    Dim lf As LOGFONT
    Dim oldhdc&
    Dim TempByteArray() As Byte
    Dim dl&, x%
    Dim ByteArrayLimit&
    Dim rc As RECT
    SourcePic.Cls
    If FontToUse <> 0 Then dl = DeleteObject(FontToUse)
    lf.lfHeight = Val(Height)
    lf.lfWidth = Val(Width)
    lf.lfEscapement = Val(Angle * 10)
    lf.lfWeight = Val(Weight)
    If Italic = True Then lf.lfItalic = 1
    If Underline = True Then lf.lfUnderline = 1
    If StrikeOut = True Then lf.lfStrikeOut = 1
    lf.lfOutPrecision = OUT_DEFAULT_PRECIS
    lf.lfClipPrecision = OUT_DEFAULT_PRECIS
    lf.lfQuality = DEFAULT_QUALITY
    lf.lfPitchAndFamily = DEFAULT_PITCH Or FF_DONTCARE
    lf.lfCharSet = DEFAULT_CHARSET
        TempByteArray = StrConv(FontName & Chr$(0), vbFromUnicode)
    ByteArrayLimit = UBound(TempByteArray)
    For x% = 0 To ByteArrayLimit
        lf.lfFaceName(x%) = TempByteArray(x%)
    Next x%
    FontToUse = CreateFontIndirect(lf)
    If FontToUse = 0 Then Exit Sub
    oldhdc = SelectObject(SourcePic.hdc, FontToUse)
    dl& = GetClientRect(SourcePic.hwnd, rc)
    dl& = TextOut(SourcePic.hdc, tX, tY, (Text), Len(Text))
    dl& = SelectObject(SourcePic.hdc, oldhdc)
End Sub

Public Sub EndRotate()
    Dim di&
    If FontToUse& <> 0 Then di = DeleteObject(FontToUse)
End Sub
