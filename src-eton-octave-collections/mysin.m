#! /bin/octave -qf
#This can be called from the shell with
#mysin.m 1.5
#or from Octave with
#mysin (1.5)
function retval = mysin (x = str2double (argv(){end}))
  retval = sin (x)
endfunction
