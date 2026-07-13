<CsoundSynthesizer>

<CsOptions>

-o dac

</CsOptions>

<CsInstruments>

sr = 48000
ksmps = 64
nchnls = 2
0dbfs = 1

giKey init 0

#define studio #/home/faddy/studio#

alwayson "output"

instr output

aLeft chnget "left"
aRight chnget "right"

denorm aLeft
denorm aRight

aLeft clip aLeft, 1, 0dbfs
aRight clip aRight, 1, 0dbfs

outs aLeft, aRight

chnclear "left"
chnclear "right"

endin

giOudSine ftgen 0, 0, 16384, 10, 1
giOudTransfer ftgen 0, 0, 4097, -7, -0.5, 1024, -0.5, 2048, 0.5, 1024, 0.5

instr 1, electro

iPLength init p4
iPreviousLength init p5
iNextLength init p6

iPDistance init p7
iPreviousDistance init p8
iNextDistance init p9

iPLeft init p10
iPreviousLeft init p11
iNextLeft init p12

iPRight init p13
iPreviousRight init p14
iNextRight init p15

iPScale init p16
iPreviousScale init p17
iNextScale init p18

iPOctave init p19
iPreviousOctave init p20
iNextOctave init p21

iPTone init p22
iPreviousTone init p23
iNextTone init p24

iPAttack init p25
iPreviousAttack init p26
iNextAttack init p27

iPDecay init p28
iPreviousDecay init p29
iNextDecay init p30

iPSustain init p31
iPreviousSustain init p32
iNextSustain init p33

iPSweep init p34
iPreviousSweep init p35
iNextSweep init p36

iPShift init p37
iPreviousShift init p38
iNextShift init p39

iPLowPass init p40
iPreviousLowPass init p41
iNextLowPass init p42

iPHighPass init p43
iPreviousHighPass init p44
iNextHighPass init p45

iLength init abs ( p3 )
iFrequency init 2^( iPOctave + ( ( giKey + iPTone ) / iPScale ) )
iNextFrequency init 2^( iNextOctave + ( ( giKey + iNextTone ) / iNextScale ) )

; p1 init int ( p1 ) + rnd ( .999 )

if iPAttack > iLength/2 then

iPAttack init iLength/2

endif

iPRelease init iPAttack/2
iPDecay *= iLength - iPAttack - iPRelease

aAmplitude linseg 0, iPAttack, 1, iPDecay, iPSustain

aRelease linseg 1, iLength - iPRelease, 1, iPRelease, 0

aAmplitude *= aRelease

iPSweep init iLength * iPSweep
iPBend init iLength - iPSweep

aFrequency expseg iFrequency * 2^( -( iPShift + iPTone - iPreviousTone ) / iPScale ), iPSweep, iFrequency, iPBend, iNextFrequency * 2^( -( iNextTone - iPTone ) / iPScale )

aVibratoAmplitude rspline 0, 1, 0, 16/iLength
aVibrato poscil aVibratoAmplitude * 2^1, 2^3

aFrequency += aVibrato

aLowPass = aFrequency * 2^iPLowPass
aHighPass = aFrequency / 2^iPHighPass

aNote = 0

a1 pluck k ( aAmplitude ), k ( aFrequency ), iFrequency, 0, 2, iLength + 3

aNote += a1

a2 pluck k ( aAmplitude ), k ( aFrequency / 2 ), iFrequency, 0, 6

;aNote *= a2

aClip rspline 0, 1, 1/iLength, 2/iLength
aSkew rspline -1, 1, 1/iLength, 8/iLength

a3 squinewave aFrequency * 2^-2, aClip, aSkew

aNote *= a3 * ( aAmplitude ) / 2^0

a5 foscil k ( aAmplitude ), k ( aFrequency ), 1.5, 1.5, .5 + k ( aClip * 3 ), giOudSine

aNote += a5 / 2^0

a6 foscil k ( aAmplitude ), k ( aFrequency ), 1.5, 2.5, .5 + k ( aClip * 3 ), giOudSine

aNote *= a6 / 2^0

aWaveAmplitude poscil aAmplitude, aFrequency
aWaveIndex = ( aWaveAmplitude + 1 ) / 2
aWave tablei    aWaveIndex, giOudTransfer, 1

aNote *= aWave

tigoto skip

;aNote clip aNote, 1, 1

aNote butterlp aNote, aLowPass
aNote butterhp aNote, aHighPass

aNote clip aNote, 1, 1

denorm aNote

aReverbLeft, aReverbRight freeverb aNote, aNote, .5, .5

aLeft = aNote + aReverbLeft
aRight = aNote + aReverbRight

skip:

iPDistance += 1

chnmix aLeft / iPDistance / ( iPLeft + 1 ), "left"
chnmix aRight / iPDistance / ( iPRight + 1 ), "right"

endin

giHornTransfer ftgen 0, 0, 4097, -7, -0.5, 1024, -0.5, 2048, 0.5, 1024, 0.5

instr 2, horn

iPLength init p4
iPreviousLength init p5
iNextLength init p6

iPDistance init p7
iPreviousDistance init p8
iNextDistance init p9

iPLeft init p10
iPreviousLeft init p11
iNextLeft init p12

iPRight init p13
iPreviousRight init p14
iNextRight init p15

iPScale init p16
iPreviousScale init p17
iNextScale init p18

iPOctave init p19
iPreviousOctave init p20
iNextOctave init p21

iPTone init p22
iPreviousTone init p23
iNextTone init p24

iPAttack init p25
iPreviousAttack init p26
iNextAttack init p27

iPDecay init p28
iPreviousDecay init p29
iNextDecay init p30

iPSustain init p31
iPreviousSustain init p32
iNextSustain init p33

iPSweep init p34
iPreviousSweep init p35
iNextSweep init p36

iPBend init p37
iPreviousBend init p38
iNextBend init p39

iPShift init p40
iPreviousShift init p41
iNextShift init p42

iPLowPass init p43
iPreviousLowPass init p44
iNextLowPass init p45

iPHighPass init p46
iPreviousHighPass init p47
iNextHighPass init p48

iLength init abs ( p3 )
iFrequency init 2^( iPOctave + ( ( giKey + iPTone ) / iPScale ) )
iNextFrequency init 2^( iNextOctave + ( ( giKey + iNextTone ) / iNextScale ) )

iTied tival

iPAttack *= iLength
iPDecay *= iLength
iPRelease init iPAttack

if iPAttack + iPDecay + iPRelease > iLength/8 then

iPAttack init iLength/4
iPRelease init iPAttack
iPDecay init iLength - iPAttack - iPRelease

;iPDecay *= iXLength
;iPRelease *= iXLength

endif

if iTied == 0 then
; && p3 > 0 then

aAmplitude linsegr 0, iPAttack, 1, iPDecay, iPSustain, iPRelease, 0

endif

iSweep init iLength * iPSweep
iBend init iLength * iPBend

if iSweep + iBend >= iLength/2 then

iSweep init iLength / iLength/4
iBend init iLength/4

endif

aFrequency expseg iFrequency * 2^( -( iPShift + iPTone - iPreviousTone ) / iPScale ), iSweep, iFrequency, iLength - ( iSweep + iBend ), iFrequency, iBend, iNextFrequency * 2^( -( iNextShift + iNextTone - iPTone ) / iPScale )

aGain linseg 0, iPAttack, 1-iPSustain, iPDecay, 0

aLowPass = aFrequency * 2^k( aGain + iPLowPass )
aHighPass = aFrequency / 2^k( aGain + iPHighPass )

tigoto skip

aModulator poscil ( 1.5+aGain ) * aFrequency, aFrequency * 2

aNote poscil aAmplitude + aGain, aFrequency + aModulator

aNote *= aModulator / aFrequency

aClip rspline .5, .5, 1, 2/iLength
aSkew rspline -1, 0, 1, 2/iLength

aBody squinewave aFrequency, aClip, aSkew

aNote *= aBody

aWaveAmplitude poscil aAmplitude + aGain, aFrequency + aModulator
aWaveIndex = ( aWaveAmplitude + 1 ) / 2
aWave tablei    aWaveIndex, giHornTransfer, 1

aNote *= aWave

denorm aNote

aNote butterlp aNote, aLowPass
aNote butterhp aNote, aHighPass

denorm aNote

aReverbLeft, aReverbRight freeverb aNote, aNote, .5, .5

aLeft = aNote + aReverbLeft
aRight = aNote + aReverbRight

skip:

iPDistance += 1

chnmix aLeft / iPDistance / ( iPLeft + 1 ), "left"
chnmix aRight / iPDistance / ( iPRight + 1 ), "right"

endin

</CsInstruments>

<CsScore>

t 0 90

v 4

i 1 0 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 0.0000152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 0.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 0.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 0.1875152587890625 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 0.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 0.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 0.3125152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 0.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 0.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 0.5000152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 0.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 0.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 0.6875152587890625 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 0.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 0.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 0.8125152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 0.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 1 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 1.0000152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 1.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 1.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 1.1875152587890625 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 1.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 1.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 1.3125152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 1.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 1.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 1.5000152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 1.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 1.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 1.6875152587890625 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 1.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 1.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 1.8125152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 1.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 2 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 2.0000152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 2.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 2.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 2.1875152587890625 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 2.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 2.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 2.3125152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 2.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 2.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 2.5000152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 2.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 2.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 2.6875152587890625 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 2.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 2.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 2.8125152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 2.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 3 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 3.0000152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 3.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 3.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 3.1875152587890625 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 3.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 3.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 3.3125152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 3.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 3.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 3.5000152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 3.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 3.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 3.6875152587890625 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 3.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 3.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 3.8125152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 3.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 4 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 4.0000152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 4.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 4.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 4.1875152587890625 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 4.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 4.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 4.3125152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 4.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 4.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 4.5000152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 4.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 4.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 4.6875152587890625 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 4.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 4.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 4.8125152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 4.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 5.0000152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 5.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 5.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 5.1875152587890625 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 5.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 5.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 5.3125152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 5.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 5.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 5.5000152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 5.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 5.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 5.6875152587890625 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 5.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 5.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 5.8125152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 5.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 6 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 6.0000152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 6.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 6.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 6.1875152587890625 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 6.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 6.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 6.3125152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 6.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 6.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 6.5000152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 6.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 6.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 6.6875152587890625 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 6.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 6.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 6.8125152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 6.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 7 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 7.0000152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 7.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 7.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 7.1875152587890625 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 7.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 7.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 7.3125152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 7.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 7.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 7.5000152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 7.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 7.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 7.6875152587890625 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 7.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 7.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 7.8125152587890625 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 7.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 8 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 8.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 8.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 8.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 8.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 8.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 8.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 8.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 8.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 8.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 8.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 8.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 8.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 8.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 8.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 8.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 8.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 8.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 9 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 9.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 9.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 9.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 9.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 9.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 9.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 9.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 9.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 9.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 9.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 9.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 9.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 9.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 9.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 9.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 9.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 9.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 10 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 10.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 10.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 10.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 10.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 10.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 10.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 10.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 10.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 10.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 10.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 10.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 10.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 10.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 10.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 10.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 10.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 10.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 11 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 11.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 11.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 11.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 11.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 11.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 11.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 11.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 11.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 11.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 11.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 11.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 11.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 11.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 11.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 11.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 11.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 11.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 12 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 12.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 12.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 12.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 12.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 12.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 12.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 12.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 12.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 12.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 12.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 12.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 12.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 12.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 12.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 12.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 12.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 12.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 13 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 13.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 13.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 13.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 13.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 13.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 13.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 13.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 13.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 13.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 13.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 13.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 13.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 13.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 13.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 13.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 13.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 13.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 14 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 14.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 14.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 14.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 14.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 14.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 14.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 14.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 14.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 14.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 14.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 14.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 14.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 14.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 14.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 14.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 14.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 14.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 15 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 15.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 15.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 15.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 15.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 15.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 15.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 15.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 15.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 15.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 15.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 15.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 15.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 15.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 15.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 15.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 15.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 15.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 16 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 16.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 16.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 16.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 16.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 16.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 16.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 16.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 16.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 16.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 16.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 16.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 16.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 16.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 16.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 16.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 16.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 16.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 17 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 17.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 17.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 17.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 17.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 17.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 17.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 17.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 17.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 17.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 17.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 17.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 17.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 17.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 17.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 17.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 17.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 17.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 18 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 18.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 18.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 18.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 18.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 18.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 18.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 18.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 18.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 18.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 18.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 18.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 18.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 18.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 18.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 18.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 18.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 18.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 19 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 19.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 19.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 19.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 19.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 19.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 19.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 19.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 19.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 19.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 19.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 19.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 19.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 19.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 19.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 19.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 19.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 19.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 20 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 20.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 20.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 20.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 20.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 20.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 20.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 20.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 20.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 20.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 20.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 20.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 20.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 20.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 20.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 20.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 20.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 20.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 21 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 21.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 21.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 21.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 21.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 21.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 21.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 21.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 21.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 21.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 21.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 21.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 21.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 21.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 21.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 21.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 21.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 21.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 22 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 22.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 22.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 22.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 22.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 22.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 22.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 22.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 22.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 22.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 22.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 22.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 22.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 22.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 22.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 22.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 22.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 22.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 23 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 23.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 23.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 23.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 23.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 23.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 23.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 23.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 23.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 23.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 23.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 23.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 23.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 23.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 23.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 23.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 23.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 23.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 24 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 24.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 24.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 24.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 24.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 24.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 24.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 24.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 24.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 24.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 24.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 24.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 24.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 24.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 24.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 24.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 24.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 24.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 25 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 25.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 25.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 25.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 25.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 25.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 25.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 25.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 25.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 25.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 25.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 25.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 25.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 25.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 25.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 25.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 25.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 25.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 26 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 26.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 26.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 26.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 26.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 26.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 26.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 26.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 26.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 26.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 26.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 26.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 26.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 26.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 26.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 26.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 26.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 26.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 27 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 27.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 27.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 27.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 27.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 27.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 27.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 27.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 27.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 27.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 27.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 27.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 27.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 27.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 27.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 27.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 27.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 27.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 28 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 28.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 28.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 28.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 28.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 28.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 28.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 28.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 28.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 28.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 28.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 28.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 28.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 28.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 28.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 28.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 28.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 28.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 29 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 29.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 29.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 29.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 29.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 29.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 29.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 29.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 29.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 29.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 29.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 29.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 29.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 29.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 29.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 29.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 29.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 29.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 30 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 30.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 30.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 30.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 30.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 30.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 30.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 30.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 30.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 30.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 30.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 30.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 30.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 30.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 30.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 30.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 30.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 30.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 31 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 31.000015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 31.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 31.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 31.187515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 31.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 31.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 31.312515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 31.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 31.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 31.500015258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 31.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 31.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 31.687515258789062 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 31.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 31.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 31.812515258789062 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 31.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 32 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 32.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 32.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 32.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 32.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 32.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 32.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 32.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 32.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 32.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 32.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 32.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 32.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 32.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 32.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 32.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 32.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 32.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 33 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 33.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 33.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 33.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 33.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 33.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 33.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 33.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 33.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 33.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 33.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 33.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 33.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 33.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 33.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 33.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 33.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 33.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 34 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 34.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 34.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 34.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 34.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 34.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 34.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 34.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 34.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 34.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 34.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 34.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 34.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 34.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 34.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 34.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 34.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 34.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 35 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 35.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 35.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 35.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 35.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 35.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 35.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 35.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 35.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 35.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 35.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 35.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 35.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 35.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 35.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 35.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 35.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 35.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 36 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 36.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 36.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 36.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 36.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 36.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 36.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 36.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 36.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 36.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 36.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 36.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 36.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 36.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 36.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 36.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 36.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 36.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 37 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 37.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 37.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 37.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 37.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 37.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 37.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 37.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 37.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 37.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 37.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 37.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 37.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 37.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 37.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 37.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 37.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 37.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 38 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 38.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 38.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 38.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 38.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 38.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 38.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 38.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 38.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 38.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 38.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 38.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 38.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 38.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 38.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 38.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 38.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 38.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 39 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 39.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 39.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 39.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 39.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 39.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 39.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 39.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 39.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 39.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 39.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 39.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 39.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 39.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 39.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 39.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 39.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 39.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 40 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 40.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 40.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 40.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 40.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 40.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 40.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 40.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 40.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 40.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 40.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 40.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 40.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 40.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 40.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 40.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 40.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 40.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 41 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 41.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 41.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 41.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 41.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 41.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 41.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 41.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 41.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 41.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 41.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 41.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 41.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 41.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 41.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 41.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 41.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 41.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 42 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 42.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 42.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 42.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 42.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 42.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 42.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 42.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 42.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 42.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 42.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 42.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 42.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 42.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 42.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 42.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 42.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 42.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 43 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 43.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 43.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 43.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 43.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 43.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 43.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 43.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 43.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 43.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 43.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 43.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 43.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 43.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 43.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 43.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 43.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 43.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 44 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 44.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 44.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 44.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 44.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 44.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 44.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 44.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 44.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 44.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 44.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 44.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 44.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 44.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 44.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 44.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 44.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 44.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 45 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 45.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 45.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 45.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 45.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 45.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 45.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 45.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 45.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 45.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 45.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 45.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 45.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 45.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 45.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 45.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 45.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 45.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 46 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 46.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 46.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 46.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 46.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 46.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 46.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 46.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 46.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 46.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 46.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 46.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 46.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 46.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 46.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 46.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 46.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 46.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 47 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 47.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 47.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 47.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 47.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 47.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 47.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 47.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 47.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 47.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 47.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 47.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 47.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 47.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 47.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 47.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 47.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 47.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 48 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 48.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 48.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 48.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 48.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 48.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 48.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 48.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 48.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 48.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 48.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 48.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 48.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 48.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 48.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 48.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 48.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 48.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 49 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 49.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 49.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 49.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 49.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 49.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 49.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 49.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 49.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 49.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 49.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 49.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 49.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 49.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 49.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 49.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 49.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 49.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 50 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 50.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 50.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 50.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 50.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 50.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 50.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 50.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 50.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 50.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 50.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 50.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 50.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 50.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 50.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 50.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 50.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 50.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 51 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 51.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 51.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 51.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 51.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 51.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 51.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 51.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 51.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 51.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 51.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 51.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 51.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 51.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 51.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 51.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 51.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 51.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 52 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 52.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 52.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 52.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 52.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 52.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 52.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 52.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 52.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 52.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 52.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 52.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 52.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 52.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 52.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 52.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 52.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 52.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 53 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 53.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 53.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 53.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 53.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 53.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 53.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 53.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 53.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 53.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 53.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 53.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 53.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 53.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 53.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 53.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 53.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 53.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 54 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 54.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 54.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 54.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 54.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 54.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 54.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 54.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 54.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 54.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 54.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 54.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 54.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 54.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 54.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 54.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 54.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 54.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 55 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 55.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 55.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 55.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 55.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 55.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 55.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 55.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 55.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 55.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 55.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 55.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 55.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 55.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 55.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 55.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 55.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 55.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 56 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 56.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 56.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 56.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 56.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 56.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 56.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 56.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 56.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 56.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 56.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 56.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 56.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 56.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 56.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 56.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 56.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 56.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 57 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 57.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 57.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 57.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 57.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 57.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 57.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 57.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 57.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 57.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 57.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 57.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 57.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 57.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 57.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 57.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 57.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 57.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 58 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 58.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 58.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 58.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 58.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 58.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 58.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 58.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 58.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 58.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 58.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 58.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 58.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 58.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 58.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 58.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 58.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 58.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 59 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 59.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 59.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 59.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 59.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 59.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 59.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 59.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 59.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 59.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 59.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 59.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 59.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 59.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 59.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 59.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 59.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 59.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 60 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 60.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 60.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 60.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 60.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 60.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 60.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 60.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 60.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 60.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 60.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 60.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 60.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 60.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 60.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 60.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 60.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 60.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 61 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 61.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 61.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 61.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 61.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 61.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 61.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 61.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 61.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 61.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 61.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 61.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 61.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 61.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 61.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 61.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 61.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 61.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 62 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 62.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 62.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 62.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 62.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 62.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 62.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 62.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 62.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 62.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 62.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 62.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 62.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 62.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 62.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 62.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 62.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 62.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 63 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 63.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 63.000030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 63.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 63.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 63.187530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 63.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 63.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 63.312530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 63.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 63.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 63.500030517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 63.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 63.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 63.687530517578125 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 63.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 63.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 63.812530517578125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 64 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 64.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 64.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 64.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 64.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 64.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 64.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 64.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 64.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 64.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 64.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 64.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 64.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 64.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 64.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 64.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 64.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 64.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 65 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 65.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 65.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 65.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 65.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 65.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 65.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 65.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 65.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 65.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 65.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 65.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 65.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 65.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 65.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 65.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 65.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 65.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 66 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 66.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 66.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 66.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 66.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 66.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 66.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 66.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 66.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 66.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 66.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 66.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 66.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 66.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 66.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 66.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 66.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 66.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 67 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 67.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 67.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 67.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 67.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 67.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 67.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 67.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 67.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 67.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 67.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 67.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 67.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 67.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 67.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 67.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 67.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 67.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 68 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 68.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 68.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 68.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 68.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 68.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 68.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 68.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 68.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 68.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 68.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 68.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 68.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 68.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 68.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 68.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 68.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 68.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 69 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 69.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 69.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 69.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 69.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 69.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 69.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 69.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 69.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 69.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 69.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 69.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 69.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 69.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 69.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 69.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 69.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 69.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 70 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 70.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 70.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 70.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 70.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 70.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 70.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 70.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 70.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 70.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 70.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 70.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 70.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 70.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 70.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 70.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 70.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 70.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 71 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 71.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 71.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 71.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 71.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 71.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 71.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 71.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 71.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 71.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 71.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 71.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 71.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 71.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 71.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 71.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 71.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 71.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 72 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 72.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 72.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 72.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 72.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 72.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 72.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 72.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 72.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 72.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 72.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 72.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 72.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 72.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 72.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 72.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 72.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 72.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 73 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 73.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 73.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 73.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 73.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 73.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 73.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 73.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 73.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 73.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 73.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 73.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 73.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 73.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 73.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 73.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 73.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 73.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 74 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 74.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 74.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 74.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 74.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 74.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 74.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 74.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 74.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 74.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 74.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 74.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 74.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 74.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 74.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 74.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 74.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 74.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 75 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 75.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 75.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 75.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 75.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 75.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 75.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 75.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 75.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 75.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 75.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 75.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 75.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 75.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 75.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 75.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 75.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 75.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 76 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 76.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 76.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 76.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 76.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 76.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 76.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 76.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 76.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 76.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 76.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 76.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 76.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 76.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 76.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 76.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 76.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 76.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 77 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 77.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 77.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 77.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 77.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 77.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 77.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 77.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 77.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 77.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 77.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 77.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 77.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 77.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 77.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 77.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 77.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 77.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 78 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 78.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 78.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 78.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 78.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 78.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 78.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 78.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 78.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 78.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 78.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 78.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 78.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 78.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 78.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 78.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 78.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 78.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 79 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 79.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 79.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 79.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 79.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 79.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 79.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 79.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 79.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 79.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 79.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 79.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 79.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 79.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 79.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 79.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 79.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 79.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 80 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 80.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 80.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 80.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 80.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 80.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 80.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 80.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 80.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 80.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 80.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 80.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 80.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 80.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 80.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 80.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 80.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 80.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 81 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 81.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 81.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 81.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 81.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 81.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 81.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 81.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 81.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 81.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 81.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 81.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 81.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 81.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 81.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 81.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 81.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 81.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 82 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 82.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 82.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 82.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 82.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 82.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 82.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 82.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 82.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 82.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 82.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 82.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 82.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 82.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 82.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 82.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 82.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 82.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 83 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 83.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 83.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 83.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 83.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 83.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 83.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 83.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 83.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 83.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 83.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 83.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 83.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 83.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 83.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 83.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 83.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 83.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 84 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 84.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 84.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 84.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 84.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 84.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 84.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 84.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 84.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 84.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 84.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 84.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 84.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 84.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 84.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 84.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 84.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 84.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 85 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 85.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 85.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 85.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 85.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 85.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 85.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 85.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 85.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 85.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 85.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 85.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 85.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 85.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 85.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 85.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 85.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 85.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 86 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 86.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 86.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 86.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 86.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 86.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 86.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 86.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 86.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 86.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 86.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 86.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 86.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 86.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 86.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 86.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 86.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 86.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 87 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 87.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 87.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 87.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 87.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 87.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 87.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 87.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 87.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 87.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 87.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 87.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 87.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 87.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 87.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 87.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 87.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 87.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 88 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 88.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 88.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 88.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 88.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 88.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 88.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 88.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 88.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 88.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 88.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 88.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 88.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 88.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 88.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 88.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 88.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 88.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 89 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 89.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 89.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 89.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 89.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 89.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 89.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 89.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 89.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 89.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 89.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 89.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 89.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 89.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 89.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 89.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 89.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 89.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 90 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 90.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 90.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 90.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 90.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 90.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 90.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 90.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 90.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 90.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 90.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 90.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 90.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 90.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 90.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 90.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 90.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 90.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 91 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 91.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 91.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 91.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 91.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 91.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 91.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 91.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 91.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 91.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 91.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 91.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 91.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 91.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 91.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 91.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 91.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 91.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 92 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 92.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 92.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 92.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 92.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 92.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 92.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 92.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 92.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 92.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 92.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 92.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 92.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 92.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 92.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 92.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 92.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 92.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 93 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 93.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 93.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 93.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 93.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 93.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 93.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 93.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 93.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 93.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 93.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 93.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 93.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 93.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 93.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 93.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 93.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 93.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 94 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 94.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 94.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 94.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 94.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 94.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 94.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 94.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 94.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 94.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 94.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 94.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 94.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 94.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 94.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 94.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 94.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 94.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 95 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 95.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 95.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 95.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 95.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 95.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 95.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 95.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 95.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 95.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 95.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 95.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 95.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 95.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 95.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 95.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 95.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 95.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 96 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 96.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 96.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 96.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 96.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 96.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 96.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 96.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 96.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 96.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 96.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 96.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 96.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 96.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 96.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 96.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 96.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 96.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 97 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 97.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 97.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 97.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 97.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 97.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 97.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 97.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 97.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 97.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 97.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 97.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 97.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 97.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 97.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 97.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 97.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 97.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 98 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 98.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 98.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 98.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 98.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 98.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 98.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 98.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 98.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 98.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 98.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 98.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 98.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 98.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 98.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 98.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 98.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 98.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 99 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 99.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 99.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 99.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 99.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 99.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 99.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 99.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 99.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 99.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 99.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 99.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 99.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 99.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 99.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 99.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 99.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 99.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 100 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 100.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 100.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 100.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 100.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 100.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 100.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 100.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 100.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 100.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 100.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 100.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 100.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 100.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 100.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 100.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 100.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 100.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 101 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 101.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 101.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 101.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 101.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 101.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 101.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 101.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 101.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 101.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 101.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 101.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 101.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 101.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 101.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 101.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 101.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 101.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 102 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 102.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 102.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 102.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 102.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 102.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 102.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 102.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 102.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 102.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 102.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 102.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 102.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 102.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 102.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 102.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 102.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 102.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 103 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 103.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 103.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 103.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 103.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 103.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 103.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 103.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 103.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 103.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 103.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 103.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 103.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 103.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 103.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 103.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 103.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 103.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 104 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 104.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 104.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 104.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 104.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 104.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 104.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 104.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 104.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 104.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 104.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 104.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 104.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 104.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 104.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 104.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 104.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 104.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 105 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 105.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 105.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 105.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 105.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 105.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 105.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 105.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 105.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 105.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 105.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 105.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 105.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 105.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 105.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 105.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 105.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 105.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 106 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 106.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 106.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 106.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 106.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 106.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 106.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 106.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 106.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 106.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 106.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 106.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 106.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 106.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 106.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 106.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 106.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 106.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 107 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 107.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 107.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 107.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 107.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 107.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 107.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 107.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 107.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 107.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 107.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 107.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 107.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 107.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 107.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 107.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 107.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 107.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 108 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 108.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 108.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 108.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 108.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 108.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 108.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 108.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 108.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 108.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 108.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 108.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 108.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 108.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 108.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 108.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 108.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 108.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 109 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 109.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 109.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 109.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 109.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 109.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 109.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 109.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 109.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 109.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 109.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 109.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 109.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 109.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 109.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 109.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 109.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 109.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 110 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 110.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 110.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 110.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 110.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 110.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 110.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 110.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 110.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 110.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 110.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 110.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 110.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 110.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 110.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 110.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 110.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 110.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 111 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 111.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 111.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 111.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 111.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 111.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 111.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 111.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 111.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 111.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 111.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 111.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 111.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 111.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 111.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 111.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 111.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 111.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 112 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 112.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 112.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 112.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 112.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 112.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 112.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 112.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 112.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 112.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 112.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 112.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 112.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 112.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 112.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 112.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 112.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 112.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 113 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 113.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 113.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 113.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 113.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 113.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 113.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 113.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 113.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 113.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 113.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 113.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 113.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 113.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 113.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 113.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 113.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 113.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 114 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 114.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 114.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 114.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 114.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 114.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 114.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 114.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 114.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 114.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 114.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 114.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 114.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 114.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 114.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 114.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 114.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 114.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 115 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 115.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 115.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 115.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 115.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 115.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 115.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 115.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 115.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 115.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 115.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 115.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 115.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 115.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 115.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 115.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 115.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 115.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 116 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 116.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 116.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 116.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 116.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 116.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 116.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 116.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 116.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 116.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 116.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 116.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 116.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 116.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 116.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 116.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 116.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 116.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 117 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 117.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 117.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 117.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 117.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 117.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 117.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 117.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 117.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 117.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 117.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 117.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 117.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 117.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 117.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 117.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 117.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 117.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 118 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 118.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 118.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 118.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 118.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 118.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 118.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 118.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 118.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 118.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 118.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 118.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 118.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 118.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 118.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 118.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 118.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 118.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 119 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 119.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 119.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 119.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 119.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 119.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 119.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 119.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 119.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 119.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 119.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 119.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 119.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 119.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 119.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 119.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 119.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 119.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 120 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 120.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 120.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 120.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 120.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 120.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 120.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 120.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 120.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 120.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 120.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 120.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 120.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 120.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 120.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 120.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 120.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 120.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 121 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 121.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 121.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 121.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 121.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 121.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 121.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 121.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 121.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 121.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 121.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 121.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 121.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 121.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 121.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 121.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 121.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 121.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 122 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 122.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 122.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 122.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 122.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 122.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 122.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 122.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 122.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 122.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 122.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 122.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 122.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 122.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 122.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 122.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 122.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 122.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 123 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 123.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 123.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 123.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 123.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 123.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 123.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 123.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 123.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 123.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 123.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 123.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 123.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 123.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 123.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 123.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 123.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 123.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 124 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 124.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 124.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 124.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 124.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 124.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 124.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 124.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 124.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 124.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 124.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 124.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 124.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 124.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 124.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 124.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 124.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 124.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 125.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 125.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 125.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 125.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 125.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 125.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 125.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 125.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 125.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 125.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 125.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 125.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 125.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 125.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 125.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 125.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 125.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 126 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 126.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 126.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 126.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 126.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 126.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 126.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 126.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 126.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 126.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 126.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 126.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 126.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 126.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 126.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 126.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 126.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 126.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 127 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 127.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 127.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 127.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 127.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 127.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 127.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 127.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 127.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 127.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 127.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 127.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 127.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 127.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 127.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 127.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 127.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 127.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 128 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 128.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 128.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 128.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 128.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 128.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 128.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 128.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 128.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 128.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 128.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 128.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 128.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 128.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 128.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 128.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 128.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 128.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 129 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 129.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 129.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 129.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 129.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 129.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 129.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 129.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 129.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 129.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 129.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 129.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 129.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 129.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 129.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 129.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 129.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 129.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 130 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 130.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 130.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 130.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 130.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 130.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 130.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 130.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 130.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 130.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 130.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 130.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 130.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 130.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 130.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 130.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 130.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 130.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 131 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 131.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 131.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 131.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 131.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 131.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 131.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 131.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 131.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 131.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 131.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 131.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 131.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 131.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 131.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 131.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 131.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 131.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 132 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 132.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 132.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 132.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 132.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 132.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 132.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 132.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 132.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 132.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 132.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 132.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 132.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 132.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 132.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 132.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 132.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 132.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 133 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 133.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 133.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 133.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 133.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 133.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 133.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 133.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 133.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 133.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 133.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 133.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 133.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 133.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 133.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 133.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 133.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 133.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 134 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 134.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 134.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 134.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 134.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 134.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 134.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 134.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 134.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 134.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 134.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 134.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 134.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 134.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 134.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 134.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 134.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 134.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 135 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 135.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 135.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 135.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 135.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 135.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 135.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 135.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 135.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 135.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 135.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 135.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 135.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 135.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 135.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 135.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 135.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 135.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 136 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 136.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 136.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 136.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 136.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 136.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 136.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 136.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 136.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 136.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 136.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 136.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 136.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 136.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 136.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 136.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 136.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 136.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 137 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 137.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 137.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 137.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 137.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 137.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 137.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 137.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 137.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 137.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 137.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 137.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 137.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 137.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 137.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 137.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 137.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 137.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 138 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 138.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 138.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 138.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 138.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 138.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 138.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 138.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 138.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 138.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 138.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 138.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 138.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 138.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 138.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 138.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 138.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 138.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 139 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 139.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 139.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 139.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 139.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 139.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 139.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 139.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 139.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 139.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 139.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 139.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 139.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 139.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 139.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 139.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 139.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 139.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 140 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 140.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 140.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 140.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 140.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 140.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 140.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 140.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 140.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 140.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 140.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 140.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 140.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 140.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 140.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 140.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 140.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 140.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 141 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 141.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 141.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 141.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 141.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 141.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 141.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 141.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 141.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 141.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 141.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 141.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 141.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 141.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 141.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 141.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 141.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 141.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 142 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 142.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 142.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 142.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 142.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 142.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 142.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 142.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 142.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 142.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 142.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 142.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 142.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 142.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 142.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 142.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 142.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 142.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 143 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 143.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 143.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 143.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 143.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 143.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 143.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 143.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 143.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 143.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 143.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 143.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 143.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 143.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 143.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 143.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 143.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 143.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 144 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 144.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 144.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 144.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 144.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 144.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 144.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 144.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 144.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 144.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 144.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 144.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 144.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 144.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 144.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 144.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 144.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 144.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 145 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 145.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 145.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 145.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 145.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 145.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 145.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 145.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 145.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 145.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 145.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 145.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 145.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 145.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 145.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 145.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 145.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 145.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 146 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 146.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 146.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 146.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 146.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 146.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 146.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 146.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 146.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 146.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 146.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 146.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 146.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 146.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 146.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 146.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 146.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 146.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 147 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 147.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 147.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 147.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 147.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 147.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 147.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 147.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 147.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 147.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 147.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 147.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 147.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 147.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 147.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 147.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 147.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 147.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 148 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 148.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 148.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 148.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 148.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 148.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 148.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 148.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 148.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 148.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 148.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 148.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 148.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 148.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 148.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 148.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 148.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 148.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 16 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 149 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 149.00001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 149.00003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 149.1875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 149.18751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 149.18753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 10 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 149.3125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 149.31251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 149.31253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 13 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 149.5 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 149.50001525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 149.50003051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 149.6875 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 -1 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 149.68751525878906 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 3 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 149.68753051757812 -0.125 -0.125 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 7 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1 149.8125 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.001 149.81251525878906 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 4 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43
i 1.002 149.81253051757812 -0.1875 -0.1875 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 9 pp22 np22 0.001953125 pp25 np25 0.25 pp28 np28 0 pp31 np31 0.00390625 pp34 np34 0 pp37 np37 2 pp40 np40 1 pp43 np43



</CsScore>

</CsoundSynthesizer>