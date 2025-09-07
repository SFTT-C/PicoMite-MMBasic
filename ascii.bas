Dim a$
CLS

Print "Key values. ESC(27) to quit."
Do
a$ = Inkey$

If a$ <> "" Then
Print "Key: "; a$; ", ASCII: "; Asc(a$)
EndIf

Loop Until a$ = Chr$(27)

End
