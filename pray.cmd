
start:
  put pray Eluned
  pause 1
  goto checkExp

checkExp:
  if $Theurgy.LearningRate >= 34 then goto end
  goto start

end:
  put #parse PRAY DONE
