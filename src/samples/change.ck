// sound file to load; me.dir() returns location of this file
me.dir() + "narrative/change.wav" => string filename;

global Gain in;

// the patch 
SndBuf buf => in;
// load the file
filename => buf.read;
// set gain
0.035 => buf.gain;

// time loop
while( true )
{
    // set playback position to random location in file
    buf.phaseOffset(Math.random2f(0, 1));
    // advance time
    9::second  => now;
}
