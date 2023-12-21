icpx -fsycl ./show_platforms.cpp

test $? -eq 0 && ./a.out
