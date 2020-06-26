-- a shepard tone generator

-- notes
-- 6 voices
-- each voice goes from -3v to +3v chromatically
-- velocity peaks at 0v

local util = require 'util'
local tabutil = require 'tabutil'

num_voices = 6
num_steps = num_voices * 12
note_v_offset = (num_voices / 2)
positions = {}
period = 0.05
increment = 0.05
max_vel = 5
min_vel = 0.01

function init()
  crow.ii.pullup(true)
  crow.ii.jf.mode(1)
  
  positions = {}
  for i = 1, num_voices do
    positions[i] = (i - 1) * 12
  end
  
  clock.run(update)
end

function update()
  for i=1,num_voices do
    update_voice(i)
  end
  
  clock.sleep(period)
  clock.run(update)
end

function update_voice(i)
  local note = positions[i]
  local note_v = n2v(note) - note_v_offset
  local level = util.linexp(0, note_v_offset, max_vel, min_vel, math.abs(note_v))
  
  crow.ii.jf.play_voice(i, note_v, level)  
  
  note = note + increment
  if note >= num_steps then
    note = 0
  elseif note < 0 then
    note = num_steps
  end
  positions[i] = note
end

function n2v(n) return n / 12 end
