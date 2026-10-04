# Me

Extract from the following `html` the notes of the jins it's talking about and their respective frequencies:

```html
<map name="notemap">
                                          <area shape="circle" coords="71,105,12" href="#" alt="B3<i class='icon-halfflat'></i>" class="playNote" data-frequency="243" data-parent="#notation1"><!-- variable -->
                                          <area shape="circle" coords="151,96,12" href="#" alt="C4" class="playNote" data-frequency="260.74" data-parent="#notation1">
                                          <area shape="circle" coords="235,88,14" href="#" alt="D4" class="playNote" data-frequency="293.33" data-parent="#notation1">
                                          <area shape="circle" coords="311,79,13" href="#" alt="E4<i class='icon-halfflat'></i>" class="playNote" data-frequency="320" data-parent="#notation1"><!-- variable -->
                                          <area shape="circle" coords="392,71,13" href="#" alt="F4" class="playNote" data-frequency="347.65" data-parent="#notation1">
                                          <area shape="circle" coords="472,63,14" href="#" alt="G4" class="playNote" data-frequency="391.11" data-parent="#notation1">
                                          <area shape="circle" coords="547,53,12" href="#" alt="A4" class="playNote" data-frequency="440" data-parent="#notation1">
                                          <area shape="circle" coords="626,45,12" href="#" alt="B4◈" class="playNote" data-frequency="463.54" data-parent="#notation1">
                                        </map>

                    <p>Jins Bayati is a 4-note <em>jins</em>. It is notated here with its tonic on D and its <em>ghammaz</em> on G. Jins Bayati is the first <em>jins</em> in <a href="../maqam/bayati.php">Maqam Bayati</a>.
                    </p>
```

# You

Jins Bayati (tonic on D, 4 notes):
- D4 — 293.33 Hz
- E4 (half-flat) — 320 Hz
- F4 — 347.65 Hz
- G4 — 391.11 Hz

# Me

Write the MIDI note mapping for these notes (use floating points for microtonality)

# You

MIDI note number mapping (A4 = 440 Hz, MIDI 69; using fractional MIDI for microtonality):
- D4 (293.33 Hz) → 62.000
- E4 half-flat (320 Hz) → 63.002
- F4 (347.65 Hz) → 65.000
- G4 (391.11 Hz) → 67.000

# Me

Now calculate the intervals between notes starting from 0

# You

Intervals in (fractional) MIDI-note units, starting from 0 at the tonic (D4 = 62.000):
- D4 → 0.000
- E4 half-flat → 63.002 − 62.000 = 1.002
- F4 → 65.000 − 62.000 = 3.000
- G4 → 67.000 − 62.000 = 5.000

Step intervals between successive notes:
- D4 → E4 half-flat: 1.002
- E4 half-flat → F4: 65.000 − 63.002 = 1.998
- F4 → G4: 2.000
