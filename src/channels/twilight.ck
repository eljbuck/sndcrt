// sound file to load; me.dir() returns location of this file
me.dir() + "narrative/twilight.wav" => string filename;

global Gain in;

// the patch 
SndBuf buf => in;
// load the file
filename => buf.read;
// set gain
0.05 => buf.gain;

// time loop
while( true )
{
    // set playback position to beginning
    0 => buf.pos;
    // advance time
    23::second  => now;
}
