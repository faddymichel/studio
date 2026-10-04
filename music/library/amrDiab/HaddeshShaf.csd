<CsoundSynthesizer>

<CsOptions>

-o dac

</CsOptions>

<CsInstruments>

sr = 48000
ksmps = 64
nchnls = 2
0dbfs = 1

giKey init 8

#define studio #/home/faddy/studio/music#

giHornTransfer ftgen 0, 0, 4097, -7, -0.5, 1024, -0.5, 2048, 0.5, 1024, 0.5

instr 1

iPTone init p4
iPreviousTone init p5
iNextTone init p6

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

iPAttack init p22
iPreviousAttack init p23
iNextAttack init p24

iPDecay init p25
iPreviousDecay init p26
iNextDecay init p27

iPSustain init p28
iPreviousSustain init p29
iNextSustain init p30

iPSweep init p31
iPreviousSweep init p32
iNextSweep init p33

iPBend init p34
iPreviousBend init p35
iNextBend init p36

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

aClip rspline .5, .5, 1/iLength, 2/iLength
aSkew rspline -1, 0, 1/iLength, 2/iLength

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

giChordellaSine ftgen 0, 0, 16384, 10, 1
giChordellaTransfer ftgen 0, 0, 4097, -7, -0.5, 1024, -0.5, 2048, 0.5, 1024, 0.5

giChordellaFT vco2init 31, 1000

instr 2, 4, 5

iPTone init p4
iPreviousTone init p5
iNextTone init p6

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

iPAttack init p22
iPreviousAttack init p23
iNextAttack init p24

iPDecay init p25
iPreviousDecay init p26
iNextDecay init p27

iPSustain init p28
iPreviousSustain init p29
iNextSustain init p30

iPSweep init p31
iPreviousSweep init p32
iNextSweep init p33

iPShift init p34
iPreviousShift init p35
iNextShift init p36

iPLowPass init p37
iPreviousLowPass init p38
iNextLowPass init p39

iPHighPass init p40
iPreviousHighPass init p41
iNextHighPass init p42

iLength init abs ( p3 )
iFrequency init 2^( iPOctave + ( ( giKey + iPTone ) / iPScale ) )
iNextFrequency init 2^( iNextOctave + ( ( giKey + iNextTone ) / iNextScale ) )

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

; aFrequency linseg iFrequency * 2^( iPShift / iPScale ), iPSweep, iFrequency

aFrequency linseg iFrequency * 2^( -( iPShift + iPTone - iPreviousTone ) / iPScale ), iPSweep, iFrequency, iPBend, iNextFrequency * 2^( -( iNextTone - iPTone ) / iPScale )

aVibratoAmplitude rspline 0, 1, 0, 16/iLength
aVibrato poscil aVibratoAmplitude * 2^4, 2^iPOctave

aFrequency += aVibrato

aLowPass = aFrequency * 2^k( aAmplitude * iPLowPass )
aHighPass = aFrequency / 2^k( aAmplitude * iPHighPass )

iWave vco2ift iFrequency, 3

aPluck pluck k ( aAmplitude ), k ( aFrequency ), iFrequency, 0, 2, iLength + 3

;aPluck poscil aAmplitude, aFrequency*2, iWave

aNote poscil aPluck, aFrequency, iWave

tigoto skip

aNote clip aNote * 2^0, 0, 2^3

aNote butterlp aNote, aLowPass
aNote butterhp aNote, aHighPass

denorm aNote

aLeft = aNote
aRight = aNote

skip:

iPDistance += 1

chnmix aLeft / iPDistance / ( iPLeft + 1 ), "left"
chnmix aRight / iPDistance / ( iPRight + 1 ), "right"

endin

giLeadoSine ftgen 0, 0, 16384, 10, 1
giLeadoTransfer ftgen 0, 0, 4097, -7, -0.5, 1024, -0.5, 2048, 0.5, 1024, 0.5

giLeadoFT vco2init 31, 1000

instr 3

iPTone init p4
iPreviousTone init p5
iNextTone init p6

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

iPAttack init p22
iPreviousAttack init p23
iNextAttack init p24

iPDecay init p25
iPreviousDecay init p26
iNextDecay init p27

iPSustain init p28
iPreviousSustain init p29
iNextSustain init p30

iPSweep init p31
iPreviousSweep init p32
iNextSweep init p33

iPShift init p34
iPreviousShift init p35
iNextShift init p36

iPLowPass init p37
iPreviousLowPass init p38
iNextLowPass init p39

iPHighPass init p40
iPreviousHighPass init p41
iNextHighPass init p42

iLength init abs ( p3 )
iFrequency init 2^( iPOctave + ( ( giKey + iPTone ) / iPScale ) )
iNextFrequency init 2^( iNextOctave + ( ( giKey + iNextTone ) / iNextScale ) )

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

aFrequency linseg iFrequency * 2^( -( iPShift + iPTone - iPreviousTone ) / iPScale ), iPSweep, iFrequency, iPBend, iNextFrequency * 2^( -( iNextTone - iPTone ) / iPScale )

aVibratoAmplitude rspline 0, 1, 0, 16/iLength
aVibrato poscil aVibratoAmplitude * 2^4, 2^( iPOctave - 1 )

aFrequency += aVibrato

aLowPass = aFrequency * 2^iPLowPass
aHighPass = aFrequency / 2^iPHighPass

iWave vco2ift iFrequency, 3

aPluck pluck k ( aAmplitude ), k ( aFrequency / 2 ), iFrequency, 0, 2, iLength + 3

aLow poscil aPluck, aFrequency, iWave

aPluck pluck k ( aAmplitude ), k ( aFrequency / 1 ), iFrequency, 0, 2, iLength + 3

aHigh poscil aPluck, aFrequency, iWave

aNote = aLow + aHigh

tigoto skip

aNote clip aNote * 2^0, 1, 1

aNote butterlp aNote, aLowPass
aNote butterhp aNote, aHighPass

denorm aNote

aLeft = aNote
aRight = aNote

skip:

iPDistance += 1

chnmix aLeft / iPDistance / ( iPLeft + 1 ), "left"
chnmix aRight / iPDistance / ( iPRight + 1 ), "right"

endin

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

instr loopback

rewindscore

endin

</CsInstruments>

<CsScore>

i "output" 0 -1

t 0 105

v 4



i 4 0 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 0.1875 -0.1875 7 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 0.375 -0.125 7 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 0.5 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 0.6875 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 0.875 -0.125 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 1 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 1.1875 -0.1875 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 1.375 -0.125 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 1.5 -0.1875 -1 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 1.6875 -0.1875 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 1.875 -0.125 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 2 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 2.1875 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 2.375 -0.125 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 2.5 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 2.6875 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 2.875 -0.125 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 3 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 3.1875 -0.1875 10 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 3.375 -0.125 10 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 3.5 -0.1875 15 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 3.6875 -0.1875 16 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 3.875 0.125 16 pp4 16 0 pp7 0 0 pp10 0 0 pp13 0 16 pp16 16 7 pp19 7 0.0078125 pp22 0.0078125 0.5 pp25 0.5 0.0000152587890625 pp28 0.0000152587890625 0.015625 pp31 0.015625 16 pp34 16 2 pp37 2 0 pp40 0
i 4 4 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 4.1875 -0.1875 7 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 4.375 -0.125 7 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 4.5 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 4.6875 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 4.875 -0.125 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 5 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 5.1875 -0.1875 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 5.375 -0.125 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 5.5 -0.1875 -1 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 5.6875 -0.1875 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 5.875 -0.125 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 6 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 6.1875 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 6.375 -0.125 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 6.5 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 6.6875 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 6.875 -0.125 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 7 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 7.1875 -0.1875 10 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 7.375 -0.125 10 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 7.5 -0.1875 15 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 7.6875 -0.1875 16 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 7.875 0.125 16 pp4 16 0 pp7 0 0 pp10 0 0 pp13 0 16 pp16 16 7 pp19 7 0.0078125 pp22 0.0078125 0.5 pp25 0.5 0.0000152587890625 pp28 0.0000152587890625 0.015625 pp31 0.015625 16 pp34 16 2 pp37 2 0 pp40 0
i 4 8 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 8.1875 -0.1875 7 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 8.375 -0.125 7 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 8.5 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 8.6875 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 8.875 -0.125 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 9 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 9.1875 -0.1875 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 9.375 -0.125 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 9.5 -0.1875 -1 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 9.6875 -0.1875 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 9.875 -0.125 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 10 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 10.1875 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 10.375 -0.125 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 10.5 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 10.6875 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 10.875 -0.125 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 11 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 11.1875 -0.1875 10 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 11.375 -0.125 10 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 11.5 -0.1875 15 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 11.6875 -0.1875 16 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 11.875 0.125 16 pp4 16 0 pp7 0 0 pp10 0 0 pp13 0 16 pp16 16 7 pp19 7 0.0078125 pp22 0.0078125 0.5 pp25 0.5 0.0000152587890625 pp28 0.0000152587890625 0.015625 pp31 0.015625 16 pp34 16 2 pp37 2 0 pp40 0
i 4 12 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 12.1875 -0.1875 7 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 12.375 -0.125 7 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 12.5 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 12.6875 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 12.875 -0.125 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 13 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 13.1875 -0.1875 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 13.375 -0.125 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 13.5 -0.1875 -1 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 13.6875 -0.1875 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 13.875 -0.125 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 14 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 14.1875 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 14.375 -0.125 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 14.5 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 14.6875 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 14.875 -0.125 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 15 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 15.1875 -0.1875 10 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 15.375 -0.125 10 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 15.5 -0.1875 15 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 15.6875 -0.1875 16 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 15.875 0.125 16 pp4 16 0 pp7 0 0 pp10 0 0 pp13 0 16 pp16 16 7 pp19 7 0.0078125 pp22 0.0078125 0.5 pp25 0.5 0.0000152587890625 pp28 0.0000152587890625 0.015625 pp31 0.015625 16 pp34 16 2 pp37 2 0 pp40 0
i 4 16 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 16.1875 -0.1875 7 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 16.375 -0.125 7 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 16.5 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 16.6875 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 16.875 -0.125 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 17 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 17.1875 -0.1875 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 17.375 -0.125 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 17.5 -0.1875 -1 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 17.6875 -0.1875 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 17.875 -0.125 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 18 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 18.1875 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 18.375 -0.125 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 18.5 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 18.6875 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 18.875 -0.125 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 19 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 19.1875 -0.1875 10 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 19.375 -0.125 10 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 19.5 -0.1875 15 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 19.6875 -0.1875 16 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 19.875 0.125 16 pp4 16 0 pp7 0 0 pp10 0 0 pp13 0 16 pp16 16 7 pp19 7 0.0078125 pp22 0.0078125 0.5 pp25 0.5 0.0000152587890625 pp28 0.0000152587890625 0.015625 pp31 0.015625 16 pp34 16 2 pp37 2 0 pp40 0
i 4 20 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 20.1875 -0.1875 7 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 20.375 -0.125 7 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 20.5 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 20.6875 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 20.875 -0.125 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 21 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 21.1875 -0.1875 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 21.375 -0.125 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 21.5 -0.1875 -1 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 21.6875 -0.1875 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 21.875 -0.125 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 22 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 22.1875 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 22.375 -0.125 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 22.5 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 22.6875 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 22.875 -0.125 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 23 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 23.1875 -0.1875 10 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 23.375 -0.125 10 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 23.5 -0.1875 15 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 23.6875 -0.1875 16 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 23.875 0.125 16 pp4 16 0 pp7 0 0 pp10 0 0 pp13 0 16 pp16 16 7 pp19 7 0.0078125 pp22 0.0078125 0.5 pp25 0.5 0.0000152587890625 pp28 0.0000152587890625 0.015625 pp31 0.015625 16 pp34 16 2 pp37 2 0 pp40 0
i 4 24 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 24.1875 -0.1875 7 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 24.375 -0.125 7 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 24.5 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 24.6875 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 24.875 -0.125 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 25 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 25.1875 -0.1875 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 25.375 -0.125 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 25.5 -0.1875 -1 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 25.6875 -0.1875 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 25.875 -0.125 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 26 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 26.1875 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 26.375 -0.125 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 26.5 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 26.6875 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 26.875 -0.125 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 27 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 27.1875 -0.1875 10 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 27.375 -0.125 10 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 27.5 -0.1875 15 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 27.6875 -0.1875 16 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 27.875 0.125 16 pp4 16 0 pp7 0 0 pp10 0 0 pp13 0 16 pp16 16 7 pp19 7 0.0078125 pp22 0.0078125 0.5 pp25 0.5 0.0000152587890625 pp28 0.0000152587890625 0.015625 pp31 0.015625 16 pp34 16 2 pp37 2 0 pp40 0
i 4 28 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 28.1875 -0.1875 7 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 28.375 -0.125 7 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 28.5 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 28.6875 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 28.875 -0.125 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 29 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 29.1875 -0.1875 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 29.375 -0.125 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 29.5 -0.1875 -1 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 29.6875 -0.1875 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 29.875 -0.125 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 30 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 30.1875 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 30.375 -0.125 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 30.5 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 30.6875 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 30.875 -0.125 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 31 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 31.1875 -0.1875 10 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 31.375 -0.125 10 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 31.5 -0.1875 15 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 31.6875 -0.1875 16 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 31.875 0.125 16 pp4 16 0 pp7 0 0 pp10 0 0 pp13 0 16 pp16 16 7 pp19 7 0.0078125 pp22 0.0078125 0.5 pp25 0.5 0.0000152587890625 pp28 0.0000152587890625 0.015625 pp31 0.015625 16 pp34 16 2 pp37 2 0 pp40 0
i 4 32 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 32.1875 -0.1875 7 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 32.375 -0.125 7 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 32.5 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 32.6875 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 32.875 -0.125 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 33 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 33.1875 -0.1875 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 33.375 -0.125 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 33.5 -0.1875 -1 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 33.6875 -0.1875 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 33.875 -0.125 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 34 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 34.1875 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 34.375 -0.125 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 34.5 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 34.6875 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 34.875 -0.125 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 35 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 35.1875 -0.1875 10 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 35.375 -0.125 10 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 35.5 -0.1875 15 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 35.6875 -0.1875 16 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 35.875 0.125 16 pp4 16 0 pp7 0 0 pp10 0 0 pp13 0 16 pp16 16 7 pp19 7 0.0078125 pp22 0.0078125 0.5 pp25 0.5 0.0000152587890625 pp28 0.0000152587890625 0.015625 pp31 0.015625 16 pp34 16 2 pp37 2 0 pp40 0
i 4 36 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 36.1875 -0.1875 7 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 36.375 -0.125 7 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 36.5 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 36.6875 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 36.875 -0.125 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 37 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 37.1875 -0.1875 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 37.375 -0.125 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 37.5 -0.1875 -1 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 37.6875 -0.1875 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 37.875 -0.125 0 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 38 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 38.1875 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 38.375 -0.125 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 38.5 -0.1875 3 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 38.6875 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 38.875 -0.125 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 39 -0.1875 4 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 39.1875 -0.1875 10 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 39.375 -0.125 10 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 39.5 -0.1875 15 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 39.6875 -0.1875 16 pp4 np4 0 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 7 pp19 np19 0.0078125 pp22 np22 0.5 pp25 np25 0.0000152587890625 pp28 np28 0.015625 pp31 np31 16 pp34 np34 2 pp37 np37 0 pp40 np40
i 4 39.875 0.125 16 pp4 16 0 pp7 0 0 pp10 0 0 pp13 0 16 pp16 16 7 pp19 7 0.0078125 pp22 0.0078125 0.5 pp25 0.5 0.0000152587890625 pp28 0.0000152587890625 0.015625 pp31 0.015625 16 pp34 16 2 pp37 2 0 pp40 0

i 3 0 -0.5 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 0.5 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 0.53125 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 0.5625 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 0.59375 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 0.625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 0.65625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 0.6875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 0.71875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 0.75 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 0.875 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 1 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 1.0625 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 1.125 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 1.1875 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 1.25 -0.625 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 1.875 -0.0625 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 1.9375 -0.0625 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 2 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 2.0625 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 2.125 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 2.15625 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 2.1875 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 2.21875 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 2.25 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 2.3125 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 2.375 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 2.4375 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 2.5 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 2.53125 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 2.5625 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 2.59375 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 2.625 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 2.6875 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 2.75 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 2.875 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 3 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 3.03125 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 3.0625 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 3.09375 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 3.125 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 3.1875 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 3.25 0.75 10 pp4 10 1 pp7 1 0 pp10 0 0 pp13 0 16 pp16 16 8 pp19 8 0.015625 pp22 0.015625 1 pp25 1 0.0000152587890625 pp28 0.0000152587890625 0.0625 pp31 0.0625 1 pp34 1 1 pp37 1 1 pp40 1
i 3 4 -0.5 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 4.5 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 4.53125 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 4.5625 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 4.59375 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 4.625 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 4.6875 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 4.75 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 4.875 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 5 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 5.0625 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 5.125 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 5.15625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 5.1875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 5.21875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 5.25 -0.625 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 5.875 -0.03125 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 5.90625 -0.03125 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 5.9375 -0.03125 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 5.96875 -0.03125 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 6 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 6.0625 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 6.125 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 6.1875 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 6.25 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 6.3125 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 6.375 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 6.4375 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 6.5 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 6.53125 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 6.5625 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 6.59375 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 6.625 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 6.6875 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 6.75 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 6.8125 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 6.875 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 6.9375 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 7 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 7.0625 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 7.125 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 7.15625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 7.1875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 7.21875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 7.25 -1.5 10 pp4 10 1 pp7 1 0 pp10 0 0 pp13 0 16 pp16 16 8 pp19 8 0.015625 pp22 0.015625 1 pp25 1 0.0000152587890625 pp28 0.0000152587890625 0.0625 pp31 0.0625 1 pp34 1 1 pp37 1 1 pp40 1
i 3 8 -0.5 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 8.5 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 8.53125 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 8.5625 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 8.59375 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 8.625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 8.65625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 8.6875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 8.71875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 8.75 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 8.8125 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 8.875 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 8.9375 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 9 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 9.0625 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 9.125 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 9.1875 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 9.25 -1.25 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 9.875 -0.0625 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 9.9375 -0.0625 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 10 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 10.0625 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 10.125 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 10.1875 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 10.25 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 10.375 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 10.5 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 10.5625 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 10.625 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 10.6875 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 10.75 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 10.875 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 11 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 11.03125 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 11.0625 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 11.09375 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 11.125 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 11.15625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 11.1875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 11.21875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 11.25 0.75 10 pp4 10 1 pp7 1 0 pp10 0 0 pp13 0 16 pp16 16 8 pp19 8 0.015625 pp22 0.015625 1 pp25 1 0.0000152587890625 pp28 0.0000152587890625 0.0625 pp31 0.0625 1 pp34 1 1 pp37 1 1 pp40 1
i 3 12 -1 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 12.5 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 12.5625 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 12.625 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 12.6875 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 12.75 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 12.875 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 13 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 13.03125 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 13.0625 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 13.09375 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 13.125 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 13.15625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 13.1875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 13.21875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 13.25 -1.25 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 13.875 -0.03125 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 13.90625 -0.03125 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 13.9375 -0.03125 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 13.96875 -0.03125 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 14 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 14.0625 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 14.125 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 14.15625 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 14.1875 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 14.21875 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 14.25 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 14.375 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 14.5 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 14.5625 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 14.625 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 14.6875 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 14.75 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 14.875 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 15 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 15.0625 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 15.125 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 15.15625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 15.1875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 15.21875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 15.25 -1.5 10 pp4 10 1 pp7 1 0 pp10 0 0 pp13 0 16 pp16 16 8 pp19 8 0.015625 pp22 0.015625 1 pp25 1 0.0000152587890625 pp28 0.0000152587890625 0.0625 pp31 0.0625 1 pp34 1 1 pp37 1 1 pp40 1
i 3 16 -0.5 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 16.5 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 16.5625 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 16.625 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 16.6875 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 16.75 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 16.875 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 17 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 17.03125 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 17.0625 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 17.09375 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 17.125 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 17.1875 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 17.25 -0.625 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 17.875 -0.03125 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 17.90625 -0.03125 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 17.9375 -0.03125 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 17.96875 -0.03125 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 18 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 18.0625 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 18.125 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 18.1875 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 18.25 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 18.375 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 18.5 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 18.53125 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 18.5625 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 18.59375 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 18.625 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 18.6875 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 18.75 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 18.8125 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 18.875 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 18.9375 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 19 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 19.0625 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 19.125 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 19.15625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 19.1875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 19.21875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 19.25 -1.5 10 pp4 10 1 pp7 1 0 pp10 0 0 pp13 0 16 pp16 16 8 pp19 8 0.015625 pp22 0.015625 1 pp25 1 0.0000152587890625 pp28 0.0000152587890625 0.0625 pp31 0.0625 1 pp34 1 1 pp37 1 1 pp40 1
i 3 20 -1 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 20.5 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 20.53125 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 20.5625 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 20.59375 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 20.625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 20.65625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 20.6875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 20.71875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 20.75 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 20.875 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 21 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 21.03125 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 21.0625 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 21.09375 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 21.125 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 21.15625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 21.1875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 21.21875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 21.25 -1.25 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 21.875 -0.0625 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 21.9375 -0.0625 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.03125 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.0625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.09375 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.125 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.15625 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.1875 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.21875 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.25 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.3125 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.375 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.4375 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.5 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.53125 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.5625 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.59375 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.65625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.6875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.71875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.75 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.8125 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.875 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 22.9375 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 23 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 23.0625 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 23.125 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 23.15625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 23.1875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 23.21875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 23.25 0.75 10 pp4 10 1 pp7 1 0 pp10 0 0 pp13 0 16 pp16 16 8 pp19 8 0.015625 pp22 0.015625 1 pp25 1 0.0000152587890625 pp28 0.0000152587890625 0.0625 pp31 0.0625 1 pp34 1 1 pp37 1 1 pp40 1
i 3 24 -1 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 24.5 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 24.53125 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 24.5625 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 24.59375 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 24.625 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 24.6875 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 24.75 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 24.8125 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 24.875 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 24.9375 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 25 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 25.03125 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 25.0625 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 25.09375 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 25.125 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 25.1875 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 25.25 -0.625 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 25.875 -0.0625 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 25.9375 -0.0625 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 26 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 26.0625 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 26.125 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 26.1875 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 26.25 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 26.3125 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 26.375 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 26.4375 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 26.5 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 26.53125 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 26.5625 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 26.59375 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 26.625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 26.65625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 26.6875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 26.71875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 26.75 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 26.875 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 27 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 27.03125 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 27.0625 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 27.09375 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 27.125 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 27.15625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 27.1875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 27.21875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 27.25 0.75 10 pp4 10 1 pp7 1 0 pp10 0 0 pp13 0 16 pp16 16 8 pp19 8 0.015625 pp22 0.015625 1 pp25 1 0.0000152587890625 pp28 0.0000152587890625 0.0625 pp31 0.0625 1 pp34 1 1 pp37 1 1 pp40 1
i 3 28 -1 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 28.5 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 28.53125 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 28.5625 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 28.59375 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 28.625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 28.65625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 28.6875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 28.71875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 28.75 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 28.875 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 29 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 29.0625 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 29.125 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 29.1875 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 29.25 -1.25 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 29.875 -0.03125 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 29.90625 -0.03125 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 29.9375 -0.03125 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 29.96875 -0.03125 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 30 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 30.0625 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 30.125 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 30.1875 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 30.25 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 30.375 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 30.5 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 30.5625 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 30.625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 30.65625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 30.6875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 30.71875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 30.75 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 30.875 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 31 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 31.03125 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 31.0625 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 31.09375 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 31.125 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 31.1875 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 31.25 -1.5 10 pp4 10 1 pp7 1 0 pp10 0 0 pp13 0 16 pp16 16 8 pp19 8 0.015625 pp22 0.015625 1 pp25 1 0.0000152587890625 pp28 0.0000152587890625 0.0625 pp31 0.0625 1 pp34 1 1 pp37 1 1 pp40 1
i 3 32 -0.5 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 32.5 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 32.5625 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 32.625 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 32.6875 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 32.75 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 32.875 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 33 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 33.03125 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 33.0625 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 33.09375 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 33.125 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 33.15625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 33.1875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 33.21875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 33.25 -1.25 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 33.875 -0.03125 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 33.90625 -0.03125 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 33.9375 -0.03125 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 33.96875 -0.03125 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 34 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 34.0625 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 34.125 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 34.1875 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 34.25 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 34.3125 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 34.375 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 34.4375 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 34.5 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 34.5625 -0.0625 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 34.625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 34.65625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 34.6875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 34.71875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 34.75 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 34.8125 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 34.875 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 34.9375 -0.0625 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 35 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 35.03125 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 35.0625 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 35.09375 -0.03125 4 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 35.125 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 35.1875 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 35.25 -1.5 10 pp4 10 1 pp7 1 0 pp10 0 0 pp13 0 16 pp16 16 8 pp19 8 0.015625 pp22 0.015625 1 pp25 1 0.0000152587890625 pp28 0.0000152587890625 0.0625 pp31 0.0625 1 pp34 1 1 pp37 1 1 pp40 1
i 3 36 -0.5 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 36.5 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 36.5625 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 36.625 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 36.6875 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 36.75 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 36.875 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 37 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 37.0625 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 37.125 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 37.15625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 37.1875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 37.21875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 37.25 -0.625 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 37.875 -0.0625 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 37.9375 -0.0625 0 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 38 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 38.0625 -0.0625 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 38.125 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 38.15625 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 38.1875 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 38.21875 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 38.25 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 38.375 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 38.5 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 38.5625 -0.0625 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 38.625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 38.65625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 38.6875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 38.71875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 38.75 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 38.875 -0.125 7 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 39 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 39.03125 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 39.0625 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 39.09375 -0.03125 5 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 39.125 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 39.15625 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 39.1875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 39.21875 -0.03125 3 pp4 np4 1 pp7 np7 0 pp10 np10 0 pp13 np13 16 pp16 np16 8 pp19 np19 0.015625 pp22 np22 1 pp25 np25 0.0000152587890625 pp28 np28 0.0625 pp31 np31 1 pp34 np34 1 pp37 np37 1 pp40 np40
i 3 39.25 -1.5 10 pp4 10 1 pp7 1 0 pp10 0 0 pp13 0 16 pp16 16 8 pp19 8 0.015625 pp22 0.015625 1 pp25 1 0.0000152587890625 pp28 0.0000152587890625 0.0625 pp31 0.0625 1 pp34 1 1 pp37 1 1 pp40 1

e

</CsScore>

</CsoundSynthesizer>