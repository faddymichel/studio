interval = 2;
size = 3;

chord ( tone = 0 ) {

const chord = [];
const { interval, size, scale } = this;
const octave = parseInt ( tone / scale .divisions );
const pitch = tone % scale .divisions;
const degree = scale .indexOf ( pitch );

for ( let note = 0; note < size; note++ )
chord .push (

scale [ ( degree + note * interval ) % scale .length ]

);

return chord;

};
