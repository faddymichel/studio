import Studio from '@faddymichel/studio/music/server';
import Electro from '@faddymichel/studio/music/instrument/electro';
import Horn from '@faddymichel/studio/music/instrument/horn';

export default await new class HaddeshShaf extends Studio {

tempo = 90;

electro = new Electro ( this );
horn = new Horn ( this );

chord = {

on: true

};

constructor () {

super ();

const { chord, electro, horn } = this;
const ornaments = [ 0, 1 ];

horn .distance = 4;

Object .assign ( electro, {

octave: 8,
distance: 1,
attack: 2**-9,
decay: 2**-2,
sustain: 0,
sweep: 2**-8,
shift: 0,

} );

chord .rhythm = 2**-16;

chord [ -1 ] = [ 3, 7 ];
chord [ 0 ] = [ 4, 9 ];
chord [ 3 ] = [ 7, 10 ];
chord [ 4 ] = [ 9, 13 ];
chord [ 7 ] = [ 10, 16 ];
chord [ 10 ] = [ 16, 20 ];

for ( let repeat = 0; repeat < 100; repeat++ )
electro .play (

{ ornaments, tone: 0, length: -3/16 },
{ length: -1/8 },
{ tone: 7, length: -3/16 },
{ tone: 4 },
{ tone: 3, length: -1/8 },
{ tone: 4, length: -3/16 },
{ tone: 0 },
{ tone: -1, length: -1/8 },
{ tone: 0, length: -3/16 }

);

};

} () .play ();
