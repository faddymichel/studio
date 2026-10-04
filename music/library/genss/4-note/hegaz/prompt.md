# Me

Extract from the following `html` the notes of the jins it's talking about and their respective frequencies.
Then, write the MIDI note mapping for these notes (use floating points for microtonality).
Finally, aalculate the intervals between successive notes (once from first note and another between each note and its previous one).

(Write results in lists and avoid using tables)

```html
<map name="notemap">
                                          <area shape="circle" coords="95,104,12" href="#" alt="B3<i class='icon-halfflat'></i>" class="playNote" data-frequency="243" data-parent="#notation1"><!- variable ->
                                          <area shape="circle" coords="173,96,12" href="#" alt="C4" class="playNote" data-frequency="260.74" data-parent="#notation1">
                                          <area shape="circle" coords="255,89,14" href="#" alt="D4" class="playNote" data-frequency="293.33" data-parent="#notation1">
                                          <area shape="circle" coords="330,80,13" href="#" alt="E4◈" class="playNote" data-frequency="315" data-parent="#notation1"><!- variable Hijaz 2nd x1.0738->
                                          <area shape="circle" coords="408,71,13" href="#" alt="F4◈" class="playNote" data-frequency="375" data-parent="#notation1">
                                          <area shape="circle" coords="486,64,14" href="#" alt="G4" class="playNote" data-frequency="391.11" data-parent="#notation1">
                                          <area shape="circle" coords="559,55,12" href="#" alt="A4" class="playNote" data-frequency="440" data-parent="#notation1">
                                          <area shape="circle" coords="636,46,12" href="#" alt="B4◈" class="playNote" data-frequency="463.54" data-parent="#notation1">
                                        </map>

                    <p>Jins Hijaz is a 4-note <em>jins</em>. It is notated here with its tonic on D and its <em>ghammaz</em> on G. The interval between the 2<sup>nd</sup> and 3<sup>rd</sup> degrees is usually played smaller than notated by
raising the 2<sup>nd</sup> a little and lowering the 3<sup>rd</sup> a little. Jins Hijaz is the first <em>jins</em> in <a href="../maqam/hijaz.php">Maqam Hijaz</a>, <a href="../maqam/hijazkar.php">Maqam Hijazkar</a>, and <a href="../maqam/zanjaran.php">Maqam Zanjaran</a>.
                    </p>
```

# You

## Notes in the jins (Jins Hijaz on D) and frequencies

- D4 — 293.33 Hz (tonic)
- E4◈ — 315 Hz (2nd; microtonal)
- F4◈ — 375 Hz (3rd; microtonal)
- G4 — 391.11 Hz (ghammaz)

## MIDI note mapping (floating-point MIDI numbers)

(Using: MIDI = 69 + 12 * log2(f / 440))

- D4 (293.33 Hz) → 61.000
- E4◈ (315 Hz) → 62.241
- F4◈ (375 Hz) → 66.019
- G4 (391.11 Hz) → 67.000

## Intervals (in cents)

(Using: cents = 1200 * log2(f2 / f1))

### From the first note (D4) to each successive note

- D4 → E4◈: 124.10 cents
- D4 → F4◈: 425.41 cents
- D4 → G4: 498.04 cents

### Between each note and the previous one

- D4 → E4◈: 124.10 cents
- E4◈ → F4◈: 301.31 cents
- F4◈ → G4: 72.63 cents
