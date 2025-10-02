'------- variables
xpos = 160
ypos = 160
v = 20 'change to change 'speed'

'------- initial circle
Circle xpos,ypos,10

'------- main loop
Do
k% = Asc(Inkey$)
 If k% = 128 Then GoSub up
 If k% = 129 Then GoSub dwn
 If k% = 130 Then GoSub lft
 If k% = 131 Then GoSub rgt
 If k% = 27 Then GoSub bye
Loop

'------- subs
up:
Circle xpos,ypos,10,,,RGB(black)
ypos = ypos - v
Circle xpos,ypos,10
End Sub

dwn:
Circle xpos,ypos,10,,,RGB(black)
ypos = ypos + v
Circle xpos,ypos,10
End Sub

lft:
Circle xpos,ypos,10,,,RGB(black)
xpos = xpos - v
Circle xpos,ypos,10
End Sub

rgt:
Circle xpos,ypos,10,,,RGB(black)
xpos = xpos + v
Circle xpos,ypos,10
End Sub

bye:
CLS
Print "goodbye"
End
End Sub
