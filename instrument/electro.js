import Instrument from '@faddymichel/studio/instrument';

export default class electro extends Instrument {

octave = 8;

distance = 1;

attack = 2**-6;
decay = 2**0;
sustain = 1-2**-4;

sweep = 2**-4;
shift = 32;

lowPass = 2;
highPass = 1;

_header = `

giOudSine ftgen 0, 0, 16384, 10, 1
giOudTransfer ftgen 0, 0, 4097, -7, -0.5, 1024, -0.5, 2048, 0.5, 1024, 0.5

` .trim ();

_body = `

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

` .trim ();

};
