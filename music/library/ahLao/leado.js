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

_body = `

` .trim ();

};
