import Instrument from '@faddymichel/studio/music/instrument';

export default class Music {

kit = [];
options = '-o dac';
rate = { sample: 48000, control: 64 };
key = 0;

#instrument = 0;

instrument ( instrument ) {

if ( instrument instanceof Instrument )
this .kit .push ( instrument );

return ++this .#instrument;

};

#title;

get title () {

return this .#title || this .constructor .name;

};

set title ( value ) { this .#title = value };

clock = Object .assign ( new Map, { time: 0 } );

get time () { return this .clock .time };

set time ( value ) {

const { clock } = this;

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

skip ( till ) {

this .time = till;

this .#score .push ( `a 0 0 ${ this .time * 4 }` );

};

get document () {

return `<CsoundSynthesizer>

<CsOptions>

${ this .options }

</CsOptions>

<CsInstruments>

sr = ${ this .rate .sample }
ksmps = ${ this .rate .control }
nchnls = 2
0dbfs = 1

giKey init ${ this .key }

#define studio #${ new URL ( import .meta .url ) .pathname .split ( '/' ) .slice ( 0, -1 ) .join ( '/' ) }#

${ this .kit .map (

instrument => instrument .document

) .join ( '\n\n' ) }

instr output

aLeft chnget "left"
aRight chnget "right"

denorm aLeft
denorm aRight

aLeft clip aLeft, 1, 0dbfs
aRight clip aRight, 1, 0dbfs

outs aLeft, aRight

chnclear "left"
chnclear "right"

endin

instr loopback

rewindscore

endin

</CsInstruments>

<CsScore>

${ this .score }

</CsScore>

</CsoundSynthesizer>`;

};

#score = [];

get score () {

return `

${ this .#score .join ( '\n' ) }

i "output" 0 -1

t 0 ${ this .tempo }

v 4

${ this .kit .map (

instrument => instrument .score

) .join ( '\n\n' ) }

${ this .#end }

` .trim ();

};

#end = 'e';

loopback () {

this .#end = `i "loopback" ${ this .clock .time } 1`;

};

};
