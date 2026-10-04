import Instrument from '@faddymichel/studio/music/instrument';

export default class leado extends Instrument {

octave = 8;

distance = 0;

attack = 2**-6;
decay = 2**-0;
sustain = (2**-16);

sweep = 2**-4;
shift = 2**0;

lowPass = 1;
highPass = 1;

_header = `

giLeadoSine ftgen 0, 0, 16384, 10, 1
giLeadoTransfer ftgen 0, 0, 4097, -7, -0.5, 1024, -0.5, 2048, 0.5, 1024, 0.5

giLeadoFT vco2init 31, 1000

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

` .trim ();

};
