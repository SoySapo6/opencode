package config

import (
	"os"
	"path/filepath"
)

// IsTermux returns true if the application is running in Termux.
func IsTermux() bool {
	return os.Getenv("TERMUX_VERSION") != ""
}

// GetTermuxShell returns the path to the shell in Termux if it exists.
// It returns an empty string if not in Termux or shell not found.
func GetTermuxShell() string {
	if !IsTermux() {
		return ""
	}

	prefix := os.Getenv("PREFIX")
	if prefix == "" {
		// Fallback to default Termux prefix
		prefix = "/data/data/com.termux/files/usr"
	}

	bashPath := filepath.Join(prefix, "bin", "bash")
	if _, err := os.Stat(bashPath); err == nil {
		return bashPath
	}

	shPath := filepath.Join(prefix, "bin", "sh")
	if _, err := os.Stat(shPath); err == nil {
		return shPath
	}

	return ""
}
