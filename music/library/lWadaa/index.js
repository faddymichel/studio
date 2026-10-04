import Music from '@faddymichel/studio/music/server';
import Scale from '@faddymichel/studio/music/scale';
import Synth from '@faddymichel/studio/music/instrument/synth'
import nota from './nota.js';

export default await new class LWadaa extends Music {

tempo = 82.5;
key = 0;
scale = new Scale (

{ divisions: 8, interval: 2, size: 3 },

0,
.5,
2.5,

3,
4.5,
6,
6.5

);

synth = new Synth ( this );

constructor () {

super ();

const music = this;
const { synth } = music;

music .time = 'scale';

synth .phone = 'piano';
synth .distance = 2**-16;
synth .octave = 8;
synth .chord = false;

synth .play ( ... nota .scale );

music .time = 'scale.chord';
synth .play ( ... nota .scale );

music .time = 'scale.chord';

synth .phone = 'chord';
synth .distance = 2**-2;
synth .chord = true;
synth .octave = 7;

synth .play ( ... nota .scale );

music .time = 'tempo';

synth .phone = 'lowHat';
synth .distance = 0;
synth .octave = 8;
synth .chord = true;

for ( let repeat = 0; repeat < 31; repeat++ )
synth .play ( ... nota .tempo );

music .time = 'tempo';
music .time += 2;
music .time =  'Verse 1';
music .time += 1/8;

for ( let repeat = 0; repeat < 2; repeat++ ) {

synth .phone = 'piano';
synth .octave = 8;
synth .distance = 2**-16;
synth .chord = false;
synth .ornaments = [ 0, -2 ];

synth .play (

{ tone: repeat === 0 ? 'd' : 'e', length: 1/8 },
{},
{ tone: repeat === 0 ? 'c' : 'd' },
'd',
'c',
'b',
'a',
'b',
'a',
'g/',
'f/',
'g/',
'a',
'b',
'c',
'd',

'd',
'c',
'd',
'e',
'd',
'c',
'd',
{ tone: 'e', length: 1/4 }, {}

);

synth .phone = 'flute';
synth .octave = 9;
synth .distance = 2**-16;

synth .play (

{ tone: 'a', length: 1/8 },
'b',
'c',
'd',
'e'

);

};


music .time = 'Chorus 1';

synth .phone = 'piano';
synth .octave = 8;

synth .play (

{ tone: 'g', length: 1/8 },
'g',
'f',
'g',
'f',
'g',
'f',
{ tone: 'a*', length: 1/4 },
{ length: 1/8 },
'g',
'f-1',
'e',
'f-1',
'e',
'd',

'f-1',
{},
'e',
{ tone: 'd', length: 1/4 },
'c',
'd',
{ tone: 'd', length: 1/8 }

);

synth .phone = 'flute';

synth .play (

{ tone: 'a', length: 1/8 },
'b',
'a',
'b',
'c',
'd'

);

music .time = 'Chorus 1.2';

synth .phone = 'piano';
synth .octave = 8;

synth .play (

{ tone: 'g', length: 1/4 },
{ tone: 'f', length: 1/8 },
'g',
'f',
'g',
'f',
{ tone: 'a*', length: 1/4 },
{ length: 1/8 },
'g+1',
'a*',
'g+1',
'f-1',
'e',
'd',

'f-1',
{},
'e',
{ tone: 'd', length: 1/4 },
'd',
'g',
{ length: 1/8 },
'a*',
'f-1',
'e',
'f-1',
'e',
{ tone: 'd', length: 1/4 }

);

music .time = 'PostChorus 1';

synth .phone = 'piano';
synth .octave = 8;

synth .play (

{ tone: 'a', length: 1/4 },
'b',
'c',
'd',
{ length: 1/8 }

);

synth .phone = 'flute';

synth .play (

{ tone: 'a', length: 1/8 },
'b',
'a',
'b',
'c',
{ tone: 'd', length: 1/4 }

);

synth .phone = 'piano';
synth .octave = 8;

synth .play (

{ tone: 'a', length: 1/4 },
'b',
'c',
'd',
{ length: 1/8 }

);

synth .phone = 'flute';

synth .play (

{ tone: 'e', length: 1/8 },
'd',
'c',
'd',
'e',
{ tone: 'f-1', length: 1/4 }

);

synth .phone = 'piano';
synth .octave = 8;

synth .play (

{ tone: 'e', length: 1/8 },
'f-1',
{ tone: 'g', length: 1/4 },
{ tone: 'f-1', length: 1/8 },
'e',
{ tone: 'f-1', length: 1/4 },
{ tone: 'd', length: 1/8 },
'c',
{ tone: 'd', length: 1/4 }

);

synth .phone = 'flute';

synth .play (

{ tone: 'b', length: 1/8 },
'a',
{ tone: 'g/', length: 1/4 }

);

synth .phone = 'piano';
synth .octave = 8;

synth .play (

{ tone: 'e', length: 1/8 },
'f-1',
{ tone: 'g', length: 1/4 },
{ length: 1/8 },
{},
{ tone: 'a*', length: 1/4 },
'f-1',

);

music .time = 'Outro 1';

synth .play (

{ tone: 'g', length: 1/4 },
{ tone: 'f-1', length: 1/8 },
'e',
{ tone: 'b', length: 1/4 },
'c',
'd',
'e',
'f-1',
'g',

{ tone: 'a*', length: 1/8 },
'b*',
'c*',
'b*',
{ tone: 'a*', length: 1/4 },
{ length: 1/8 },

{ tone: 'g', length: 1/8 },
'a*',
'b*',
'c*',
'b*',
{ tone: 'a*', length: 1/4 },
{ length: 1/8 },

{ tone: 'g', length: 1/8 },
'a*',
'b*',
'c*',
'b*',
'd*',
'c*',
'b*',
'g',
{ tone: 'a*', length: 1/4 },
{ length: 1/8 },
{},
{},
{},
{ ornaments: [ 0, 0 ], length: 3/4 }

);

music .time =  'Verse 1';
music .time -= 1;

synth .phone = 'chord';
synth .distance = 2**-2;
synth .chord = true;
synth .octave = 7;
synth .ornaments = [ 0, -0 ];

for ( let repeat = 0; repeat < 30; repeat++ )
synth .play (

{ length: 1.5/8, tone: 'g/' },
'a',
{ length: 1/8, tone: 'a' },
{ length: 2/8, tone: 'g/' },
'a'

);

//music .skip ( 'tempo' );

};

} () .play ();
