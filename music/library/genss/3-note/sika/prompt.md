# Me

Extract from the following `html` the notes of the jins it's talking about and their respective frequencies:

```html
<map name="notemap">
                                          <area shape="circle" coords="37,97,12" href="#" alt="C4" class="playNote" data-frequency="260.74" data-parent="#notation1">
                                          <area shape="circle" coords="96,89,12" href="#" alt="D4◈" class="playNote" data-frequency="293.33" data-parent="#notation1">
                                          <area shape="circle" coords="134,89,12" href="#" alt="D4◈" class="playNote" data-frequency="310" data-parent="#notation1"><!-- leading tone -->
                                          <area shape="circle" coords="198,81,14" href="#" alt="E4<i class='icon-halfflat'></i>" class="playNote" data-frequency="320" data-parent="#notation1"><!--variable 318~324-->
                                          <area shape="circle" coords="273,72,13" href="#" alt="F4" class="playNote" data-frequency="347.65" data-parent="#notation1">
                                          <area shape="circle" coords="351,65,14" href="#" alt="G4" class="playNote" data-frequency="391.11" data-parent="#notation1">
                                          <area shape="circle" coords="425,56,12" href="#" alt="A4◈" class="playNote" data-frequency="422" data-parent="#notation1"><!-- fine tuned up from 411-->


                                        </map>
                    <p>Jins Sikah is a 3-note jins. It is notated here with its tonic on E<i class='icon-halfflat'></i> and its <em>ghammaz</em> on G. Jins Sikah is the first jins in <a href="../maqam/sikah.php">Maqam Sikah</a>, <a href="../maqam/huzam.php">Maqam Huzam</a>, <a href="../maqam/iraq.php">Maqam ‘Iraq</a>, and <a href="../maqam/bastanikar.php">Maqam Bastanikar</a>.</p>
```

# You

Jins Sikah (3 notes, tonic on E half-flat; ghammaz on G):
- E4 half-flat: 320 Hz
- F4: 347.65 Hz
- G4: 391.11 Hz

# Me

Write the MIDI note mapping for these notes (use floating points for microtonality)

# You

Using MIDI note 69 = A4 = 440 Hz, and the formula:

midi = 69 + 12 * log2(f / 440)

MIDI note mapping:
- E4 half-flat (320 Hz): 63.213
- F4 (347.65 Hz): 65.000
- G4 (391.11 Hz): 67.001

# Me

Now calculate the intervals between notes starting from 0

# You

Intervals (in MIDI-note units), relative to the tonic (E4 half-flat = 0):
- E4 half-flat: 0.000
- F4: 65.000 - 63.213 = 1.787
- G4: 67.001 - 63.213 = 3.788
