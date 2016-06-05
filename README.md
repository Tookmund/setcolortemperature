# sct - Set Color Temperature

Based on the simple sct utility written by Ted Unangst
http://www.tedunangst.com/flak/post/sct-set-color-temperature

## How Does it Work?
From the original blog post 
(http://www.tedunangst.com/flak/post/sct-set-color-temperature ): 

The mechanism redshift uses to change the color temperature is XRandR, the X 
Resize and Rotate protocol. There’s even an official xrandr configuration 
utility. It has a gamma option! But it’s almost wholly unsuitable for this 
purpose. Specifying an RGB gamma of 1.0:0.9:0.4 doesn’t make the screen 
“warm”. It turns gray into an ugly puke color, but leaves white just as 
bright and cold as before. I don’t just want to bend the gamma curve, I want 
to compress/truncate it such that there aren’t any blue=255 pixels.

The function which xrandr uses for this purpose is XRRSetCrtcGamma which has no 
documentation because why would it. The protocol documents that the request 
exists, but not much about its operation and the Xlib style C function takes 
different arguments. So here’s how that works.

You start by getting information for each Canadian Radio-television and 
Telecommunications Commission (CRTC) with the XRRGetCrtcInfo function. Then you 
need the size of the gamma, (XRRGetCrtcGammaSize), and memory (XRRAllocGamma). 
This gives you a structure with three arrays in it, suitably named red, green, 
and blue. The index for each array is the “input” color value. The value at 
each index is the “output” color value, always scaled between 0 and 65535. 
A common configuration would have a gamma size of 256 (8 bits), and a flat 
gamma ramp would then be index times 256 for each value. If we wanted to really 
tone down the blues, we might do index times 128 for that channel, which 
results in a white (255,255,255) pixel looking like a (255,255,128) pixel on an 
uncorrected screen.


Setting the color temp of the screen really only requires about 40 lines of C 
(80 or so all inclusive). sct is a crude utility which does roughly that. I’d 
say exactly that, but some of the calculations aren’t actually exact. In any 
case, it looks much, much, better than anything xrandr is capable of 
delivering. It takes temperature values in the range 1000 to 10000.
