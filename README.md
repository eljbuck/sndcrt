# sndCRT

A real-time visualization of the time and frequency domains of audio on an old-timey CRT television. Flip through different channels to hear different audio samples or opt for adc (mic) input.

## Installation

### Method 1:

Download .zip file from [live app](https://ccrma.stanford.edu/~eljbuck/256A/hw2/)

### Method 2:

Install from source

```{bash}
$ git clone https://github.com/eljbuck/sndcrt.git
```

## Run Instructions

To run the program, ensure that the [latest version of ChucK](https://chuck.stanford.edu/release/) is installed. If version 1.5.2.1 or greater is installed, ChuGL will be included. Otherwise, [download the ChuGL chugin](https://chuck.stanford.edu/release/alpha/chugl/).

From here, navigate to `sndcrt/src` and run the following program:

```{bash}
$ chuck KB.ck sndcrt.ck
```

## App Instructions

Navigate channel knob (audio sources) with <kbd>←</kbd> and <kbd>&rarr;</kbd> keys

Navigate volume knob with <kbd>&uarr;</kbd> and <kbd>&darr;</kbd> keys

Navigate to the red channel to capture microphone input