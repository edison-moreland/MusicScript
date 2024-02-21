# MusicSounds

A little scripting environment I created to experiment with intervals, scales, and other music concepts in a familiar
environment.

## Syntax

Scripts are written in lua 5.2.

Here is a small example that plays four notes in order, with each note lasting a whole beat:

```lua
bpm(90)

song = {
    SPN(A, 4),
    SPN(C, 5),
    SPN(G, 4),
    SPN(F, 4)
}

for _, f in ipairs(song) do
    note(1, f)
end
```