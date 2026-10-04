export default class Scale extends Array {

#divisions;

constructor ( { divisions, interval, size }, ... scale ) {

super ();

this .#divisions = divisions;
this .#interval = interval;
this .#size = size;

let code = 'a' .charCodeAt ( 0 );

for ( const tone of scale ) {

if ( isNaN ( tone ) )
throw TypeError ( tone + " is not a numeric value" );

this [ String .fromCharCode ( code++ ) ] = tone;

};

this .push ( ... scale );

};

tone ( key ) {

const divisions = this .#divisions;
let octave = 0;

if ( key .length > 1 ) {


let value = parseFloat ( key .slice ( 2 ) ) || 1;
let operator = key [ 1 ];

key = key [ 0 ];

switch ( operator ) {

case '*': octave += value; break;
case '/': octave -= value; break;
case '+': octave += value / divisions; break;
case '-': octave -= value / divisions; break;

};

};

const tone = this [ key ];

if ( isNaN ( tone ) )
throw ReferenceError ( "Could not find a tone assigned for the key: " + key );

return tone + octave * divisions;

};

#interval = 2;
#size = 3;

chord ( key ) {

const chord = [];
const divisions = this .#divisions;
const size = this .#size;
const interval = this .#interval;
const tone = this .tone ( key );
const octave = parseInt ( tone / divisions );
const pitch = tone % divisions;
const degree = this .indexOf ( pitch );

for ( let note = 1; note < size; note++ ) {

const chordDegree = ( degree + note * interval ) % this .length;
const chordOctave = octave + parseInt ( ( degree + note * interval ) / this .length );

chord .push ( this [ chordDegree ] + chordOctave * this .#divisions );

};

return chord;

};

};
