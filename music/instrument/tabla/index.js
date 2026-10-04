import Instrument from '@faddymichel/studio/music/instrument';

export default class tabla extends Instrument {

octave = 5;

distance = 0;

attack = 2**-5;
decay = 2**-2;
sustain = 2**-3;
release = 2**0;

sweep = 2**-5;
shift = 2**3;

_header = `

giStrike ftgen 0, 0, 256, 1, "$studio/prerequisites/marmstk1.wav", 0, 0, 0
giVibrato ftgen 0, 0, 128, 10, 1

` .trim ();

_body = `

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

` .trim ();

};
