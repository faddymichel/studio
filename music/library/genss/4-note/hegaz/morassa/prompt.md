# Me

Extract from the following `html` the notes of the jins it's talking about and their respective frequencies.
Then, write the MIDI note mapping for these notes (use floating points for microtonality).
Finally, aalculate the intervals between successive notes (once from first note and another between each note and its previous one).

(Write results in lists and avoid using tables)

```html
                    <map name="notemap">
                                          <area shape="circle" coords="43,106,12" href="#" alt="C4" class="playNote" data-frequency="260.74" data-parent="#notation1">
                                          <area shape="circle" coords="88,106,12" href="#" alt="C4◈" class="playNote" data-frequency="281.24" data-parent="#notation1"><!-- fine tune-->
                                          <area shape="circle" coords="143,98,14" href="#" alt="D4" class="playNote" data-frequency="293.33" data-parent="#notation1">
                                          <area shape="circle" coords="217,89,13" href="#" alt="E4◈" class="playNote" data-frequency="315" data-parent="#notation1"><!-- fine tune-->
                                          <area shape="circle" coords="294,81,13" href="#" alt="F4◈" class="playNote" data-frequency="375" data-parent="#notation1"><!-- fine tune-->
                                          <area shape="circle" coords="373,73,14" href="#" alt="G4" class="playNote" data-frequency="391.11" data-parent="#notation1">
                                          <area shape="circle" coords="450,65,12" href="#" alt="A4◈" class="playNote" data-frequency="422" data-parent="#notation1">
                                        </map>

                    <p>Jins Hijaz Murassa‘ is a 4-note <em>jins</em>. It is notated here with its tonic on D and its <em>ghammaz</em> on G. Jins Hijaz Murassa‘ is not part of any <em>maqam</em> scale and usually occurs as a modulation from
<a href="hijaz.php">Jins Hijaz</a>, most in <a href="../maqam/hijazkar.php">Maqam Hijazkar</a>.
                    </p>
```

# You

## Notes in the jins (from the html) + frequencies

- D4 — 293.33 Hz (tonic)
- E4◈ — 315.00 Hz
- F4◈ — 375.00 Hz
- G4 — 391.11 Hz (ghammaz)

## MIDI note mapping (floating point, microtonal)

Using: \(m = 69 + 12\log_2(f/440)\)

- D4 (293.33 Hz) → MIDI ≈ 62.015
- E4◈ (315.00 Hz) → MIDI ≈ 63.246
- F4◈ (375.00 Hz) → MIDI ≈ 66.058
- G4 (391.11 Hz) → MIDI ≈ 66.788

## Intervals (in cents)

Using: \(c = 1200\log_2(f_2/f_1)\)

### From the first note (D4)

- D4 → D4: 0.0¢
- D4 → E4◈: ≈ 123.1¢
- D4 → F4◈: ≈ 425.7¢
- D4 → G4: ≈ 496.6¢

### Between successive notes

- D4 → E4◈: ≈ 123.1¢
- E4◈ → F4◈: ≈ 302.6¢
- F4◈ → G4: ≈ 71.0¢
