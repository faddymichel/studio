import Instrument from '@faddymichel/studio/music/instrument';

export default class horn extends Instrument {

octave = 8;

distance = 1;

attack = 2**-2;
decay = 2**-2;
sustain = 1-2**-8;

sweep = 2**-3;
bend = 2**-3;
shift = 1;

lowPass = 2;
highPass = 1;

_header = `

giHornTransfer ftgen 0, 0, 4097, -7, -0.5, 1024, -0.5, 2048, 0.5, 1024, 0.5

` .trim ();

_body = `

iTied tival

iPAttack *= iLength
iPDecay *= iLength
iPRelease init iPAttack

if iPAttack + iPDecay + iPRelease > iLength/8 then

iPAttack init iLength/4
iPRelease init iPAttack
iPDecay init iLength - iPAttack - iPRelease

;iPDecay *= iXLength
;iPRelease *= iXLength

endif

if iTied == 0 then
; && p3 > 0 then

aAmplitude linsegr 0, iPAttack, 1, iPDecay, iPSustain, iPRelease, 0

endif

iSweep init iLength * iPSweep
iBend init iLength * iPBend

if iSweep + iBend >= iLength/2 then

iSweep init iLength / iLength/4
iBend init iLength/4

endif

aFrequency expseg iFrequency * 2^( -( iPShift + iPTone - iPreviousTone ) / iPScale ), iSweep, iFrequency, iLength - ( iSweep + iBend ), iFrequency, iBend, iNextFrequency * 2^( -( iNextShift + iNextTone - iPTone ) / iPScale )

aGain linseg 0, iPAttack, 1-iPSustain, iPDecay, 0

aLowPass = aFrequency * 2^k( aGain + iPLowPass )
aHighPass = aFrequency / 2^k( aGain + iPHighPass )

tigoto skip

aModulator poscil ( 1.5+aGain ) * aFrequency, aFrequency * 2

aNote poscil aAmplitude + aGain, aFrequency + aModulator

aNote *= aModulator / aFrequency

aClip rspline .5, .5, 1/iLength, 2/iLength
aSkew rspline -1, 0, 1/iLength, 2/iLength

aBody squinewave aFrequency, aClip, aSkew

aNote *= aBody

aWaveAmplitude poscil aAmplitude + aGain, aFrequency + aModulator
aWaveIndex = ( aWaveAmplitude + 1 ) / 2
aWave tablei    aWaveIndex, giHornTransfer, 1

aNote *= aWave

denorm aNote

aNote butterlp aNote, aLowPass
aNote butterhp aNote, aHighPass

denorm aNote

aReverbLeft, aReverbRight freeverb aNote, aNote, .5, .5

aLeft = aNote + aReverbLeft
aRight = aNote + aReverbRight

skip:

` .trim ();

};
