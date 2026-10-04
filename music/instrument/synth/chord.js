export default new class Chord {

octave = 7;
distance = 0;

attack = 2**-7;
attackType = -( 2**5 );
decay = 2**-0;
decayType = -( 2**3 );

modulator = 2**3;
modulatorSustain = 2**-1;

modulatorSweepAttack = 2**-1;
modulatorSweep = 2**-1;
modulatorSweepSustain = 2**-1;

modulatorVibrato = 2**1;

modulatorFrequency = 2**-0;

};
