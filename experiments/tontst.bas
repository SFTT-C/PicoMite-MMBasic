
'exploring play tone

'controls :
'up,down,left,right,-,+,[,],esc

'play tone arguments :
'left, right, dur, interrupt

a = 300
b = 300
d = 88
p = 5

Do
c1 = Rnd*255
c2 = Rnd*255
c3 = Rnd*255
k$ = Inkey$

If k$ <> "" Then
 c% = Asc(k$)
 If c% = 128 Then a = a + 10
 If c% = 129 Then a = a - 10
 If c% = 27 Then GoSub BYE
 If c% = 130 Then b = b - 10
 If c% = 131 Then b = b + 10
 If c% = 45 Then d = d - 1
 If c% = 61 Then d = d + 1
 If c% = 91 Then p = p - 1
 If c% = 93 Then p = p + 1
EndIf

If a > 1200 Then a = 1200
If a < 150 Then a = 150
If b < 150 Then b = 150
If b > 1200 Then b = 1200
If p > 200 Then p = 200
If p < 1 Then p = 1
EndIf

Circle 160,160,a-250,1,1,RGB(c1,c2,c3)
Circle 160,160,b-250,1,1,RGB(c1,c2,c3)
Box 9,9,75,44,,RGB(c1,c2,c3),1

Play tone a,b,d
Print @(10,10) "L" a "   "
Print @(10,20) "R" b "    "
Print @(10,30) "D" d "    "
Print @(10,40) "P" p "    "
Pause p
Loop

BYE:
CLS
Print @(10,10) "CYA LATER"
Print @(10,20) "         "
End
endsub
