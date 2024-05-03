case $impl
when :c
  require "cray"
  Impl = Cray
else
  require "rray"
  Impl = Rray
end
