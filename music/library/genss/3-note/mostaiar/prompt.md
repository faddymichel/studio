# Me

Extract from the following `html` the notes of the jins it's talking about and their respective frequencies:

```html
<map name="notemap">
                                          <area shape="circle" coords="66,91,12" href="#" alt="D4◈" class="playNote" data-frequency="308.25" data-parent="#notation1">
                                          <area shape="circle" coords="147,84,14" href="#" alt="E4<i class='icon-halfflat'></i>" class="playNote" data-frequency="320" data-parent="#notation1"><!--variable 318~324-->
                                          <area shape="circle" coords="233,76,13" href="#" alt="F4◈" class="playNote" data-frequency="375" data-parent="#notation1">
                                          <area shape="circle" coords="307,68,14" href="#" alt="G4" class="playNote" data-frequency="391.11" data-parent="#notation1">
                                          <area shape="circle" coords="383,59,13" href="#" alt="A4◈" class="playNote" data-frequency="440" data-parent="#notation1">
                                          <area shape="circle" coords="449,52,13" href="#" alt="B4◈" class="playNote" data-frequency="463.54" data-parent="#notation1">

                                        </map>
                    <p>Jins Musta‘ar is a 3-note <em>jins</em>. It is notated here with its tonic on E<i class="icon-halfflat"></i> and its <em>ghammaz</em> on G. Jins Musta‘ar is the first <em>jins</em> in <a href="../maqam/mustaar.php">M>                    </p>
```

# You

Jins Musta‘ar is described as a 3-note jins with tonic on E half-flat and ghammaz on G. From the note map, the corresponding notes and frequencies are:

- E4 (half-flat): 320 Hz (variable approx. 318–324)
- F4: 375 Hz
- G4: 391.11 Hz

# Me

Write the MIDI note mapping for these notes (use floating points for microtonality)

# You

Using standard MIDI note numbers with A4 = 440 Hz mapped to MIDI 69, the floating-point MIDI note value for a frequency \(f\) is:

\[
\text{midi}(f) = 69 + 12\,\log_2\left(\frac{f}{440}\right)
\]

Applying this to the three notes:

- **E4 (half-flat), 320 Hz** → **~63.493**
  - if using the given variability: 318 Hz → ~63.385, 324 Hz → ~63.709
- **F4, 375 Hz** → **~65.369**
- **G4, 391.11 Hz** → **~66.098**

# Me

Now calculate the intervals between notes starting from 0

# You

Taking the tonic (E4 half-flat, MIDI ~63.493) as 0, the intervals in MIDI-note units (semitones, allowing fractional values) are:

- **E4 (half-flat)**: 63.493 − 63.493 = **0.000**
- **F4**: 65.369 − 63.493 = **1.876**
- **G4**: 66.098 − 63.493 = **2.605**

(Using the variability range for E half-flat: if E=318 Hz → F interval ~1.984, G interval ~2.713; if E=324 Hz → F interval ~1.660, G interval ~2.389.)
