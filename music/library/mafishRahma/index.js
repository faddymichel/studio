import Music from '@faddymichel/studio/music/server';
import Scale from '@faddymichel/studio/music/scale';
import Synth from '@faddymichel/studio/music/instrument/synth';

export default await new class MafishRahma extends Music {

tempo = 120;
key = 8;
scale = new Scale (

{ divisions: 8, interval: 2, size: 3 },

0,
1.5,
2.5,

3.5,
5,
6,
7

);

synth = new Synth ( this, { ornaments: [ 3, 2 ] } );

constructor () {

super ();

this .time = 'start';

this .synth .phone = this .synth .track = 'highHat';
this .synth .distance = 2**-8;
this .synth .chord = true;

for ( let repeat = 0; repeat < 100; repeat++ )
this .synth .play (

{ tone: 'a', length: 1/4 },
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
this .synth .octave = 7;
this .synth .chord = true;

for ( let repeat = 0; repeat < 100; repeat++ )
this .synth .play (

{ tone: 'a', length: 1/4, ornaments: [ 3, 3 ] },
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
