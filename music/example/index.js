import Studio from '@faddymichel/studio/server';
import Tabla from '@faddymichel/studio/instrument/tabla';
import Electro from '@faddymichel/studio/instrument/electro';
import Horn from '@faddymichel/studio/instrument/horn';

export default await new class Example extends Studio {

title = 'theExampleBand';

tempo = 105;

tabla = new Tabla ( this );
electro = new Electro ( this );
horn = new Horn ( this );

constructor () {

super ();

const { chord, tabla, electro, horn } = this;
const ornaments = [ 2, 1 ];

//horn .chord = true;
horn .distance = 0;

Object .assign ( electro, {

//chord: true,
distance: 2,
octave: 8,

} );

//chord .rhythm = 2**-10;

chord .set ( -1, [ 3, 7 ] );
chord .set ( 0, [ 4, 9 ] );
chord .set ( 3, [ 7, 10 ] );
chord .set ( 4, [ 9, 13 ] );
chord .set ( 7, [ 10, 16 ] );
chord .set ( 10, [ 16, 20 ] );

for ( let repeat = 0; repeat < 100; repeat++ )
electro .play (

{ ornaments, tone: 0, length: -1/8 }, {}, {},
{ tone: 4 },
{ tone: 3 },
{ tone: 4 },
{ tone: 3 },
{ tone: 0 },
{ tone: 0, length: -1/4 },
{ tone: 0, length: -1/8 },
{ tone: 7, length: -1/4 },
{ ornaments: 0, tone: 10, length: -3/8 },

{ ornaments, tone: 0, length: -1/8 }, {}, {},
{ ornaments, tone: 4 },
{ tone: 3 },
{ tone: 4 },
{ tone: 3 },
{ tone: 0 },
{ tone: 0, length: -1/4 },
{ tone: 0, length: -1/8 },
{ tone: -1, length: -1/4 },
{ ornaments: 0, tone: 0, length: -3/8 },

);

};

} () .play ();
