import Instrument from '@faddymichel/studio/music/instrument';
import highHat from './drums/highHat.js';
import lowHat from './drums/lowHat.js';
import flute from './flute.js'
import piano from './piano.js';
import chord from './chord.js';

export default class Synth extends Instrument {

constructor ( ... argv ) {

super ( ... argv );

this .phone = { name: 'root' };
this .phone = { name: 'highHat', ... highHat };
this .phone = { name: 'lowHat', ... lowHat };
this .phone = { name: 'flute', ... flute };
this .phone = { name: 'piano', ... piano };
this .phone = { name: 'chord', ... chord };

};

scale = 8;

octave = 7;
distance = 0;

attack = 2**-5;
attackType = ( 2**4 );
decay = 2**-0;
decayType = -( 2**-1 );

modulator = 2**4;
modulatorSustain = 2**-0;

modulatorSweepAttack = 2**-1;
modulatorSweep = 2**-3;
modulatorSweepSustain = 2**-3;

modulatorVibrato = 2**2;

modulatorFrequency = 2**-0;

_body = `

iAmplitude init ( 1 / ( 1 + iPDistance ) ) * sqrt ( 2^5 / iFrequency )

iPAttack *= iLength
iPDecay *= iLength - iPAttack

anAmplitude transeg 0, iPAttack, iPAttackType, iAmplitude, iPDecay, iPDecayType, 0

iPModulator *= iFrequency
iPModulatorSustain *= iPModulator

aFrequencyModulator transeg 0, iPAttack, iPAttackType, iPModulator, iPDecay, iPDecayType, iPModulatorSustain

iPModulatorSweep *= iPModulatorSweepAttack
iPModulatorSweepSustain *= iPModulatorSweep

aModulatorSweep transeg iPModulatorSweepAttack, iPAttack, iPAttackType, iPModulatorSweep, iPDecay, iPDecayType, iPModulatorSweepSustain

aFrequencyModulator *= aModulatorSweep

aModulatorVibrato rspline 2^-( iPModulatorVibrato ), 2^( iPModulatorVibrato ), 0, iLength * 2^-2

iPModulatorFrequency *= iFrequency

aFrequency poscil3 aFrequencyModulator + aModulatorVibrato, iPModulatorFrequency + aModulatorVibrato

aFrequencyBend transeg 1, iLength - iPAttack, 8, 2^( -( iNextTone - iPTone ) / iPScale )

aNote poscil3 anAmplitude, ( iFrequency + aFrequency ) * aFrequencyBend

aLeft = aNote
aRight = aNote

` .trim ();

};
