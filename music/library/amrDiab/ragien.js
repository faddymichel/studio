export default class Ragien {

constructor ( music ) {

const { leado, chordella, chord } = music;

chord .on = true;

music .time = this .constructor .name;
music .time += 0

chordella .distance = 0;
chordella .phone = { name: 'low', octave: 7 };
chordella .phone = { name: 'medium', octave: 8 };

for ( let repeat = 0; repeat < 10; repeat++ ) {

chordella .play (

/*
... this .#chord ( 7, 7, 7 ),
... this .#chord ( 4, 3, 7 ),
... this .#chord ( 4, 3, 0 ),
... this .#chord ( -5, -1, 0 ),

... this .#chord ( 3, 4, 7 ),
... this .#chord ( 7, 7, 4 ),
... this .#chord ( 3, 7, 4 ),
... this .#chord ( 3, 10, 10 ),
... this .#chord ( 10, 10, 10 ),
*/

... this .#chord ( 4, 7, 7 ),
... this .#chord ( 3, 4, 4 ),
... this .#chord ( 3, 0, 0 ),
... this .#chord ( -1, 0, 0 ),

... this .#chord ( 3, 3, 3 ),
... this .#chord ( 3, 4, 4 ),
... this .#chord ( 4, 10, 10 ),
... this .#chord ( 15, 16, 16 ),

);

};

chord .on = false;

music .time = this .constructor .name;
music .time += 0

leado .distance = 1;

for ( let repeat = 0; repeat < 10; repeat++ ) {

leado .play (

{ tone: 7, length: 4/8 },

{ ornaments: [ 3, 2 ], tone: 4 + ( repeat % 2 === 0 ? 0 : 1 ), length: 1/8 },
{ tone: 3 },
{ tone: 7, length: 2/8 },

{ tone: 4 + ( repeat % 2 === 0 ? 0 : 1 ), length: 1/8 },
{ tone: 3 },
{ ornaments: 0, tone: 0, length: 5/8 },
{ ornaments: [ 3, 2 ], tone: 0, length: 1/8 },

{ tone: 3 },
{ tone: 4 + ( repeat % 2 === 0 ? 0 : 1 ) },
{ tone: 7, length: 2/8 },

{ tone: 4 + ( repeat % 2 === 0 ? 0 : 1 ), length: 1/8 },
{ tone: 3 },
{ tone: 7, length: 2/8 },

{ tone: 4 + ( repeat % 2 === 0 ? 0 : 1 ), length: 1/8 },
{ tone: 3 },
{ ornaments: 0, tone: 10, length: 6/8 },

);

};

};

#chord ( a, b, c ) {

return [

{ phone: 'low', tone: a, length: 1.5/8 },

{ phone: 'low', tone: b, length: 1.5/8 },

{ phone: 'low', tone: c, length: 1/8 },

];

};

};
