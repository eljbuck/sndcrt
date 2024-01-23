global Gain in;

1.25 => float gain_mult;

// times that daisy bell has been played
0 => global int DAISY_COUNT;

[ 79, 76, 72, 67, 69, 71, 72, 69, 72, 67,
74, 79, 76, 72, 69, 71, 72, 74, 76, 74, 76,
77, 76, 74, 79, 76, 74, 72, 74,
76, 72, 69, 72, 69, 67, 67,
72, 76, 74, 67, 72, 76, 74, 76, 77, 79, 76, 72, 74, 67, 72 ]
@=> int melody[];

[ .99, .99, .99, .99, .33, .33, .33, .66, .33, 1.98,
.99, .99, .99, .99, .33, .33, .33, .66, .33, 1.65, .33,
.33, .33, .33, .66, .33, .33, 1.32, .33, .66, .33, .66, .33, .33, 1.32, .33,
.66, .33, .66, .33, .66, .33, .33, .33, .33, .33, .33, .33, .66, .33, 1.98]
@=> float melody_time[];

[ 55, 56, 57, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 60,
55, 56, 57, 55, 56, 57, 57, 59, 57, 56, 58, 56, 
55, 56, 57, 55, 56, 55, 54, 56, 55, 54, 53, 54, 55, 56, 55, 53,
52, 55, 56, 64, 55, 56, 62, 55, 56, 65, 64, 62, 60, 58, 56 ]
@=> int counter_mel[];

[ 1.32, .33, .33, 0.495, 0.495, .33, .33, .33, 0.495, 0.495, 0.495, 0.495, .99, .99,
1.32, .33, .33, 1.32, .33, .33, .99, 0.495, 0.495, .99, 0.495, 0.495,
1.32, .33, .33, 1.32, .33, .33, .99, .33, .33, .33, 0.825, .0825, .0825, .33, .33, .33,
.66, .33, .66, .33, .99, .66, .33, .99, .66, .33, 0.495, 0.495, .33, .33, .33 ]
@=> float counter_mel_time[];

[ 36, 31, 36, 31, 29, 36, 36, 31,
31, 38, 36, 31, 38, 33, 31, 38,
43, 38, 36, 31, 29, 36, 36, 31, 
36, 31, 36, 31, 36, 31, 36 ] @=> int bass[];

[ .99, .99, .99, .99, .99, .99, .99, .99, 
.99, .99, .99, .99, .99, .99, .99, .99, 
.99, .99, .99, .99, .99, .99, .99, .99,
.99, .99, .99, .99, .99, .99, 1.98 ] @=> float bass_time[];

[ 1, 1, 1, 1, 4, 4, 1, 1, 
5, 5, 1, 1, 2, 2, 6, 5, 
5, 5, 1, 1, 4, 4, 1, 5, 
1, 5, 1, 5, 1, 5, 1, 1 ] @=> int chords[];

PitShift ps; ps.effectMix(0);

TriOsc mel => ps => Envelope mel_env => in; mel.gain(.004 * gain_mult);
SinOsc hmel => mel_env; hmel.gain(.004 * gain_mult);
SinOsc hhmel => mel_env; hhmel.gain(.0015 * gain_mult);
SawOsc hhhmel => Envelope hhhmel_env => in; hhhmel.gain(.0035 * gain_mult);

SawOsc ba => Envelope bass_env => in;

TriOsc counter => Envelope counter_env => in; counter.gain(.004 * gain_mult);

ba.gain(.002 * gain_mult);
.001 * gain_mult => float HARMONY_GAIN;
SawOsc g => Envelope cmaj => in; g.gain(HARMONY_GAIN); Std.mtof(67) => g.freq;
SawOsc e => cmaj; e.gain(HARMONY_GAIN); Std.mtof(64) => e.freq;
SawOsc d => cmaj; d.gain(HARMONY_GAIN); Std.mtof(62) => d.freq;
SawOsc a => Envelope fmaj => in; a.gain(HARMONY_GAIN); Std.mtof(69) => a.freq;
SawOsc g2 => fmaj; g2.gain(HARMONY_GAIN); Std.mtof(67) => g2.freq;
SawOsc c => fmaj; c.gain(HARMONY_GAIN); Std.mtof(60) => c.freq;
SawOsc g3 => Envelope gdom => in; g3.gain(HARMONY_GAIN); Std.mtof(67) => g3.freq;
SawOsc f => gdom; f.gain(HARMONY_GAIN); Std.mtof(65) => f.freq;
SawOsc b => gdom; b.gain(HARMONY_GAIN); Std.mtof(59) => b.freq; 
SawOsc g4 => Envelope gsus => in; g4.gain(HARMONY_GAIN); Std.mtof(67) => g4.freq;
SawOsc f2 => gsus; f2.gain(HARMONY_GAIN); Std.mtof(65) => f2.freq;
SawOsc c2 => gsus; c2.gain(HARMONY_GAIN); Std.mtof(60) => c2.freq; 
SawOsc a2 => Envelope ddom => in; a2.gain(HARMONY_GAIN); Std.mtof(69) => a2.freq;
SawOsc fs => ddom; fs.gain(HARMONY_GAIN); Std.mtof(66) => fs.freq;
SawOsc e2 => ddom; e2.gain(HARMONY_GAIN); Std.mtof(64) => e2.freq; 

// plays daisy bass
fun void play_bass() {
    while (true) 
    {
        bass_env.keyOn();
        for (0 => int i; i < bass.size(); 1 +=> i) {
            Std.mtof(bass[i]) => ba.freq;
            bass_time[i]::second => now;
        }
    }
}
spork ~ play_bass();

// plays daisy melody with higher saw on 2nd time
fun void play_mel() {
    while (true)
    {
        mel_env.keyOn();       
        for (0 => int i; i < melody.size(); 1 +=> i) {
            Std.mtof(melody[i]) => mel.freq;
            Std.mtof(melody[i] + 12) => hmel.freq;
            Std.mtof(melody[i] + 24) => hhmel.freq;
            if (DAISY_COUNT >= 1) {
                hhhmel_env.keyOn();
                Std.mtof(melody[i] + 36) => hhhmel.freq; 
            }
            melody_time[i]::second => now;
        }
        1 +=> DAISY_COUNT;
    } 
}
spork ~ play_mel();

// plays daisy counter melody after 1x
fun void play_counter_mel() {
    while (true)
    {
        if (DAISY_COUNT > 0) {            
            counter_env.keyOn();
            for (0 => int i; i < counter_mel.size(); 1 +=> i) {
                Std.mtof(counter_mel[i]) => counter.freq;
                counter_mel_time[i]::second => now;
            }
        } else {
            33::ms => now;   
        }
    }
}
spork ~ play_counter_mel();

// play chick chick rhythm
fun void chickchick(Envelope e) {
    .33::second => now;
    e.keyOn();
    0.165::second => now;
    e.keyOff();
    0.165::second => now;
    e.keyOn();
    .33::second => now;
    e.keyOff();
}

// play chords with chick chick rhythm
fun void play_chords()
{
    while (true) {
        Envelope chord;
        for (int i: chords) {
            if (i == 1) {
                chickchick(cmaj);
            } else if (i == 4) {
                chickchick(fmaj);
            } else if (i == 5) {
                chickchick(gdom);
            } else if (i == 2) {
                chickchick(ddom);
            } else if (i == 6) {
                chickchick(gsus);
            }
        }
    }
}
spork ~ play_chords();

fun void pitch_shift()
{
    0 => float degree;
    while (true) {
        if (DAISY_COUNT >= 2) {
            ps.effectMix(.75);
            Math.random2f(1.9, 2.1)::second => now;
            ps.shift(degree);
            .15 +=> degree;
        } else {
            33::ms => now;   
        }
    }
}
spork ~ pitch_shift();

while (true) {
    33::ms => now;
}

