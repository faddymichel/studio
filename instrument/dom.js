import Tabla from '@faddymichel/studio/instrument/tabla';

export default class Dom extends Tabla {

octave = 5;

#distance = 0;

left = this .#distance;
right = this .#distance;

attack = 2**-5;
decay = 2**-1;
sustain = 2**-3;
release = 2**0;

sweep = 2**-5;
shift = 2**4;

};
