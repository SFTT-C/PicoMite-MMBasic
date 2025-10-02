px = 160
py = 160
v = 5

Do
k% = Asc(Inkey$)
 If k% = 128 Then GoSub up
 If K% = 129 Then GoSub down
 If k% = 130 Then GoSub left
 If k% = 131 Then GoSub right
 If k% = 27 Then GoSub bye
Loop

up:
Pixel px,py,RGB(black)
py = py - v
Pixel px,py,RGB(green)
End Sub

down:
Pixel px,py,RGB(black)
py = py + v
Pixel px,py,RGB(green)
End Sub

left:
Pixel px,py,RGB(black)
px = px - v
Pixel px,py,RGB(green)
End Sub

right:
Pixel px,py,RGB(black)
px = px + v
Pixel px,py,RGB(green)
End Sub

bye:
CLS
End
End Sub
