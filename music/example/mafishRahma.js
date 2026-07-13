import Studio from '@faddymichel/studio/server';
import Electro from '@faddymichel/studio/instrument/electro';
import Horn from '@faddymichel/studio/instrument/horn';

export default await new class MafishRahma extends Studio {

tempo = 105;
key = 8;

electro = new Electro ( this );
horn = new Horn ( this );

constructor () {

super ();

const { chord, electro, horn } = this;

horn .distance = 4;

Object .assign ( electro, {

chord: true,
ornaments: [ 2, 2 ],
octave: 8,
distance: 1,
attack: 2**-7,
decay: 2**-2,
sustain: 0,
sweep: 2**-8,
shift: 0,

} );

chord .rhythm = 2**-16;

chord .set ( -2, [ 3, 7 ] );
chord .set ( 0, [ 5, 10 ] );
chord .set ( 3, [ 7, 11 ] );
chord .set ( 5, [ 10, 14 ] );
chord .set ( 7, [ 11, 16 ] );

for ( let repeat = 0; repeat < 100; repeat++ )
electro .play (

{ tone: 0, length: 1/8 },
{ tone: 7, length: 1/4 },
{ tone: 5, length: 1/8 },
{ tone: 3 },
{ tone: 5, length: 1/4 },
{ tone: -2, length: 1/8 }, {},
{ tone: 0, length: 1/4 }, { length: 1/8 }

);

};

} () .play ();
