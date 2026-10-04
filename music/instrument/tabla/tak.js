import Tabla from '@faddymichel/studio/music/instrument/tabla';

export default class Tak extends Tabla {

octave = 8;
tone = 0;

[ Symbol .for ( 'chord' ) ] = [ 7, 10 ];
[ Symbol .for ( 'chord/rhythm' ) ] = 2**-9;

#distance = 4;

left = this .#distance;
right = this .#distance;

attack = 2**-6;
decay = 2**-4;
sustain = 2**-3;
release = 2**-3;

sweep = 2**-7;
shift = 2**2;

};
