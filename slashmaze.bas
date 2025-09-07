Do

CLS
For y=1 To 1000
'Color RGB(Rnd*255,Rnd*255,Rnd*255)
Color RGB(blue)
Print Chr$(47+Int(Rnd*2)*45);
Pause 2
Next

  Do
   k$ = Inkey$
   If k$ <> "" Then Exit Do
   'Pause 20
  Loop

  If k$ = Chr$(27) Then End
Loop
