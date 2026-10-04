import Instrument from '@faddymichel/studio/music/instrument';

export default class chordella extends Instrument {

octave = 7;

distance = 3;

attack = 2**-8;
decay = 2**-2;
sustain = 2**-16;

sweep = 2**-16;
shift = 2**5;

lowPass = 2;
highPass = -2;

_header = `

giChordellaSine ftgen 0, 0, 16384, 10, 1
giChordellaTransfer ftgen 0, 0, 4097, -7, -0.5, 1024, -0.5, 2048, 0.5, 1024, 0.5

` .trim ();

_body = `

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
aVibrato poscil aVibratoAmplitude * 2^4, 2^6

aFrequency += aVibrato

aLowPass = aFrequency * 2^iPLowPass
aHighPass = aFrequency / 2^iPHighPass

aNote = 0

;a1 pluck k ( aAmplitude ), k ( aFrequency ), iFrequency, 0, 1, iLength + 3

;aNote += a1

aClip rspline 0, 1, 1/iLength, 2/iLength
aSkew rspline -1, 1, 4/iLength, 8/iLength

;a4 squinewave aFrequency, aClip, aSkew
;a4 *= aAmplitude
;aNote += a4

a5 foscil k ( aAmplitude ), k ( aFrequency ), 1, 1, 1, giChordellaSine

aNote += a5 / 2^0

;a6 foscil k ( aAmplitude ), k ( aFrequency ), 1.5, 2.5, .5 + k ( aClip * 3 ), giChordellaSine

;aNote *= a6 / 2^0

;aWaveAmplitude poscil aAmplitude, aFrequency
;aWaveAmplitude = aNote
;aWaveIndex = ( aWaveAmplitude + 1 ) / 2
;aWave tablei    aWaveIndex, giChordellaTransfer, 1

;aNote = aWave

tigoto skip

;aNote clip aNote, 1, 1

aNote butterlp aNote, aLowPass
aNote butterhp aNote, aHighPass

aNote clip aNote, 1, 1

denorm aNote

aLeft = aNote
aRight = aNote

skip:

` .trim ();

};
