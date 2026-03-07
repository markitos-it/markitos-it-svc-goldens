package domain

import (
	"crypto/rand"
	"errors"
	"os"
	"os/exec"
	"strings"
	"testing"
)

type failingReader struct{}

func (failingReader) Read(_ []byte) (int, error) {
	return 0, errors.New("forced rand error")
}

func TestHelperRandomAlphaPrefix_RandErrorPath(t *testing.T) {
	if os.Getenv("GO_WANT_HELPER_PROCESS") == "1" {
		original := rand.Reader
		rand.Reader = failingReader{}
		defer func() { rand.Reader = original }()

		HelperRandomAlphaPrefix(t, 1)
		return
	}

	cmd := exec.Command(os.Args[0], "-test.run=^TestHelperRandomAlphaPrefix_RandErrorPath$")
	cmd.Env = append(os.Environ(), "GO_WANT_HELPER_PROCESS=1")
	out, err := cmd.CombinedOutput()

	if err == nil {
		t.Fatalf("expected helper process to fail, but it passed")
	}
	if !strings.Contains(string(out), "failed generating random prefix") {
		t.Fatalf("expected fatal message not found. output:\n%s", string(out))
	}
}

func FuzzHelperRandomAlphaPrefix(f *testing.F) {
	f.Add(0)
	f.Add(1)
	f.Add(5)
	f.Add(100)

	f.Fuzz(func(t *testing.T, length int) {
		if length < 0 || length > 4096 {
			t.Skip()
		}

		got := HelperRandomAlphaPrefix(t, length)
		if len(got) != length {
			t.Fatalf("expected length %d, got %d", length, len(got))
		}
	})
}
