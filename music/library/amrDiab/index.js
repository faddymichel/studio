import Studio from '@faddymichel/studio/music/server';
import Horn from '@faddymichel/studio/music/instrument/horn';
import Chordella from './chordella.js';
import Leado from './leado.js';
import Ragien from './ragien.js';

export default await new class HaddeshShaf extends Studio {

tempo = 105;
key = 8;

horn = new Horn ( this, { ornaments: [ 1, -1 ] } );
chordella = new Chordella ( this, { ornaments: [ 0, -1 ] } );
leado = new Leado ( this, { ornaments: [ 0, 0 ] } );

chord = {

on: true,
rhythm: 2**-8,

[-5]: [ 0, 4],
[-1]: [ 3, 7 ],
0: [ 4, 10 ],
3: [ 7, 11 ],
4: [ 10, 15 ],
7: [ 11, 16 ],
10: [ 15, 19 ],
11: [ 16, 20 ],
15: [ 19, 23 ],
16: [ 20, 26 ],

};

ragien = new Ragien ( this );

} () .play ();
