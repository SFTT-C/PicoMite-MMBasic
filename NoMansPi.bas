CLS


GoSub initiate

ll = 0
red = rd
grn = gr
blu = bl
plx = px
ply = py
ld = 0
pz = pd

Do
a$ = Inkey$
If a$="h" And ld=0 Then GoSub launch
 EndIf
If a$ = "q" Then End
 EndIf
If a$ = "s" Then GoSub scan
EndIf
If ll <> 0 And ld = 0 And a$ = "l" Then
GoSub land
EndIf
If ld = 1 And a$ = "l" Then
  GoSub blast
EndIf
Loop

launch:
For l = 0 To 1000
fr = 300+l
co = RGB(Rnd*255,Rnd*255,Rnd*255)
Line 160,160,Rnd*319,Rnd*319,1,co
Play tone fr,fr,3
Next l
For c = 0 To 225
fr2 = 800-c
Circle 160,160,c,3,,RGB(black)
Play tone fr2,fr2,3
Next c
GoSub initiate
End Sub

initiate:
CLS
ll = 0
en = Int(Rnd*11)
For start = 0 To 1000
Pixel Rnd*319,Rnd*319,RGB(white)
Pause 0.2
Next start
Box 1,270,319,319,1,RGB(black),f
Box 1,270,319,319,1,RGB(gray)
Box 140,272,40,45,2,RGB(white)
Box 141,273,37,22,11,RGB(blue)
Box 142,294,36,22,11,RGB(orange)
Line 141,292,178,292,2,RGB(white)
Line 150,282,170,282,1,RGB(white)
Line 155,287,165,287,1,RGB(white)
Line 155,298,165,298,1,RGB(white)
Line 150,303,170,303,1,RGB(white)
Circle 200,280,5,5,,RGB(green)
Circle 220,280,5,5,,RGB(orange)
Circle 240,280,5,5,,RGB(green)
Circle 260,280,5,5,,RGB(red)
Pause 30
If en > 5 Then
  GoSub planet
EndIf
Print @(2,271)"H - Hyperspace"
Print @(2,284)"Q - Quit"
Print @(2,297)"S - Scan";
End Sub

planet:
ll = 1
px = Rnd*319
py = Rnd*200
pd = Int(Rnd*(30-10+1))+10
rd = Rnd*255
gr = Rnd*255
bl = Rnd*255
Circle px,py,pd,30,,RGB(rd,gr,bl)
Print @(1,1)"Planet Observed!"
For alt = 0 To 10 Step 2
Play tone 440,440,50
Pause 100
Next alt
Print @(190,300)"L - Land";
red = rd
grn = gr
blu = bl
plx = px
ply = py
pz = pd
End Sub

scan:
lf = ll
If lf <> 0 Then
  For scn = 0 To 10 Step 2
Play tone 600+(scn*10),600+(scn*10),50
Pause 100
  Next scn
  Line 1,1,200,1,11,RGB(black)
  Print @(1,1)"Scan reveals lifesigns."
EndIf
If lf = 0 Then
  For scn = 0 To 10 Step 2
Play tone 600-(scn*10),600-(scn*10),50
 Pause 100
 Next scn
 Line 1,1,200,1,11,RGB(black)
 Print @(1,1)"Nothing found."
EndIf
End Sub

land: 'edit for more detail
ld = 1
For ldg = 0 To 340
Circle plx,ply,ldg,2,,RGB(red,grn,blu)
Play tone 600,600,3
Next ldg
CLS
Line 0,270,319,270,100,RGB(red,grn,blu)
a$ = ""
Print @(130,300)"L - Leave Planet"
End Sub

blast:
CLS
Box 0,0,319,319,1,2,RGB(red,grn,blu)
For ldg = 0 To 340
Circle plx,ply,340-ldg+pd,2,,RGB(black)
Play tone 400+ldg,400+ldg,50
Next ldg
Pause 30
ld = 0
GoSub initiate
End Sub
