CLS

d = 20
v = 1

Do
k = Asc(Inkey$)
 If k = 128 Then GoSub grow
 If k = 129 Then GoSub shrink
 If k = 130 Then v=v-1
 If k = 131 Then v=v+1
 If K = 27 Then GoSub bye
 GoSub hud
Loop

hud:
Print @(1,1) d"   "  v"    "
End Sub

grow:
Circle 160,160,d,1,,RGB(black)
d=d+v
Circle 160,160,d,1,,RGB(green)
End Sub

shrink:
Circle 160,160,d,1,,RGB(black)
d=d-v
Circle 160,160,d,1,,RGB(green)
End Sub

bye:
CLS
End
End Sub
