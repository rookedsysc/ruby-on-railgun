start = Time.now

sum = 0

for i in 0...50000000
  sum += i
end

finish = Time.now
diff_ms = (finish - start) * 1000
puts "\nTime taken to run: #{diff_ms} ms"
