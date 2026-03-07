package services

import (
	"context"
	"errors"
	"markitos-it-svc-goldens/internal/domain"
	"testing"
)

// fakeRepo is a happy-path fake: all operations succeed and return predictable data.
type fakeRepo struct{}

func (fakeRepo) GetAll(ctx context.Context) ([]domain.Golden, error) { return nil, nil }
func (fakeRepo) GetByID(ctx context.Context, id string) (*domain.Golden, error) {
	return &domain.Golden{ID: id}, nil
}
func (fakeRepo) Create(ctx context.Context, doc *domain.Golden) error { return nil }
func (fakeRepo) Update(ctx context.Context, doc *domain.Golden) error { return nil }
func (fakeRepo) Delete(ctx context.Context, id string) error          { return nil }

// failingRepo always returns an error on every operation.
type failingRepo struct {
	err error
}

func (r failingRepo) GetAll(ctx context.Context) ([]domain.Golden, error)            { return nil, r.err }
func (r failingRepo) GetByID(ctx context.Context, id string) (*domain.Golden, error) { return nil, r.err }
func (r failingRepo) Create(ctx context.Context, doc *domain.Golden) error            { return r.err }
func (r failingRepo) Update(ctx context.Context, doc *domain.Golden) error            { return r.err }
func (r failingRepo) Delete(ctx context.Context, id string) error                    { return r.err }

// ---------------------------------------------------------------------------
// NewGoldenService
// ---------------------------------------------------------------------------

func TestNewGoldenService_WithNilRepo(t *testing.T) {
	svc := NewGoldenService(nil)
	if svc == nil {
		t.Fatal("expected non-nil GoldenService")
	}
}

func TestNewGoldenService_WithRepo(t *testing.T) {
	svc := NewGoldenService(fakeRepo{})
	if svc == nil {
		t.Fatal("expected non-nil GoldenService")
	}
}

// ---------------------------------------------------------------------------
// GetAllGoldens
// ---------------------------------------------------------------------------

func TestGoldenService_GetAllGoldens_ReturnsResults(t *testing.T) {
	svc := NewGoldenService(fakeRepo{})
	got, err := svc.GetAllGoldens(context.Background())
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if got != nil && len(got) != 0 {
		t.Fatalf("expected nil/empty slice, got %v", got)
	}
}

func TestGoldenService_GetAllGoldens_PropagatesError(t *testing.T) {
	want := errors.New("repo down")
	svc := NewGoldenService(failingRepo{err: want})
	_, err := svc.GetAllGoldens(context.Background())
	if err == nil {
		t.Fatal("expected error, got nil")
	}
	if !errors.Is(err, want) {
		t.Fatalf("expected %v, got %v", want, err)
	}
}

// ---------------------------------------------------------------------------
// GetGoldenByID
// ---------------------------------------------------------------------------

func TestGoldenService_GetGoldenByID_ReturnsCorrectID(t *testing.T) {
	svc := NewGoldenService(fakeRepo{})
	got, err := svc.GetGoldenByID(context.Background(), "my-id")
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if got == nil || got.ID != "my-id" {
		t.Fatalf("expected ID=my-id, got %+v", got)
	}
}

func TestGoldenService_GetGoldenByID_PropagatesError(t *testing.T) {
	want := errors.New("not found")
	svc := NewGoldenService(failingRepo{err: want})
	_, err := svc.GetGoldenByID(context.Background(), "any")
	if err == nil {
		t.Fatal("expected error, got nil")
	}
	if !errors.Is(err, want) {
		t.Fatalf("expected %v, got %v", want, err)
	}
}

// ---------------------------------------------------------------------------
// CreateGolden
// ---------------------------------------------------------------------------

func TestGoldenService_CreateGolden_Success(t *testing.T) {
	svc := NewGoldenService(fakeRepo{})
	if err := svc.CreateGolden(context.Background(), &domain.Golden{ID: "new-id"}); err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
}

func TestGoldenService_CreateGolden_PropagatesError(t *testing.T) {
	want := errors.New("create failed")
	svc := NewGoldenService(failingRepo{err: want})
	err := svc.CreateGolden(context.Background(), &domain.Golden{})
	if err == nil {
		t.Fatal("expected error, got nil")
	}
	if !errors.Is(err, want) {
		t.Fatalf("expected %v, got %v", want, err)
	}
}

// ---------------------------------------------------------------------------
// UpdateGolden
// ---------------------------------------------------------------------------

func TestGoldenService_UpdateGolden_Success(t *testing.T) {
	svc := NewGoldenService(fakeRepo{})
	if err := svc.UpdateGolden(context.Background(), &domain.Golden{ID: "existing-id"}); err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
}

func TestGoldenService_UpdateGolden_PropagatesError(t *testing.T) {
	want := errors.New("update failed")
	svc := NewGoldenService(failingRepo{err: want})
	err := svc.UpdateGolden(context.Background(), &domain.Golden{})
	if err == nil {
		t.Fatal("expected error, got nil")
	}
	if !errors.Is(err, want) {
		t.Fatalf("expected %v, got %v", want, err)
	}
}

// ---------------------------------------------------------------------------
// DeleteGolden
// ---------------------------------------------------------------------------

func TestGoldenService_DeleteGolden_Success(t *testing.T) {
	svc := NewGoldenService(fakeRepo{})
	if err := svc.DeleteGolden(context.Background(), "existing-id"); err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
}

func TestGoldenService_DeleteGolden_PropagatesError(t *testing.T) {
	want := errors.New("delete failed")
	svc := NewGoldenService(failingRepo{err: want})
	err := svc.DeleteGolden(context.Background(), "any")
	if err == nil {
		t.Fatal("expected error, got nil")
	}
	if !errors.Is(err, want) {
		t.Fatalf("expected %v, got %v", want, err)
	}
}

// ---------------------------------------------------------------------------
// Fuzz tests — input is now actually used as IDs / document data
// ---------------------------------------------------------------------------

func FuzzGoldenService_GetAllGoldens(f *testing.F) {
	f.Add([]byte("seed"))
	f.Fuzz(func(t *testing.T, _ []byte) {
		s := NewGoldenService(fakeRepo{})
		_, err := s.GetAllGoldens(context.Background())
		if err != nil {
			t.Fatalf("unexpected error: %v", err)
		}
	})
}

func FuzzGoldenService_GetGoldenByID(f *testing.F) {
	f.Add("test-id")
	f.Add("")
	f.Add("id with spaces")
	f.Fuzz(func(t *testing.T, id string) {
		s := NewGoldenService(fakeRepo{})
		got, err := s.GetGoldenByID(context.Background(), id)
		if err != nil {
			t.Fatalf("unexpected error: %v", err)
		}
		if got == nil || got.ID != id {
			t.Fatalf("unexpected result: %+v", got)
		}
	})
}

func FuzzGoldenService_CreateGolden(f *testing.F) {
	f.Add("id-1", "title", "description")
	f.Add("", "", "")
	f.Fuzz(func(t *testing.T, id, title, description string) {
		s := NewGoldenService(fakeRepo{})
		doc := &domain.Golden{ID: id, Title: title, Description: description}
		if err := s.CreateGolden(context.Background(), doc); err != nil {
			t.Fatalf("unexpected error: %v", err)
		}
	})
}

func FuzzGoldenService_UpdateGolden(f *testing.F) {
	f.Add("id-1", "title", "description")
	f.Add("", "", "")
	f.Fuzz(func(t *testing.T, id, title, description string) {
		s := NewGoldenService(fakeRepo{})
		doc := &domain.Golden{ID: id, Title: title, Description: description}
		if err := s.UpdateGolden(context.Background(), doc); err != nil {
			t.Fatalf("unexpected error: %v", err)
		}
	})
}

func FuzzGoldenService_DeleteGolden(f *testing.F) {
	f.Add("test-id")
	f.Add("")
	f.Add("id-with-symbols!@#")
	f.Fuzz(func(t *testing.T, id string) {
		s := NewGoldenService(fakeRepo{})
		if err := s.DeleteGolden(context.Background(), id); err != nil {
			t.Fatalf("unexpected error: %v", err)
		}
	})
}
