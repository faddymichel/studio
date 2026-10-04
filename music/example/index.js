import Music from '@faddymichel/studio/music/server';
import Tabla from '@faddymichel/studio/music/instrument/tabla';
import Electro from '@faddymichel/studio/music/instrument/electro';
import Horn from '@faddymichel/studio/music/instrument/horn';

export default await new class Example extends Music {

title = 'theExampleBand';

tempo = 105;

tabla = new Tabla ( this );
electro = new Electro ( this );
horn = new Horn ( this );

constructor () {

super ();

const { tabla, electro, horn } = this;
const ornaments = [ 2, 1 ];

horn .distance = 0;

Object .assign ( electro, {

distance: 2,
octave: 8,

} );


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
