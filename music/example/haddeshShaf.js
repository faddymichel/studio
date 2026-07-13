import Studio from '@faddymichel/studio/server';
import Electro from '@faddymichel/studio/instrument/electro';
import Horn from '@faddymichel/studio/instrument/horn';

export default await new class HaddeshShaf extends Studio {

tempo = 90;

electro = new Electro ( this );
horn = new Horn ( this );

constructor () {

super ();

const { chord, electro, horn } = this;
const ornaments = [ 0, 1 ];

horn .distance = 4;

Object .assign ( electro, {

chord: true,
octave: 8,
distance: 1,
attack: 2**-9,
decay: 2**-2,
sustain: 0,
sweep: 2**-8,
shift: 0,

} );

chord .rhythm = 2**-16;

chord .set ( -1, [ 3, 7 ] );
chord .set ( 0, [ 4, 9 ] );
chord .set ( 3, [ 7, 10 ] );
chord .set ( 4, [ 9, 13 ] );
chord .set ( 7, [ 10, 16 ] );
chord .set ( 10, [ 16, 20 ] );

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
