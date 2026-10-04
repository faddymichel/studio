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

giStrike ftgen 0, 0, 256, 1, "$studio/prerequisites/marmstk1.wav", 0, 0, 0
giVibrato ftgen 0, 0, 128, 10, 1

instr 1, tabla

iPDistance init p4
iPreviousDistance init p5
iNextDistance init p6

iPLeft init p7
iPreviousLeft init p8
iNextLeft init p9

iPRight init p10
iPreviousRight init p11
iNextRight init p12

iPScale init p13
iPreviousScale init p14
iNextScale init p15

iPOctave init p16
iPreviousOctave init p17
iNextOctave init p18

iPTone init p19
iPreviousTone init p20
iNextTone init p21

iPAttack init p22
iPreviousAttack init p23
iNextAttack init p24

iPDecay init p25
iPreviousDecay init p26
iNextDecay init p27

iPSustain init p28
iPreviousSustain init p29
iNextSustain init p30

iPRelease init p31
iPreviousRelease init p32
iNextRelease init p33

iPSweep init p34
iPreviousSweep init p35
iNextSweep init p36

iPShift init p37
iPreviousShift init p38
iNextShift init p39

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

i 1 0 -1 0 pp4 np4 0 pp7 np7 0 pp10 np10 16 pp13 np13 5 pp16 np16 0 pp19 np19 0.03125 pp22 np22 0.25 pp25 np25 0.125 pp28 np28 1 pp31 np31 0.03125 pp34 np34 8 pp37 np37
i 1 1 -1 0 pp4 np4 0 pp7 np7 0 pp10 np10 16 pp13 np13 5 pp16 np16 0 pp19 np19 0.03125 pp22 np22 0.25 pp25 np25 0.125 pp28 np28 1 pp31 np31 0.03125 pp34 np34 8 pp37 np37
i 1 2 -1 0 pp4 np4 0 pp7 np7 0 pp10 np10 16 pp13 np13 5 pp16 np16 0 pp19 np19 0.03125 pp22 np22 0.25 pp25 np25 0.125 pp28 np28 1 pp31 np31 0.03125 pp34 np34 8 pp37 np37
i 1 3 1 0 pp4 0 0 pp7 0 0 pp10 0 16 pp13 16 5 pp16 5 0 pp19 0 0.03125 pp22 0.03125 0.25 pp25 0.25 0.125 pp28 0.125 1 pp31 1 0.03125 pp34 0.03125 8 pp37 8

e

</CsScore>

</CsoundSynthesizer>