#eton@240123 octave create a video;
# ref:https://octave.sourceforge.io/video/overview.html
# pkg install ../video-2.1.1.tar.gz
# pkg install "https://github.com/Andy1978/octave-video/releases/download/2.1.1/video-2.1.1.tar.gz"

pkg load video;

fn = fullfile (tempdir(), "sombrero.mp4");
w = VideoWriter (fn);
open (w);

z = sombrero ();
hs = surf (z);
axis manual
nframes = 100;
for ii = 1:nframes
    set (hs, "zdata", z * sin (2*pi*ii/nframes + pi/5));
    drawnow
    writeVideo (w, getframe (gcf));
endfor
close (w)
printf ("Now run '%s' in your favourite video player or try 'demo VideoReader'!\n", fn);
