package main

import (
	"time"

	"github.com/sirupsen/logrus"
)

func main() {
	logrus.SetFormatter(&logrus.TextFormatter{
		TimestampFormat: "2006-01-02 15:04:05",
		FullTimestamp:   true,
	})

	// Log current time
	logrus.Info("This is a log entry.")

	// Print the timezone to verify
	currentTime := time.Now()
	logrus.Infof("Current Time: %s (Location: %s)", currentTime.Format("2006-01-02 15:04:05"), currentTime.Location())
}
