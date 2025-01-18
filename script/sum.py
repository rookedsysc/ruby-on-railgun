import time

start = time.time()

sum_value = 0

for i in range(50000000):
    sum_value += i

finish = time.time()
diff_ms = (finish - start) * 1000
print(f"\nTime taken to run: {diff_ms:.2f} ms")