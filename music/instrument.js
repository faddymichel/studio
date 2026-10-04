export default class Instrument {

#length = 1/4;

get length () { return Math .abs ( this .#length ) };

set length ( value ) {

if ( typeof value !== 'number' && length < 0 )
throw TypeError ( "Instrument note length is expected to be a non-negative number" );

this .#length = value;

};

distance = 0;
left = 0;
right = 0;
scale = 16;
octave = 8;

get number () { return this .#phone .active .number };

constructor ( music, parameters ) {

this .music = music;
this .phone = {

instrument: this,
name: this .constructor .name,
... parameters

};

};

#phone = new Map;

set phone ( value ) {

if ( typeof value === 'string' )
value = { name: value };

if ( typeof value !== 'object' )
throw TypeError ( "A 'string' or 'object' is required to set the phone of this instrument" );

const { instrument, name, ... preset } = value;

if ( typeof name !== 'string' || !name .length )
throw TypeError ( "A non-empty 'string' name is required to set this instrument's phone" );

if ( ! this .#phone .has ( name ) )
this .#phone .set ( name, {

number: this .music .instrument ( instrument ),
preset: Object .assign ( {}, Object .fromEntries ( this .parameters ) )

} );

Object .assign (

this,
Object .assign ( this .#phone .get ( name ) .preset, preset )

);

this .#phone .active = { name, number: this .#phone .get ( name ) .number };

};

get phone () { return this .#phone .active };

#name = this .constructor .name;

get name () { return this .#name };

set name ( value ) {

if ( typeof value !== 'string' || ! value .length )
throw TypeError ( `Instrument name is expected to be a nonempty string; ${ value } was found instead.` );

return this .#name = value;

};

get parameters () {

return new Map ( [

[ 'tone', this .tone ],
... Object .entries ( this )
.filter ( ( [ parameter, value ] ) => ! parameter ?.startsWith ?.( '_' ) && ( typeof value === 'number' || typeof value === 'string' ) )

] );

};

get variables () {

return [ ... this .parameters ] .map ( ( [ parameter, value ], index ) => {

const type = typeof value === 'number' ? 'i' : 'S';
const name = parameter [ 0 ] .toUpperCase () + parameter .slice ( 1 );
const number = 4 + index * 3;
const operator = type === 'i' ? 'init' : 'strget';

return [

`${ type }P${ name } ${ operator } p${ number }`,
`${ type }Previous${ name } ${ operator } p${ number + 1 }`,
`${ type }Next${ name } ${ operator } p${ number + 2 }`

] .join ( '\n' );

} ) .join ( '\n\n' );

};

get document () {

const document = [];

if ( typeof this ._header === 'string' && this ._header .length )
document .push ( this ._header .trim () );

const numbers = [];

for ( const { number } of this .#phone .values () )
numbers .push ( number );

document .push ( `instr ${ numbers .join ( ', ' ) }` );

const { variables } = this;

if ( variables .length )
document .push ( variables );

document .push ( `

iLength init abs ( p3 )
iFrequency init 2^( iPOctave + ( ( giKey + iPTone ) / iPScale ) )
iNextFrequency init 2^( iNextOctave + ( ( giKey + iNextTone ) / iNextScale ) )

` .trim () );

if ( typeof this ._body === 'string'  && this ._body .length )
document .push ( this ._body .trim () );

document .push ( `

iPDistance += 1

chnmix aLeft / iPDistance / ( iPLeft + 1 ), "left"
chnmix aRight / iPDistance / ( iPRight + 1 ), "right"

` .trim () );

document .push ( 'endin' );

return document .join ( '\n\n' );

};

#score = [];

get score () { return this .#score .join ( '\n' ) };

#ornaments = { level: 0, range: 0 };

get ornaments () {

const ornaments = { ... this .#ornaments };

ornaments .count = 2**parseInt ( ornaments .level - ornaments .range + Math .random () * ornaments .range );
ornaments .length = this .length / ornaments .count;

return ornaments;

};

set ornaments ( value ) {

if ( ! ( value instanceof Array ) )
value = [ value ];

if ( ! value .length || value .length > 2 )
throw RangeError ( "Insufficient number of values provided to instrument ornaments" );

value = value .map ( value => {

if ( typeof value !== 'number' )
throw TypeError ( "Values of instrument ornaments may only be numbers" );

return parseInt ( value );

} );

this .#ornaments .level = value .shift ();

if ( value .length )
this .#ornaments .range = value .shift ();

};

#tone = 0;
#key = 'a';

get tone () { return this .#tone };
get key () { return this .#key };

set tone ( value ) {

switch ( typeof value ) {

case 'string':

this .#key = value;

return this .#tone = this .music .scale .tone ( value );

case 'number':
return this .#tone = value;

default:
throw TypeError ( "Unrecognized instrument tone value: " + value );

};

};

#chord = false;

get chord () { return this .#chord };

set chord ( value ) {

if ( typeof value !== 'boolean' )
throw TypeError ( "Chord value is expected to be a boolean" );

this .#chord = value;

};

play ( note, ... notes ) {

if ( note === undefined )
return this;

if ( typeof note === 'number' || typeof note === 'string' )
note = { tone: note };

if ( typeof note !== 'object' )
throw TypeError ( "A `note` may only be an 'object', 'number' or 'string'" );

Object .assign ( this, note );

const { music: { clock }, length, tone, key, ornaments } = this;
const chord = this .chord ? this .music .scale .chord ( key ) : [ tone ];
const { time } = clock;

this .length = ornaments .length;

for ( let ornament = 0; ornament < ornaments .count; ornament++ )
chord .forEach ( ( tone, index ) => {

clock .time = time + ( index * ( this .music ?.chord ?.rhythm || 0 ) ) + ( ornament * ornaments .length );
this .tone = tone;

let number = this .number + index / 10000;
const order = !notes .length ? 'last' : undefined;

this .#score .push ( [

'i', number, clock .time,
!notes .length && ornament === ornaments .count - 1 ? this .length : -this .length,
... [ ... this .parameters .values () ] .map ( ( value, index ) => {

const parameter = typeof value === 'number' ? value : `"${ value }"`;
const number = 4 + index * 3;

return [

parameter,
order === 'first' ? parameter : `pp${ number }`,
order === 'last' ? parameter : `np${ number }`

] .join ( ' ' );

} )

] .join ( ' ' ) );

} );

this .tone = tone;
this .length = length;
clock .time = time + Math .abs ( this .length );

return this .play ( ... notes );

};

};
