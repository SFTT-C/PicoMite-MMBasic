CLS
Line 1,1,319,1,2,RGB(blue)
Print
Print "Calculator.  Q = quit."
ans=0
Do
  Input ">",e$
  If UCase$(e$)="Q" Then GoTo bye
  If e$="" Then Print ans:GoTo skip
  On error skip
  ans = Eval(e$)
  On error abort
  Print Str$(ans)
skip:
Loop
bye:
Print "Calculator Ended."
End
