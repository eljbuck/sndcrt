//——————————————————————————
// name: sndcrt.ck
// desc: visualizer on an old timey CRT TV, which builds on and adapts the
// sndpeek.ck implementation by Ge Wang and Andrew Zhu Aday.
// 
// author: Ethan Buck
//
// date: 10/13/2023
// —————————————————————————

// window size
256 => int WINDOW_SIZE;
// number of history lines in TV
49 => int STATIC_FFT_HEIGHT;
// amplitude of time domain
float WAV_AMPLITUDE;
// time it takes to complete one cycle
1.98::second => dur wavCycleTime;
// default amplitude factor of freq domain
.5 => float SPEC_AMPLITUDE_FACTOR;
// default multiplier for time domain 
4 => float WAV_FACTOR;
// static noise gain
.005 => float STATIC_GAIN;
// global gain
global Gain in => PoleZero pz => dac;

.85 => pz.blockZero;

// SCENE SET UP ////////////////////////////////////////////////////////////
GG.camera() --> GGen dolly --> GG.scene();
// position
GG.camera().posZ( 10 );
// change camera perspective
GG.camera().orthographic();

// set bg color
GG.scene().backgroundColor( @(0, 0, 0) );

// RECTANGLE CLASS /////////////////////////////////////////////////////////
// allows setting a border around rectangle (must be set AFTER scaling)
class Rectangle extends GGen
{
    GPlane main --> this;
    
    // set color of main rectangle
    fun void color ( vec3 c )
    {
        main.mat().color(c);
    }
    
    // set scale of main rectangle
    fun void scale ( vec3 s) 
    {
        main.sca( s );
    }
    
    // GPlane outline;
    fun void outline( float width, vec3 c )
    {
        GPlane outline --> main;
        FlatMaterial outlineMat;
        outline.sca( @(1 + width * main.scaY(), 1 + width * main.scaX(), 1) );
        outline.mat(outlineMat);
        outline.mat().color( c );
    }
}

// CIRCLE CLASS //////////////////////////////////////////////////////////
// allows setting a border around circle (must be set AFTER scaling)
class Circle extends GGen
{
    GCircle main --> this;
    
    // set color of main rectangle
    fun void color ( vec3 c )
    {
        main.mat().color(c);
    }
    
    // set scale of main rectangle
    fun void scale ( vec3 s) 
    {
        main.sca( s );
    }
    
    // GPlane outline;
    fun void outline( float width, vec3 c )
    {
        GCircle outline --> main;
        FlatMaterial outlineMat;
        outline.sca( @(1 + width * main.scaY(), 1 + width * main.scaX(), 1) );
        outline.mat(outlineMat);
        outline.mat().color( c );
    }
}

// KNOB CLASS //////////////////////////////////////////////////////////////////
// creates TV knob geometry
class Knob extends GGen
{
    Circle circle --> this;
    Rectangle rect --> circle;
    rect.scale( @(.66, 2.3, 1) );
    rect.posZ(.01);
    GPlane marker --> rect;
    marker.posZ(.01);
    marker.posY(.99);
    marker.mat().color( @(0, 0, 0) );
    marker.sca( @(.15, .35, 0) );
    fun void color (vec3 c)
    {
        circle.color(c);
        rect.color(c);
    }
    fun void rotate (float degree) 
    {
        circle.rotZ(degree);
    }
    
    fun void border( float width, vec3 c) {
        circle.outline(width / 1.25, c);
        rect.outline(width, c);
    }
}

// TV CONSTRUCTION ///////////////////////////////////////////////////////////////
// set nonreflective material
FlatMaterial TVMaterial;

// outer box
GPlane box --> GG.scene(); 
box.mat().color( @(1, 1, 1) );
box.sca( @(4.5, 3, 1) );
box.mat(TVMaterial);

// top shield
GPlane shield --> box;
shield.mat().color( @(0, 0, 0) );
shield.posZ(.5);
shield.posY(1);
shield.sca( @(1, 1, 0) );

// speaker bar line
GPlane bar1 --> box;
bar1.mat().color( @(0, 0, 0) );
bar1.posZ(.5);
bar1.posX(.378);
bar1.posY(-.14);
bar1.sca( @(.2, .013, 0) );

// speaker bar line 2
GPlane bar2 --> bar1;
bar2.mat().color( @(0, 0, 0) );
bar2.posY(-2.5);
bar2.sca( @(1, 1, 0) );

// speaker bar line 3
GPlane bar3 --> bar2;
bar3.mat().color( @(0, 0, 0) );
bar3.posY(-2.5);
bar3.sca( @(1, 1, 0) );

// speaker bar line 4
GPlane bar4 --> bar3;
bar4.mat().color( @(0, 0, 0) );
bar4.posY(-2.5);
bar4.sca( @(1, 1, 0) );

// speaker bar line 5
GPlane bar5 --> bar4;
bar5.mat().color( @(0, 0, 0) );
bar5.posY(-2.5);
bar5.sca( @(1, 1, 0) );

// speaker bar line 6
GPlane bar6 --> bar5;
bar6.mat().color( @(0, 0, 0) );
bar6.posY(-2.5);
bar6.sca( @(1, 1, 0) );

// speaker bar line 5
GPlane bar7 --> bar6;
bar7.mat().color( @(0, 0, 0) );
bar7.posY(-2.5);
bar7.sca( @(1, 1, 0) );

// speaker bar line 5
GPlane bar8 --> bar7;
bar8.mat().color( @(0, 0, 0) );
bar8.posY(-2.5);
bar8.sca( @(1, 1, 0) );

// speaker bar line 5
GPlane bar9 --> bar8;
bar9.mat().color( @(0, 0, 0) );
bar9.posY(-2.5);
bar9.sca( @(1, 1, 0) );

// inner monitor
GPlane monitor --> box;
monitor.mat().color( @(0, 0, 0) );
monitor.posZ(.4);
monitor.posY(0);
monitor.posX(-.09);
monitor.sca( @(.7, .83, 0) );

// off screen
GPlane off_screen --> monitor;
off_screen.mat().color( @(1, 0, 0) );
off_screen.posZ(.5);
off_screen.sca( @(1, 1, 1) );

// dial box
Rectangle dialBorder --> box;
dialBorder.color( @(1, 1, 1) );
dialBorder.posZ(3);
dialBorder.posY(.16);
dialBorder.posX(.38);
dialBorder.scale( @(.2, .5, 1) );
dialBorder.outline(.1, @(0, 0, 0) );

// channel knob
Knob ch_knob --> dialBorder;
ch_knob.color( @(1, 1, 1) );
ch_knob.posZ(4);
ch_knob.posY(.12);
ch_knob.rotate(-Math.pi / 2);
ch_knob.sca( @(.06, .08, 1) );
ch_knob.border(.1, @(0, 0, 0));

// channel cnotch 1
GCircle cnotch1 --> dialBorder;
cnotch1.posZ(5);
cnotch1.posX(-.083);
cnotch1.posY(.12);
cnotch1.mat().color( @(0, 0, 0) );
cnotch1.sca( @(.005, .0075, 1) );

// channel cnotch 2
GCircle cnotch2 --> dialBorder;
cnotch2.posZ(5);
cnotch2.posX(-0.072);
cnotch2.posY(0.175);
cnotch2.mat().color( @(0, 0, 0) );
cnotch2.sca( @(.005, .0075, 1) );

// channel cnotch 3
GCircle cnotch3 --> dialBorder;
cnotch3.posZ(5);
cnotch3.posX(-0.042);
cnotch3.posY(0.215);
cnotch3.mat().color( @(0, 0, 0) );
cnotch3.sca( @(.005, .0075, 1) );

// channel cnotch 4
GCircle cnotch4 --> dialBorder;
cnotch4.posZ(5);
cnotch4.posY(.232);
cnotch4.mat().color( @(0, 0, 0) );
cnotch4.sca( @(.005, .0075, 1) );

// channel cnotch 5
GCircle cnotch5 --> dialBorder;
cnotch5.posZ(5);
cnotch5.posX(0.042);
cnotch5.posY(0.215);
cnotch5.mat().color( @(0, 0, 0) );
cnotch5.sca( @(.005, .0075, 1) );

// channel cnotch 6
GCircle cnotch6 --> dialBorder;
cnotch6.posZ(5);
cnotch6.posX(0.072);
cnotch6.posY(0.175);
cnotch6.mat().color( @(0, 0, 0) );
cnotch6.sca( @(.005, .0075, 1) );

// channel cnotch 7
GCircle cnotch7 --> dialBorder;
cnotch7.posZ(5);
cnotch7.posX(.083);
cnotch7.posY(.12);
cnotch7.mat().color( @(0, 0, 0) );
cnotch7.sca( @(.005, .0075, 1) );

// channel cnotch 8
GCircle cnotch8 --> cnotch6;
cnotch8.posY(-15.5);
cnotch8.mat().color( @(0, 0, 0) );

// channel cnotch 9
GCircle cnotch9 --> cnotch5;
cnotch9.posY(-25.5);
cnotch9.mat().color( @(0, 0, 0) );

// channel cnotch -1
GCircle cnotchn1 --> cnotch2;
cnotchn1.posY(-15.5);
cnotchn1.mat().color( @(1, 0, 0) );

// vol knob
Knob vol_knob --> dialBorder;
vol_knob.color( @(1, 1, 1) );
vol_knob.posZ(4);
vol_knob.posY(-.12);
vol_knob.rotate(-Math.pi / 2);
vol_knob.sca( @(.06, .08, 1) );
vol_knob.border(.1, @(0, 0, 0));

// vnotch 1
GCircle vnotch1 --> dialBorder;
vnotch1.posZ(5);
vnotch1.posX(-.083);
vnotch1.posY(-.12);
vnotch1.mat().color( @(0, 0, 0) );
vnotch1.sca( @(.005, .0075, 1) );

// vnotch 2
GCircle vnotch2 --> dialBorder;
vnotch2.posZ(5);
vnotch2.posX(-0.072);
vnotch2.posY(-0.065);
vnotch2.mat().color( @(0, 0, 0) );
vnotch2.sca( @(.005, .0075, 1) );

// vnotch 3
GCircle vnotch3 --> dialBorder;
vnotch3.posZ(5);
vnotch3.posX(-0.04);
vnotch3.posY(-0.025);
vnotch3.mat().color( @(0, 0, 0) );
vnotch3.sca( @(.005, .0075, 1) );

// vnotch 4
GCircle vnotch4 --> dialBorder;
vnotch4.posZ(5);
vnotch4.posY(-.01);
vnotch4.mat().color( @(0, 0, 0) );
vnotch4.sca( @(.005, .0075, 1) );

// vnotch 5
GCircle vnotch5 --> dialBorder;
vnotch5.posZ(5);
vnotch5.posX(0.04);
vnotch5.posY(-0.025);
vnotch5.mat().color( @(0, 0, 0) );
vnotch5.sca( @(.005, .0075, 1) );

// vnotch 6
GCircle vnotch6 --> dialBorder;
vnotch6.posZ(5);
vnotch6.posX(0.072);
vnotch6.posY(-0.065);
vnotch6.mat().color( @(0, 0, 0) );
vnotch6.sca( @(.005, .0075, 1) );

// vnotch 7
GCircle vnotch7 --> dialBorder;
vnotch7.posZ(5);
vnotch7.posX(.083);
vnotch7.posY(-.12);
vnotch7.mat().color( @(0, 0, 0) );
vnotch7.sca( @(.005, .0075, 1) );

// antenna housing
GCircle antennaHousing --> box;
antennaHousing.mat().color( @(1, 1, 1) );
antennaHousing.posZ(2);
antennaHousing.posY(.51);
antennaHousing.sca( @(.06, .05, 1) );

// antennaL
GPlane antennaL --> box;
antennaL.mat().color( @(1, 1, 1) );
antennaL.sca( @(.007, .4, 0) );
antennaL.posZ(3);
antennaL.posY(.73);
antennaL.posX(-.1);
antennaL.rotZ(-.4);
antennaL.mat(TVMaterial);

// antennaL bulb
GCircle bulbL --> antennaL;
bulbL.mat().color( @(1, 1, 1) );
bulbL.sca(@(1.5, .03, 1));
bulbL.posY(.5);
bulbL.mat(TVMaterial);

// antennaR
GPlane antennaR --> box;
antennaR.mat().color( @(1, 1, 1) );
antennaR.sca( @(.007, .4, 0) );
antennaR.posZ(3);
antennaR.posY(.73);
antennaR.posX(.1);
antennaR.rotZ(.4);
antennaR.mat(TVMaterial);

// antennaL bulb
GCircle bulbR --> antennaR;
bulbR.mat().color( @(1, 1, 1) );
bulbR.sca(@(1.5, .03, 1));
bulbR.posY(.5);
bulbR.mat(TVMaterial);

// StaticFFT CLASS ////////////////////////////////////////////////////////////
// custom GGen to render tv static
class StaticFFT extends GGen
{
    // static playhead
    0 => int playhead;
    // lines
    GLines sfft[STATIC_FFT_HEIGHT];
    // color
    @(1, 1, 1) => vec3 color;
    
    LineMaterial lineMaterial;
    
    
    // iterate over line GGens
    for( GLines s : sfft )
    {
        // aww yea, connect as a child of this GGen
        s --> this;
        // color
        s.mat().color( @(.4, 1, .4) );
        s.mat(lineMaterial);
    }
    
    // copy
    fun void latest( vec3 positions[] )
    {
        // set into
        positions => sfft[playhead].geo().positions;
        // advance playhead
        playhead++;
        // wrap it
        STATIC_FFT_HEIGHT %=> playhead;
    }
    
    // update
    fun void update( float dt )
    {
        // position
        playhead => int pos;
        // so good
        for( int i; i < sfft.size(); i++ )
        {
            // start with playhead-1 and go backwards
            pos--; if( pos < 0 ) STATIC_FFT_HEIGHT-1 => pos;
            // offset Y
            i => float offset;
            sfft[pos].posY( offset / 12 );
            
        }
    }
}

// INPUT SET UP ///////////////////////////////////////////////////////////////////
// adc => Gain input;
dac => Gain input;
Noise n1 => Envelope glitch_noise => input => dac; STATIC_GAIN => n1.gain;
// accumulate samples from mic
input => PoleZero dcblokewav => Flip accum => blackhole;
// dc bloke for waveform
.5 => dcblokewav.blockZero;
// take the FFT
input => PoleZero dcbloke => FFT fft => blackhole;
// set DC blocker
.95 => dcbloke.blockZero;
// set size of flip
WINDOW_SIZE => accum.size;
// set window type and size
Windowing.hann(WINDOW_SIZE) => fft.window;
// set FFT size (will automatically zero pad)
WINDOW_SIZE*2 => fft.size;
// get a reference for our windwo for visual tapering of the waveform
Windowing.hann(WINDOW_SIZE) @=> float window[];

// instantiate waveform
GLines waveform --> GG.scene(); waveform.mat().lineWidth(1.0);
// color waveform
waveform.mat().color( @(.302,.976,1) );
waveform.posZ(.51);

// instantiate static lines
StaticFFT staticLines --> GG.scene();
// position in monitor
staticLines.posY( -1.35 );
staticLines.posZ(.49);
staticLines.posX(-.35);
staticLines.sca( @(.65, .64, 1) );

// sample array
float samples[0];
// FFT response
complex response[0];
// a vector to hold positions
vec3 positions[WINDOW_SIZE];


// complete one cycle of animation
fun void waveform_cycle() 
{
    now + wavCycleTime => time end;
    while (now < end) {
        // percentage (from 0 to 1) through cycle time
        1 - (end-now)/wavCycleTime => float progress;
        // calculate x scale factor
        0.82 * progress + 0.18 => float x_scale;
        // scale x position
        waveform.sca( @(x_scale, 1, 1) );
        // calculate y position offset
        1.06 * progress + 1.68 => float y_pos;
        // translate y position
        waveform.posY(y_pos);
        WAV_FACTOR * progress + .1 => WAV_AMPLITUDE;
        10::ms => now;
    }
}

// sporks animation to timeline
fun void animate_waveform()
{
    while(true)
    {
        waveform_cycle();
        // linger at top
        250::ms => now;
    }
}
spork ~ animate_waveform();

// generic glitch function that temporarily inserts noise and cancels all other
// sounds for a given time
fun void glitch(Envelope n, float t) {
    // glitch
    n.keyOn();
    // silence background
    in.gain(0);
    // wait t ms
    t::ms => now;
    // stop glitch
    n.keyOff();
    // resume background
    in.gain(1);
}

// keeps track of channel position
0 => int ch_pos;
// keeps track of ID of channel change click sound effect
int change_click;
// keeps track of ID of channel change sound effect
int change;
// keeps track of ID of the machine added shred
int current;

// variable glitches that increase in length, volume, and frequency as the 
// channel position increases (very hacky not elegant)
fun void glitch_two(Envelope n) 
{
    while (true) 
    {
        if (ch_pos < 8 && ch_pos != 0) {
            Math.random2f(4, 6)::second => now;
            Math.random2(1, 3) => int num;
            for (0 => int i; i < num; 1 +=> i) {
                Math.random2f(75, 250) => float t;
                glitch(n, t);
                <<< "glitch 1" >>>;
                100::ms => now;
            }
        } else if (ch_pos == 8) {            
            // wait random amount of time
            Math.random2f(4, 8)::second => now;
            Math.random2f(300, 600) => float t;
            glitch(n, t);
            <<< "glitch 2" >>>;
        } else if (ch_pos == 9) {
            n1.gain(.0075);
            Math.random2f(2, 5)::second => now;
            Math.random2f(400, 700) => float t;
            glitch(n, t);
            <<< "glitch 3" >>>;
        } else if (ch_pos == 10) {
            n1.gain(.01);
            Math.random2f(1, 3)::second => now;
            Math.random2f(400, 900) => float t;
            glitch(n, t);
            <<< "glitch 4" >>>;
        } else {
            33::ms => now;   
        }
    }
}
spork ~ glitch_two(glitch_noise);

// function for stalled start after turning on
fun void start(Envelope n)
{
    1.5::second => dur stall;
    now + stall => time end;
    while (now < end) {
        glitch_noise.keyOn();
        10::ms => now;
    }
    glitch_noise.keyOff();
}

// function for static hold at end of narrative
fun void boom(Envelope n)
{
    while (true) {
        if (ch_pos == 11) {
            n.keyOn();
            if (current != 0) {
                Machine.remove(current);
                0 => current;
            }
            in.gain(0);
            33::ms => now;
        } else {
            33::ms => now;
        }
    }
}
spork ~ boom(glitch_noise);

// turn vol knob and increase amplitude sensitivity for wav and fft
0 => int vol_pos;
fun void inc_vol()
{
    if (vol_pos < 6) {
        vol_knob.rotate(Math.pi / 6);
        2 +=> WAV_FACTOR;
        3 +=> SPEC_AMPLITUDE_FACTOR;
        1 +=> vol_pos;
    }    
}

// turn vol knob and decrease amplitude sensitivity for wav and fft
fun void dec_vol()
{
    if (vol_pos > 0) {
        vol_knob.rotate(-Math.pi / 6);
        2 -=> WAV_FACTOR;
        3 -=> SPEC_AMPLITUDE_FACTOR;
        1 -=> vol_pos;
    }
}

// sound effect for channel change (click and static)
fun void channel_click() {
    Machine.add("change_click.ck") => change_click;
    50::ms => now;
    glitch_noise.gain() => float temp;
    glitch_noise.gain(.0025);
    glitch_noise.keyOn();
    Machine.add("change.ck") => change;
    650::ms => now;
    glitch_noise.keyOff();
    glitch_noise.gain(temp);
    Machine.remove(change);
    Machine.remove(change_click);
}

// control flow for channel navigation
fun void switch_ch() {
    channel_click();
    if (ch_pos == 0) {
        if (current != 0) {
            Machine.remove(current);
        }
        0 => current;
    } else if (ch_pos == 1) {
        if (current != 0) {
            Machine.remove(current);
        } else {
            start(glitch_noise);
        }
        Machine.add("twilight.ck") => current;
    } else if (ch_pos == 2) {
        Machine.remove(current);
        Machine.add("asimov.ck") => current;
    } else if (ch_pos == 3) {
        Machine.remove(current);
        Machine.add("transistor.ck") => current;
    } else if (ch_pos == 4) {
        Machine.remove(current);
        Machine.add("computermusic.ck") => current;
    } else if (ch_pos == 5) {
        Machine.remove(current);
        Machine.add("popeye.ck") => current;
    } else if (ch_pos == 6) {
        Machine.remove(current);
        Machine.add("osc.ck") => current;
    } else if (ch_pos == 7) {
        Machine.remove(current);
        Machine.add("mtv.ck") => current;
    } else if (ch_pos == 8) {
        Machine.remove(current);
        Machine.add("daisy.ck") => current;
    } else if (ch_pos == -1) {
        if (current != 0){
            Machine.remove(current);   
        }
        adc => input;
    }
    <<< "current:", current >>>;
}

// turn ch knob left and change channel accordingly
fun void inc_ch()
{
    if (ch_pos < 8) {
        ch_knob.rotate(Math.pi / 6);
        1 +=> ch_pos;
        switch_ch();
    } else if (ch_pos < 11) {
        // hacky triggering of increasing static for sound narrative lol
        1 +=> ch_pos;
    }
    <<< "ch_pos: ", ch_pos >>>;
}

// turn ch knob right and change channel accordingly
fun void dec_ch()
{
    if (ch_pos > -1 && ch_pos < 9) {
        ch_knob.rotate(-Math.pi / 6);
        1 -=> ch_pos;
        switch_ch();
    } else if (ch_pos > 8) {
        1 -=> ch_pos;
    }
    <<< "ch_pos: ", ch_pos >>>;
}

// detect up/down keys:
fun void detect_vol_arrows()
{
    while (true) 
    {
        if ( KB.isKeyDown(KB.KEY_UP) )
        {
            inc_vol();
        }
        if ( KB.isKeyDown(KB.KEY_DOWN) )
        {
            dec_vol();
        }
        200::ms => now;
    }
}
spork ~ detect_vol_arrows();

// detect right/left keys:
fun void detect_ch_arrows()
{
    while (true)
    {
        if (KB.isKeyDown(KB.KEY_RIGHT) )
        {
            inc_ch();
        }
        if ( KB.isKeyDown(KB.KEY_LEFT) )
        {
            dec_ch();
        }
        200::ms => now;
    }
}
spork ~ detect_ch_arrows();

// map audio buffer to 3D positions
fun void map2waveform( float in[], vec3 out[] )
{
    if(in.size() != out.size() )
    {
        <<< "size mismatch in map2waveform()", "">>>;
        return;
    }
    // mapping to xyz coordinate
    int i;
    1.55 => float width;
    for( auto s: in )
    {
        // space evenly in X
        -width/2 + width/WINDOW_SIZE*i => out[i].x;
        // map frequency bin magnitude in Y
        s*WAV_AMPLITUDE*window[i] => out[i].y;
        // constant 0 for Z here
        0 => out[i].z;
        // increment
        i++;
    }
}

// map FFT output to 3D positions
fun void map2spectrum( complex in[], vec3 out[] )
{
    if( in.size() != out.size() )
    {
        <<< "size mismatch in map2spectrum()", "" >>>;
        return;
    }
    
    // mapping to xyz coordinate
    int i;
    5.0 => float width;
    for( auto s : in )
    {
        // space evenly in X
        -width/2 + width/WINDOW_SIZE*i => out[i].x;
        // map frequency bin magnitide in Y        
        SPEC_AMPLITUDE_FACTOR * Math.sqrt( (s$polar).mag * 5 ) => out[i].y;
        // constant 0 for Z
        0 => out[i].z;
        // increment
        i++;
    }
    
    staticLines.latest( out );
}

//do audio stuff
fun void doAudio()
{
    while ( true )
    {
        // upchuck to process accum
        accum.upchuck();
        // get the last window size samples (waveform)
        accum.output( samples );
        // upchuck to take FFT, get magnitude reposne
        fft.upchuck();
        // get spectrum (as complex values)
        fft.spectrum( response );
        //jump by samples
        WINDOW_SIZE::samp/2 => now;
    }
}
spork ~ doAudio();

// time/graphics loop
while ( true )
{
    // detect if TV is on
    if (ch_pos != 0) {
        waveform --> GG.scene();
        staticLines --> GG.scene();
        // map to interleaved format
        map2waveform( samples, positions);
        // set to the mesh position
        waveform.geo().positions( positions );
        // map to spectrum display
        map2spectrum( response, positions );
    } else { // otherwise turn TV off
        waveform --< GG.scene();
        staticLines --< GG.scene();
    }
    // next graphics frame
    GG.nextFrame() => now;
    
}