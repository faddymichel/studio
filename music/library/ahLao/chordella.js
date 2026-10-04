import Instrument from '@faddymichel/studio/music/instrument';

export default class chordella extends Instrument {

octave = 7;

distance = 2;

attack = 2**-7;
decay = 2**-1;
sustain = 2**-16;

sweep = 2**-6;
shift = 2**4;

lowPass = 2;
highPass = 0;

_header = `

giChordellaSine ftgen 0, 0, 16384, 10, 1
giChordellaTransfer ftgen 0, 0, 4097, -7, -0.5, 1024, -0.5, 2048, 0.5, 1024, 0.5

giChordellaFT vco2init 31, 1000

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

` .trim ();

};
