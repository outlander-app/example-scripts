#echo %0
top:
  if_1 then {
    move %1
    shift
    goto top
  }

end:
  put #parse YOU HAVE ARRIVED