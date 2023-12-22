#!/bin/octave 
%--norc, -f              Don't read any initialization files.
%--silent, --quiet, -q   Don't print message at startup.
printf ("octave run:>>>%s", program_name ());
arg_list = argv ();
for i = 1:nargin
  printf (" %s", arg_list{i});
endfor
printf ("\n"); 
