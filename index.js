export default class Studio {

kit = [];
options = '-o dac';
rate = { sample: 48000, control: 64 };
key = 0;
clock = Object .assign ( new Map, { time: 0 } );
chord = new Map;

#title;

get title () {

return this .#title || this .constructor .name;

};

set title ( value ) { this .#title = value };

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

alwayson "output"

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

${ this .kit .map (

instrument => instrument .document

) .join ( '\n\n' ) }

</CsInstruments>

<CsScore>

t 0 ${ this .tempo }

v 4

${ this .kit .map (

instrument => instrument .score

) .join ( '\n\n' ) }

</CsScore>

</CsoundSynthesizer>`;

};

};
