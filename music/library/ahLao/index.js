import Studio from '@faddymichel/studio/music/server';
import Scale from '@faddymichel/studio/music/scale';
import Synth from './synth/index.js';

export default await new class AhLao extends Studio {

tempo = 90;
key = 8;
scale = new Scale (

{ divisions: 8, interval: 2, size: 3 },

0,
1.5,
2,

4,
4.5,
6,
6.5

);

synth = new Synth ( this, { ornaments: [ 3, 2 ] } );

constructor () {

super ();

this .time = 'start';

this .synth .phone = 'highHat';
this .synth .distance = 2**-8;
//this .synth .chord = true;

for ( let repeat = 0; repeat < 100; repeat++ )
this .synth .play (

{ tone: 'a', time: 'start', length: 1/4 },
'b',
'c',
'd',
'e',
'f',
'g',
'a*',

'a*',
'g',
'f',
'e',
'd',
'c',
'b',
'a'

);

this .time = 'start';

this .synth .phone = 'piano';
this .synth .distance = 2**-1;
this .synth .chord = true;

for ( let repeat = 0; repeat < 100; repeat++ )
this .synth .play (

{ tone: 'a', time: 'start', length: 1/4, ornaments: [ 3, 3 ] },
'b',
'c',
'd',
'e',
'f',
'g',
'a*',

'a*',
'g',
'f',
'e',
'd',
'c',
'b',
'a'

);

};

} () .play ();
