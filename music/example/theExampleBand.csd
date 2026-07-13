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

giStrike ftgen 0, 0, 256, 1, "$studio/prerequisites/marmstk1.wav", 0, 0, 0
giVibrato ftgen 0, 0, 128, 10, 1

instr 1, tabla

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

iPRelease init p34
iPreviousRelease init p35
iNextRelease init p36

iPSweep init p37
iPreviousSweep init p38
iNextSweep init p39

iPShift init p40
iPreviousShift init p41
iNextShift init p42

iLength init abs ( p3 )
iFrequency init 2^( iPOctave + ( ( giKey + iPTone ) / iPScale ) )
iNextFrequency init 2^( iNextOctave + ( ( giKey + iNextTone ) / iNextScale ) )

p3 init iPAttack + iPDecay + iPRelease

aNote = 0

aAmplitude linseg 0, iPAttack, 1, iPDecay, iPSustain, iPRelease, 0

aFrequency linseg iFrequency * iPShift, iPSweep, iFrequency

aModulator poscil 4 * aAmplitude, iFrequency / 1

aSub = 0

aSub1 poscil aAmplitude, aFrequency * aModulator

aSub += aSub1

aSub2 poscil aAmplitude, aFrequency * aModulator * 2^-1

aSub += aSub2

aSub3 poscil aAmplitude, aFrequency * aModulator * 2^1

aSub += aSub3 / 4

aNote += aSub / 2

aAmplitude linseg 0, iPAttack, 1, iPDecay / 2^2, 0

aSnatch noise aAmplitude, 0
aSnatch butterlp aSnatch, aFrequency * 2^4

aGogobell gogobel 1, iFrequency, .5, .5, giStrike, 6.0, 0.3, giVibrato

aSnatch *= aGogobell * 2

aNote += aSnatch

aLeft = aNote
aRight = aNote

iPDistance += 1

chnmix aLeft / iPDistance / ( iPLeft + 1 ), "left"
chnmix aRight / iPDistance / ( iPRight + 1 ), "right"

endin

giOudSine ftgen 0, 0, 16384, 10, 1
giOudTransfer ftgen 0, 0, 4097, -7, -0.5, 1024, -0.5, 2048, 0.5, 1024, 0.5

instr 2, electro

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

instr 3, horn

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

t 0 105

v 4

i 1 0 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 0.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 0.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 0.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 0.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 0.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 0.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 0.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 1 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 1.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 1.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 1.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 2 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 2.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 2.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 2.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 2.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 2.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 2.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 2.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 3 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 3.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 3.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 3.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 4 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 4.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 4.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 4.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 4.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 4.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 4.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 4.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 5 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 5.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 5.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 5.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 6 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 6.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 6.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 6.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 6.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 6.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 6.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 6.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 7 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 7.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 7.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 7.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 8 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 8.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 8.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 8.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 8.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 8.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 8.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 8.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 9 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 9.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 9.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 9.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 10 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 10.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 10.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 10.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 10.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 10.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 10.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 10.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 11 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 11.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 11.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 11.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 12 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 12.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 12.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 12.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 12.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 12.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 12.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 12.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 13 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 13.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 13.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 13.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 14 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 14.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 14.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 14.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 14.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 14.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 14.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 14.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 15 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 15.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 15.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 15.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 16 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 16.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 16.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 16.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 16.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 16.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 16.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 16.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 17 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 17.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 17.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 17.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 18 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 18.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 18.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 18.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 18.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 18.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 18.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 18.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 19 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 19.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 19.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 19.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 20 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 20.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 20.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 20.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 20.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 20.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 20.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 20.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 21 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 21.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 21.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 21.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 22 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 22.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 22.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 22.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 22.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 22.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 22.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 22.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 23 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 23.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 23.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 23.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 24 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 24.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 24.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 24.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 24.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 24.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 24.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 24.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 25 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 25.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 25.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 25.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 26 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 26.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 26.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 26.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 26.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 26.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 26.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 26.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 27 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 27.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 27.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 27.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 28 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 28.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 28.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 28.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 28.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 28.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 28.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 28.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 29 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 29.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 29.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 29.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 30 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 30.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 30.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 30.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 30.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 30.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 30.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 30.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 31 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 31.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 31.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 31.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 32 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 32.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 32.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 32.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 32.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 32.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 32.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 32.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 33 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 33.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 33.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 33.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 34 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 34.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 34.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 34.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 34.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 34.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 34.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 34.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 35 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 35.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 35.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 35.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 36 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 36.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 36.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 36.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 36.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 36.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 36.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 36.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 37 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 37.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 37.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 37.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 38 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 38.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 38.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 38.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 38.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 38.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 38.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 38.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 39 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 39.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 39.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 39.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 40 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 40.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 40.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 40.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 40.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 40.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 40.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 40.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 41 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 41.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 41.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 41.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 42 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 42.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 42.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 42.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 42.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 42.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 42.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 42.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 43 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 43.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 43.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 43.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 44 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 44.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 44.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 44.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 44.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 44.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 44.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 44.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 45 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 45.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 45.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 45.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 46 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 46.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 46.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 46.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 46.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 46.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 46.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 46.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 47 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 47.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 47.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 47.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 48 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 48.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 48.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 48.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 48.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 48.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 48.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 48.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 49 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 49.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 49.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 49.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 50 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 50.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 50.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 50.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 50.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 50.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 50.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 50.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 51 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 51.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 51.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 51.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 52 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 52.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 52.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 52.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 52.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 52.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 52.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 52.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 53 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 53.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 53.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 53.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 54 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 54.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 54.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 54.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 54.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 54.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 54.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 54.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 55 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 55.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 55.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 55.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 56 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 56.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 56.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 56.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 56.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 56.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 56.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 56.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 57 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 57.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 57.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 57.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 58 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 58.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 58.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 58.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 58.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 58.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 58.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 58.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 59 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 59.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 59.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 59.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 60 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 60.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 60.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 60.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 60.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 60.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 60.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 60.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 61 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 61.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 61.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 61.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 62 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 62.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 62.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 62.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 62.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 62.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 62.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 62.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 63 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 63.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 63.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 63.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 64 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 64.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 64.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 64.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 64.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 64.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 64.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 64.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 65 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 65.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 65.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 65.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 66 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 66.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 66.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 66.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 66.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 66.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 66.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 66.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 67 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 67.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 67.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 67.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 68 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 68.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 68.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 68.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 68.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 68.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 68.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 68.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 69 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 69.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 69.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 69.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 70 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 70.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 70.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 70.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 70.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 70.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 70.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 70.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 71 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 71.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 71.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 71.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 72 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 72.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 72.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 72.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 72.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 72.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 72.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 72.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 73 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 73.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 73.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 73.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 74 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 74.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 74.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 74.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 74.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 74.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 74.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 74.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 75 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 75.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 75.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 75.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 76 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 76.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 76.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 76.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 76.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 76.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 76.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 76.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 77 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 77.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 77.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 77.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 78 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 78.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 78.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 78.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 78.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 78.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 78.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 78.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 79 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 79.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 79.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 79.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 80 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 80.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 80.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 80.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 80.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 80.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 80.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 80.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 81 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 81.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 81.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 81.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 82 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 82.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 82.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 82.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 82.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 82.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 82.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 82.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 83 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 83.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 83.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 83.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 84 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 84.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 84.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 84.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 84.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 84.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 84.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 84.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 85 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 85.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 85.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 85.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 86 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 86.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 86.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 86.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 86.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 86.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 86.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 86.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 87 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 87.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 87.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 87.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 88 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 88.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 88.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 88.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 88.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 88.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 88.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 88.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 89 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 89.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 89.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 89.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 90 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 90.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 90.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 90.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 90.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 90.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 90.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 90.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 91 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 91.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 91.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 91.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 92 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 92.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 92.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 92.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 92.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 92.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 92.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 92.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 93 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 93.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 93.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 93.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 94 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 94.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 94.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 94.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 94.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 94.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 94.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 94.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 95 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 95.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 95.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 95.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 96 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 96.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 96.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 96.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 96.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 96.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 96.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 96.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 97 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 97.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 97.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 97.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 98 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 98.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 98.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 98.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 98.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 98.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 98.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 98.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 99 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 99.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 99.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 99.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 100 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 100.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 100.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 100.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 100.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 100.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 100.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 100.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 101 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 101.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 101.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 101.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 102 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 102.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 102.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 102.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 102.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 102.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 102.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 102.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 103 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 103.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 103.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 103.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 104 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 104.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 104.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 104.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 104.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 104.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 104.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 104.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 105 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 105.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 105.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 105.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 106 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 106.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 106.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 106.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 106.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 106.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 106.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 106.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 107 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 107.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 107.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 107.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 108 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 108.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 108.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 108.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 108.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 108.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 108.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 108.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 109 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 109.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 109.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 109.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 110 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 110.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 110.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 110.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 110.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 110.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 110.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 110.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 111 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 111.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 111.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 111.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 112 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 112.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 112.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 112.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 112.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 112.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 112.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 112.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 113 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 113.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 113.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 113.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 114 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 114.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 114.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 114.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 114.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 114.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 114.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 114.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 115 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 115.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 115.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 115.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 116 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 116.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 116.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 116.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 116.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 116.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 116.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 116.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 117 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 117.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 117.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 117.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 118 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 118.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 118.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 118.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 118.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 118.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 118.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 118.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 119 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 119.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 119.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 119.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 120 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 120.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 120.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 120.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 120.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 120.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 120.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 120.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 121 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 121.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 121.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 121.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 122 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 122.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 122.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 122.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 122.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 122.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 122.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 122.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 123 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 123.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 123.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 123.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 124 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 124.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 124.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 124.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 124.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 124.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 124.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 124.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 125 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 125.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 125.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 125.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 126 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 126.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 126.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 126.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 126.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 126.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 126.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 126.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 127 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 127.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 127.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 127.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 128 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 128.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 128.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 128.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 128.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 128.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 128.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 128.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 129 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 129.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 129.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 129.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 130 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 130.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 130.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 130.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 130.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 130.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 130.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 130.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 131 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 131.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 131.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 131.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 132 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 132.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 132.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 132.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 132.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 132.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 132.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 132.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 133 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 133.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 133.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 133.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 134 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 134.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 134.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 134.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 134.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 134.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 134.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 134.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 135 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 135.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 135.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 135.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 136 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 136.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 136.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 136.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 136.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 136.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 136.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 136.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 137 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 137.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 137.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 137.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 138 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 138.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 138.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 138.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 138.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 138.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 138.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 138.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 139 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 139.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 139.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 139.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 140 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 140.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 140.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 140.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 140.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 140.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 140.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 140.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 141 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 141.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 141.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 141.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 142 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 142.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 142.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 142.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 142.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 142.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 142.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 142.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 143 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 143.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 143.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 143.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 144 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 144.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 144.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 144.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 144.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 144.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 144.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 144.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 145 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 145.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 145.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 145.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 146 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 146.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 146.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 146.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 146.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 146.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 146.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 146.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 147 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 147.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 147.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 147.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 148 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 148.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 148.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 148.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 148.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 148.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 148.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 148.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 149 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 149.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 149.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 149.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 150 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 150.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 150.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 150.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 150.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 150.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 150.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 150.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 151 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 151.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 151.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 151.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 152 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 152.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 152.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 152.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 152.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 152.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 152.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 152.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 153 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 153.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 153.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 153.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 154 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 154.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 154.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 154.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 154.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 154.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 154.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 154.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 155 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 155.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 155.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 155.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 156 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 156.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 156.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 156.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 156.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 156.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 156.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 156.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 157 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 157.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 157.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 157.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 158 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 158.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 158.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 158.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 158.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 158.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 158.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 158.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 159 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 159.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 159.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 159.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 160 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 160.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 160.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 160.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 160.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 160.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 160.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 160.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 161 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 161.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 161.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 161.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 162 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 162.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 162.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 162.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 162.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 162.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 162.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 162.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 163 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 163.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 163.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 163.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 164 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 164.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 164.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 164.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 164.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 164.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 164.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 164.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 165 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 165.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 165.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 165.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 166 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 166.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 166.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 166.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 166.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 166.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 166.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 166.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 167 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 167.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 167.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 167.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 168 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 168.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 168.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 168.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 168.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 168.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 168.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 168.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 169 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 169.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 169.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 169.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 170 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 170.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 170.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 170.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 170.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 170.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 170.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 170.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 171 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 171.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 171.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 171.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 172 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 172.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 172.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 172.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 172.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 172.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 172.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 172.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 173 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 173.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 173.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 173.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 174 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 174.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 174.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 174.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 174.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 174.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 174.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 174.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 175 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 175.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 175.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 175.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 176 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 176.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 176.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 176.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 176.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 176.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 176.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 176.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 177 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 177.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 177.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 177.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 178 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 178.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 178.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 178.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 178.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 178.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 178.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 178.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 179 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 179.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 179.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 179.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 180 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 180.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 180.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 180.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 180.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 180.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 180.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 180.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 181 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 181.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 181.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 181.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 182 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 182.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 182.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 182.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 182.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 182.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 182.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 182.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 183 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 183.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 183.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 183.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 184 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 184.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 184.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 184.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 184.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 184.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 184.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 184.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 185 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 185.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 185.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 185.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 186 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 186.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 186.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 186.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 186.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 186.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 186.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 186.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 187 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 187.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 187.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 187.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 188 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 188.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 188.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 188.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 188.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 188.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 188.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 188.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 189 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 189.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 189.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 189.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 190 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 190.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 190.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 190.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 190.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 190.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 190.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 190.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 191 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 191.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 191.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 191.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 192 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 192.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 192.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 192.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 192.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 192.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 192.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 192.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 193 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 193.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 193.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 193.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 194 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 194.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 194.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 194.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 194.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 194.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 194.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 194.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 195 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 195.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 195.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 195.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 196 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 196.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 196.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 196.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 196.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 196.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 196.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 196.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 197 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 197.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 197.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 197.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 198 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 198.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 198.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 198.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 198.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 198.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 198.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 198.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 199 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 199.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 199.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 199.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 200 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 200.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 200.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 200.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 200.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 200.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 200.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 200.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 201 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 201.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 201.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 201.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 202 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 202.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 202.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 202.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 202.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 202.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 202.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 202.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 203 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 203.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 203.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 203.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 204 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 204.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 204.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 204.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 204.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 204.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 204.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 204.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 205 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 205.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 205.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 205.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 206 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 206.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 206.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 206.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 206.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 206.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 206.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 206.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 207 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 207.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 207.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 207.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 208 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 208.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 208.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 208.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 208.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 208.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 208.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 208.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 209 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 209.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 209.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 209.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 210 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 210.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 210.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 210.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 210.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 210.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 210.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 210.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 211 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 211.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 211.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 211.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 212 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 212.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 212.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 212.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 212.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 212.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 212.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 212.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 213 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 213.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 213.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 213.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 214 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 214.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 214.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 214.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 214.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 214.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 214.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 214.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 215 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 215.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 215.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 215.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 216 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 216.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 216.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 216.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 216.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 216.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 216.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 216.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 217 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 217.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 217.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 217.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 218 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 218.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 218.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 218.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 218.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 218.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 218.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 218.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 219 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 219.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 219.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 219.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 220 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 220.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 220.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 220.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 220.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 220.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 220.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 220.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 221 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 221.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 221.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 221.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 222 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 222.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 222.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 222.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 222.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 222.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 222.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 222.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 223 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 223.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 223.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 223.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 224 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 224.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 224.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 224.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 224.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 224.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 224.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 224.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 225 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 225.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 225.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 225.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 226 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 226.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 226.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 226.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 226.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 226.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 226.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 226.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 227 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 227.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 227.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 227.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 228 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 228.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 228.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 228.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 228.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 228.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 228.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 228.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 229 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 229.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 229.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 229.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 230 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 230.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 230.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 230.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 230.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 230.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 230.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 230.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 231 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 231.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 231.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 231.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 232 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 232.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 232.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 232.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 232.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 232.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 232.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 232.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 233 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 233.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 233.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 233.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 234 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 234.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 234.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 234.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 234.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 234.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 234.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 234.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 235 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 235.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 235.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 235.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 236 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 236.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 236.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 236.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 236.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 236.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 236.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 236.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 237 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 237.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 237.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 237.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 238 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 238.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 238.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 238.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 238.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 238.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 238.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 238.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 239 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 239.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 239.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 239.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 240 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 240.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 240.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 240.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 240.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 240.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 240.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 240.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 241 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 241.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 241.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 241.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 242 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 242.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 242.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 242.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 242.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 242.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 242.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 242.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 243 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 243.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 243.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 243.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 244 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 244.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 244.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 244.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 244.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 244.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 244.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 244.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 245 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 245.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 245.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 245.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 246 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 246.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 246.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 246.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 246.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 246.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 246.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 246.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 247 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 247.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 247.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 247.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 248 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 248.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 248.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 248.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 248.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 248.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 248.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 248.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 249 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 249.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 249.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 249.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 250 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 250.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 250.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 250.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 250.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 250.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 250.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 250.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 251 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 251.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 251.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 251.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 252 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 252.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 252.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 252.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 252.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 252.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 252.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 252.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 253 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 253.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 253.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 253.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 254 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 254.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 254.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 254.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 254.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 254.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 254.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 254.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 255 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 255.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 255.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 255.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 256 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 256.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 256.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 256.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 256.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 256.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 256.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 256.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 257 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 257.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 257.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 257.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 258 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 258.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 258.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 258.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 258.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 258.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 258.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 258.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 259 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 259.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 259.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 259.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 260 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 260.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 260.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 260.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 260.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 260.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 260.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 260.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 261 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 261.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 261.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 261.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 262 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 262.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 262.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 262.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 262.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 262.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 262.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 262.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 263 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 263.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 263.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 263.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 264 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 264.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 264.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 264.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 264.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 264.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 264.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 264.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 265 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 265.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 265.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 265.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 266 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 266.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 266.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 266.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 266.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 266.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 266.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 266.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 267 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 267.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 267.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 267.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 268 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 268.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 268.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 268.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 268.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 268.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 268.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 268.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 269 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 269.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 269.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 269.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 270 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 270.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 270.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 270.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 270.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 270.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 270.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 270.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 271 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 271.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 271.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 271.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 272 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 272.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 272.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 272.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 272.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 272.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 272.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 272.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 273 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 273.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 273.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 273.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 274 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 274.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 274.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 274.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 274.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 274.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 274.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 274.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 275 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 275.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 275.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 275.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 276 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 276.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 276.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 276.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 276.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 276.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 276.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 276.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 277 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 277.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 277.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 277.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 278 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 278.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 278.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 278.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 278.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 278.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 278.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 278.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 279 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 279.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 279.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 279.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 280 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 280.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 280.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 280.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 280.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 280.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 280.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 280.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 281 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 281.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 281.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 281.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 282 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 282.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 282.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 282.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 282.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 282.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 282.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 282.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 283 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 283.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 283.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 283.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 284 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 284.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 284.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 284.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 284.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 284.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 284.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 284.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 285 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 285.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 285.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 285.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 286 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 286.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 286.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 286.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 286.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 286.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 286.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 286.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 287 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 287.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 287.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 287.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 288 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 288.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 288.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 288.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 288.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 288.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 288.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 288.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 289 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 289.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 289.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 289.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 290 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 290.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 290.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 290.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 290.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 290.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 290.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 290.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 291 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 291.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 291.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 291.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 292 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 292.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 292.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 292.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 292.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 292.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 292.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 292.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 293 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 293.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 293.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 293.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 294 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 294.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 294.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 294.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 294.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 294.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 294.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 294.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 295 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 295.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 295.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 295.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 296 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 296.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 296.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 296.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 296.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 296.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 296.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 296.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 297 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 297.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 297.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 297.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 298 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 298.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 298.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 298.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 298.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 298.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 298.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 298.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 299 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 299.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 299.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 299.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 300 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 300.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 300.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 300.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 300.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 300.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 300.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 300.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 301 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 301.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 301.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 301.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 302 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 302.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 302.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 302.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 302.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 302.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 302.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 302.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 303 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 303.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 303.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 303.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 304 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 304.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 304.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 304.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 304.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 304.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 304.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 304.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 305 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 305.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 305.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 305.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 306 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 306.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 306.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 306.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 306.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 306.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 306.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 306.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 307 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 307.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 307.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 307.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 308 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 308.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 308.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 308.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 308.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 308.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 308.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 308.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 309 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 309.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 309.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 309.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 310 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 310.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 310.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 310.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 310.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 310.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 310.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 310.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 311 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 311.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 311.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 311.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 312 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 312.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 312.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 312.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 312.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 312.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 312.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 312.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 313 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 313.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 313.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 313.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 314 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 314.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 314.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 314.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 314.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 314.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 314.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 314.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 315 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 315.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 315.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 315.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 316 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 316.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 316.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 316.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 316.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 316.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 316.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 316.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 317 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 317.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 317.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 317.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 318 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 318.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 318.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 318.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 318.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 318.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 318.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 318.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 319 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 319.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 319.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 319.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 320 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 320.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 320.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 320.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 320.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 320.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 320.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 320.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 321 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 321.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 321.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 321.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 322 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 322.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 322.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 322.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 322.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 322.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 322.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 322.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 323 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 323.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 323.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 323.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 324 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 324.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 324.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 324.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 324.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 324.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 324.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 324.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 325 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 325.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 325.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 325.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 326 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 326.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 326.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 326.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 326.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 326.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 326.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 326.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 327 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 327.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 327.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 327.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 328 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 328.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 328.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 328.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 328.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 328.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 328.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 328.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 329 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 329.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 329.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 329.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 330 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 330.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 330.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 330.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 330.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 330.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 330.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 330.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 331 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 331.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 331.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 331.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 332 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 332.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 332.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 332.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 332.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 332.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 332.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 332.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 333 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 333.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 333.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 333.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 334 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 334.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 334.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 334.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 334.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 334.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 334.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 334.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 335 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 335.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 335.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 335.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 336 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 336.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 336.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 336.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 336.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 336.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 336.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 336.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 337 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 337.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 337.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 337.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 338 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 338.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 338.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 338.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 338.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 338.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 338.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 338.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 339 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 339.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 339.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 339.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 340 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 340.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 340.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 340.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 340.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 340.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 340.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 340.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 341 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 341.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 341.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 341.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 342 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 342.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 342.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 342.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 342.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 342.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 342.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 342.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 343 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 343.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 343.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 343.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 344 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 344.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 344.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 344.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 344.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 344.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 344.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 344.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 345 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 345.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 345.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 345.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 346 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 346.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 346.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 346.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 346.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 346.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 346.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 346.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 347 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 347.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 347.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 347.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 348 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 348.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 348.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 348.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 348.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 348.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 348.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 348.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 349 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 349.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 349.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 349.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 350 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 350.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 350.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 350.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 350.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 350.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 350.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 350.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 351 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 351.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 351.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 351.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 352 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 352.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 352.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 352.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 352.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 352.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 352.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 352.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 353 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 353.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 353.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 353.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 354 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 354.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 354.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 354.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 354.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 354.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 354.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 354.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 355 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 355.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 355.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 355.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 356 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 356.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 356.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 356.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 356.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 356.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 356.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 356.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 357 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 357.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 357.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 357.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 358 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 358.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 358.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 358.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 358.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 358.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 358.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 358.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 359 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 359.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 359.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 359.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 360 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 360.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 360.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 360.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 360.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 360.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 360.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 360.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 361 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 361.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 361.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 361.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 362 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 362.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 362.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 362.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 362.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 362.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 362.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 362.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 363 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 363.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 363.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 363.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 364 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 364.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 364.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 364.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 364.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 364.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 364.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 364.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 365 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 365.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 365.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 365.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 366 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 366.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 366.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 366.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 366.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 366.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 366.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 366.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 367 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 367.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 367.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 367.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 368 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 368.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 368.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 368.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 368.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 368.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 368.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 368.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 369 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 369.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 369.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 369.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 370 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 370.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 370.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 370.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 370.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 370.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 370.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 370.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 371 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 371.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 371.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 371.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 372 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 372.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 372.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 372.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 372.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 372.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 372.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 372.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 373 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 373.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 373.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 373.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 374 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 374.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 374.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 374.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 374.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 374.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 374.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 374.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 375.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 375.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 375.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 376 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 376.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 376.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 376.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 376.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 376.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 376.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 376.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 377 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 377.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 377.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 377.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 378 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 378.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 378.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 378.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 378.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 378.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 378.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 378.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 379 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 379.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 379.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 379.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 380 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 380.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 380.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 380.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 380.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 380.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 380.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 380.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 381 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 381.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 381.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 381.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 382 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 382.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 382.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 382.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 382.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 382.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 382.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 382.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 383 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 383.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 383.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 383.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 384 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 384.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 384.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 384.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 384.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 384.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 384.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 384.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 385 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 385.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 385.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 385.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 386 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 386.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 386.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 386.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 386.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 386.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 386.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 386.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 387 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 387.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 387.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 387.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 388 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 388.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 388.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 388.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 388.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 388.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 388.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 388.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 389 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 389.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 389.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 389.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 390 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 390.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 390.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 390.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 390.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 390.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 390.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 390.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 391 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 391.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 391.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 391.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 392 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 392.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 392.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 392.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 392.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 392.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 392.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 392.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 393 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 393.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 393.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 393.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 394 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 394.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 394.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 394.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 394.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 394.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 394.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 394.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 395 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 395.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 395.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 395.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 396 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 396.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 396.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 396.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 396.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 396.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 396.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 396.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 397 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 397.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 397.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 7 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 397.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 10 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 398 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 398.125 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 398.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 398.375 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 398.5 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 398.625 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 4 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 398.75 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 3 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 398.875 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 399 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 399.25 -0.125 -0.125 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 399.375 -0.25 -0.25 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 -1 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40
i 1 399.625 -0.375 -0.375 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 5 pp19 np19 0 pp22 np22 0.03125 pp25 np25 0.25 pp28 np28 0.125 pp31 np31 1 pp34 np34 0.03125 pp37 np37 8 pp40 np40





</CsScore>

</CsoundSynthesizer>