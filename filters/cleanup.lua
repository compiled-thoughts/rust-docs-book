#! /usr/bin/env lua
--
-- debug.lua
-- Copyright (C) 2022 edgardleal <edgardleal@air-edgard.local>
--
-- Distributed under terms of the MIT license.
--
--
function Inlines(list)
  for index, value in ipairs(list) do
    local text = value.text or ''
    if index == 1 then
      if text == "%%" then
        return {}
      end
      if text:gmatch('[^ ]+::')() ~= nil then
        return {}
      end
    end
  end
  return list
end

function Str(ele)
  ele.text = ele.text:gsub('%%.*%%', '')
  -- print(ele.text)
end
