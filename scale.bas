CLS
Randomize Timer
Dim note(8)
note(1) = 262 'c
note(2) = 294 'd
note(3) = 330 'e
note(4) = 349 'f
note(5) = 392 'g
note(6) = 440 'a
note(7) = 494 'b
note(8) = 523 'c

ms$ = "CDEFGABC"

For i = 1 To Len(ms$)

  Print @(160,160)Mid$(ms$,i,1)
  Play tone note(i),note(i),200
  Pause 200

Next i

clrs

Sub clrs
CLS
Print "W-O to play, X quit, C clear"
Circle 300,300,5,7,,RGB(blue)
Circle 280,290,5,7,,RGB(blue)
Line 305,300,305,270,2,RGB(blue)
Line 285,290,285,270,2,RGB(blue)
Line 305,270,285,270,2,RGB(blue)
End Sub

Do
 a$=Inkey$
 If a$="w" Then nc
 If a$="e" Then nd
 If a$="r" Then ne
 If a$="t" Then nf
 If a$="y" Then ng
 If a$="u" Then na
 If a$="i" Then nb
 If a$="o" Then nc2
 If a$="x" Then End
 If a$="c" Then clrs
Loop

End

Sub nc2
cz = Int(Rnd*148)
cr = Int(Rnd*255)
cg = Int(Rnd*255)
cb = Int(Rnd*255)
Print @(292,277) "C";
Play tone 523,523,300
Circle 160,160,cz,3,,RGB(cr,cg,cb)
Pause 300
End Sub

Sub nb
cz = Int(Rnd*148)
cr = Int(Rnd*255)
cg = Int(Rnd*255)
cb = Int(Rnd*255)
Print @(292,277) "B";
Circle 160,160,cz,3,,RGB(cr,cg,cb)
Play tone 494,494,300
Pause 300
End Sub

Sub na
cz = Int(Rnd*148)
cr = Int(Rnd*255)
cg = Int(Rnd*255)
cb = Int(Rnd*255)
Print @(292,277) "A";
Circle 160,160,cz,3,,RGB(cr,cg,cb)
Play tone 440,440,300
Pause 300
End Sub

Sub ng
cz = Int(Rnd*148)
cr = Int(Rnd*255)
cg = Int(Rnd*255)
cb = Int(Rnd*255)
Print @(292,277) "G";
Circle 160,160,cz,3,,RGB(cr,cg,cb)
Play tone 392,392,300
Pause 300
End Sub

Sub nf
cz = Int(Rnd*148)
cr = Int(Rnd*225)
cg = Int(Rnd*255)
cb = Int(Rnd*255)
Print @(292,277) "F";
Circle 160,160,cz,3,,RGB(cr,cg,cb)
Play tone 349,349,300
Pause 300
End Sub

Sub ne
cz = Int(Rnd*148)
cr = Int(Rnd*255)
cg = Int(Rnd*255)
cb = Int(Rnd*255)
Print @(292,277) "E";
Circle 160,160,cz,3,,RGB(cr,cg,cb)
Play tone 330,330,300
Pause 300
End Sub

Sub nd
cz = Int(Rnd*148)
cr = Int(Rnd*255)
cg = Int(Rnd*255)
cb = Int(Rnd*255)
Print @(292,277) "D";
Circle 160,160,cz,3,,RGB(cr,cg,cb)
Play tone 294,294,300
Pause 300
End Sub

Sub nc
cz = Int(Rnd*148)
cr = Int(Rnd*255)
cg = Int(Rnd*255)
cb = Int(Rnd*255)
Print @(292,277) "C";
Circle 160,160,cz,3,,RGB(cr,cg,cb)
Play tone 262,262,300
Pause 300
End Sub
