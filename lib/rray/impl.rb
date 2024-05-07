case $impl
when :c
  require "cray"
  Impl = Cray
when :rust
  require "fray"
  Impl = Fray
else
  require "rray"
  Impl = Rray
end
