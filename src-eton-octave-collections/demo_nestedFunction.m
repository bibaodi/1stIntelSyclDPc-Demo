# https://docs.octave.org/v4.2.1/Nested-Functions.html
function y = foo (a)
  x = a;
  bar ();
  y = x;

  function bar ()
    x = x+1000;
  endfunction
endfunction


#{
#runnable nexted function from matlab
function parent
disp('This is the parent function')
nestedfx
   function nestedfx
      disp('This is the nested function')
   end

end
#}
###################################
#{
xsixth(3)
function z  = xsixth(x)
a = [];
xsquare(x);
z = a.^3;
   function xsquare(b)
   a = b.^2
   end
end
#}
#{
function [z y] = xsixth(x)
    z = xsquare(x).^3;
    y = xsquare(x);
    function a = xsquare(b)
        a = b.^2;
    endfunction
endfunction
#}
