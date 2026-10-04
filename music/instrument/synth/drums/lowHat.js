export default new class LowHat {

octave = 8;
distance = 0;

attack = 2**-10;
attackType = -( 2**2 );
decay = 2**-2;
decayType = -( 2**4 );

modulator = 2**5;
modulatorSustain = 2**-4;

modulatorSweepAttack = 2**-2;
modulatorSweep = 2**-4;
modulatorSweepSustain = 2**-5;

modulatorFrequency = 2**2;

};
