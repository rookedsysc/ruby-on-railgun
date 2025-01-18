package main

import (
	"fmt"
	"time"
)

func main() {
	start := time.Now()

	sum := 0
	for i := 0; i < 50000000; i++ {
		sum += i
	}

	finish := time.Now()
	diff := finish.Sub(start).Milliseconds()

	fmt.Printf("\nTime taken to run: %d ms\n", diff)
}