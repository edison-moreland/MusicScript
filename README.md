# MusicScript

A little scripting environment I created to explore fundamental music concepts in a familiar
environment.

## Syntax

Scripts are written in lua 5.2.

Here is a small example that plays four notes in order, with each note lasting a whole beat:

```lua
bpm(90)

song = {
    pitch(A, 4),
    pitch(C, 5),
    pitch(G, 4),
    pitch(F, 4)
}

for _, f in ipairs(song) do
    note(1, f)
end
```