export default class Instrument {

length = 1/4;
distance = 0;
left = 0;
right = 0;
scale = 16;
octave = 8;
tone = 0;

constructor ( studio ) {

this .#number = ( this .studio = studio ) .kit .push ( this );

};

#phone = new Map;

set phone ( value ) {

if ( ! this .#phone .has ( phone ) )
this .#phone .set ( value, Object .assign ( {}, this ) );

Object .assign ( this, this .#phone .get ( value ) );

};

#number;

get number () { return `${ this .#number }.${ this .#phone .number }` };

#name = this .constructor .name;

get name () { return this .#name };

set name ( value ) {

if ( typeof value !== 'string' || ! value .length )
throw TypeError ( `Instrument name is expected to be a nonempty string; ${ value } was found instead.` );

return this .#name = value;

};

set time ( value ) {

const { clock } = this .studio;

switch ( typeof value ) {

case 'number':

clock .time = value;

break;

case 'string':

if ( ! clock .has ( value ) )
clock .set ( value, clock .time );

clock .time = clock .get ( value );

break;

default:

throw TypeError ( "Instrument time may only be set to either a number or a string (in case of marking current clock time)" );

}

};

get parameters () {

return new Map ( Object .entries ( this )
.filter ( ( [ parameter, value ] ) => ! parameter ?.startsWith ?.( '_' ) && ( typeof value === 'number' || typeof value === 'string' ) ) );

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

document .push ( `instr ${ parseInt ( this .number ) }, ${ this .name }` );

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

#chord = false;

get chord () {

return [ this .tone, ... this .#chord ? ( this .studio .chord .get ( this .tone ) || [] ) : [] ];

};

set chord ( value ) {

if ( typeof value !== 'boolean' )
throw TypeError ( "Instrument chord can be turned on or off by passing true or false only" );

this .#chord = value;

};

play ( note, ... notes ) {

if ( note === undefined )
return this;

if ( typeof note === 'number' || note instanceof Array )
note = { tone: note };

if ( typeof note !== 'object' )
throw TypeError ( "A `note` may only be an object or number" );

Object .assign ( this, note );

if ( this .#ornaments ?.level > 0 && note ._ornaments === undefined ) {

const ornaments = note ._ornaments = {};
const { length } = this;
const range = this .#ornaments .range || 0;
const level = this .#ornaments .level;

ornaments .count = 2**parseInt ( level - range + Math .random () * range );
ornaments .length = -Math .abs ( length / ornaments .count );

for ( let ornament = 1; ornament < ornaments .count; ornament++ )
notes .unshift ( Object .assign ( {}, note ) );

if ( length > 0 ) {

ornaments .length = Math .abs ( ornaments .length );

}

}

const { studio: { clock }, length, tone, chord } = this;
const { time } = clock;

this .length = note ._ornaments ? note ._ornaments .length : this .length;

chord .forEach ( ( tone, index ) => {

clock .time = time + index * ( ( this .studio .chord .rhythm || 0 ) );
this .tone = tone;

let number = parseInt ( this .number ) + index / 1000;

this .#score .push ( [

'i', number, clock .time, this .length,
... [ ... this .parameters .values () ] .map ( ( value, index ) => {

const number = 4 + index * 3;

return [

typeof value === 'number' ? value : `"${ value }"`,
`pp${ number }`,
`np${ number }`

] .join ( ' ' );

} )

] .join ( ' ' ) );

} );

clock .time = time + Math .abs ( this .length );
this .length = length;
this .tone = tone;

return this .play ( ... notes );

};

};
