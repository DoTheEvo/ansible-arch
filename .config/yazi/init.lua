-- ---------------------------------------------------------------------------
-- SHOW USER/GROUP OF FILES IN STATUS BAR
-- ---------------------------------------------------------------------------
Status:children_add(function()
  local h = cx.active.current.hovered
  if not h or ya.target_family() ~= "unix" then
    return ""
  end

  return ui.Line {
    ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
    ":",
    ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
    " ",
  }
end, 500, Status.RIGHT)

-- ---------------------------------------------------------------------------
-- SHOW USERNAME AND HOSTNAME IN HEADER
-- ---------------------------------------------------------------------------
Header:children_add(function()
  if ya.target_family() ~= "unix" then
    return ""
  end
  return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
end, 500, Header.LEFT)


-- ---------------------------------------------------------------------------
-- SHOW SIZE AND DATE NEXT TO FILES AND DIRECTORIES
-- ---------------------------------------------------------------------------
function Linemode:size_and_mtime()
  local time = math.floor(self._file.cha.mtime or 0)
  if time == 0 then
    time = ""
  else
    -- Always show in the format: DD-Mon-YY
    time = os.date("%d-%b-%y", time)
  end

  local size = self._file:size()
  return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end
