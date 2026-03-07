package grpc

import (
	"context"
	"errors"
	"markitos-it-svc-goldens/internal/application/services"
	"markitos-it-svc-goldens/internal/domain"
	pb "markitos-it-svc-goldens/proto"
	"testing"
	"time"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type stubRepo struct {
	docs []domain.Golden
	doc  *domain.Golden
	err  error
}

func (r *stubRepo) GetAll(ctx context.Context) ([]domain.Golden, error) {
	if r.err != nil {
		return nil, r.err
	}
	return r.docs, nil
}

func (r *stubRepo) GetByID(ctx context.Context, id string) (*domain.Golden, error) {
	if r.err != nil {
		return nil, r.err
	}
	if r.doc != nil {
		return r.doc, nil
	}
	return &domain.Golden{ID: id, UpdatedAt: time.Unix(0, 0).UTC()}, nil
}

func (r *stubRepo) Create(ctx context.Context, doc *domain.Golden) error { return nil }
func (r *stubRepo) Update(ctx context.Context, doc *domain.Golden) error { return nil }
func (r *stubRepo) Delete(ctx context.Context, id string) error          { return nil }

func TestNewGoldenServer(t *testing.T) {
	svc := services.NewGoldenService(&stubRepo{})
	got := NewGoldenServer(svc)

	if got == nil {
		t.Fatal("expected non-nil server")
	}
	if got.service != svc {
		t.Fatal("expected same service instance")
	}
}

func TestGoldenServer_GetAllGoldens_Success(t *testing.T) {
	now := time.Date(2026, 3, 6, 12, 0, 0, 0, time.UTC)
	repo := &stubRepo{
		docs: []domain.Golden{
			{
				ID:          "id-1",
				Title:       "title-1",
				Description: "desc-1",
				Category:    "cat-1",
				Tags:        []string{"a", "b"},
				UpdatedAt:   now,
				ContentB64:  "Y29udGVudA==",
				CoverImage:  "https://example.com/cover.png",
			},
		},
	}
	s := NewGoldenServer(services.NewGoldenService(repo))

	got, err := s.GetAllGoldens(context.Background(), &pb.GetAllGoldensRequest{})
	if err != nil {
		t.Fatalf("unexpected err: %v", err)
	}
	if got == nil || len(got.Goldens) != 1 {
		t.Fatalf("unexpected response: %+v", got)
	}
	if got.Goldens[0].Id != "id-1" {
		t.Fatalf("expected id-1, got %q", got.Goldens[0].Id)
	}
}

func TestGoldenServer_GetAllGoldens_Error(t *testing.T) {
	s := NewGoldenServer(services.NewGoldenService(&stubRepo{err: errors.New("db down")}))

	got, err := s.GetAllGoldens(context.Background(), &pb.GetAllGoldensRequest{})
	if err == nil {
		t.Fatal("expected error, got nil")
	}
	if got != nil {
		t.Fatalf("expected nil response, got %+v", got)
	}
	if status.Code(err) != codes.Internal {
		t.Fatalf("expected Internal, got %v", status.Code(err))
	}
}

func TestGoldenServer_GetGoldenById_Success(t *testing.T) {
	now := time.Date(2026, 3, 6, 12, 0, 0, 0, time.UTC)
	repo := &stubRepo{
		doc: &domain.Golden{
			ID:          "id-42",
			Title:       "title-42",
			Description: "desc-42",
			Category:    "cat-42",
			Tags:        []string{"x"},
			UpdatedAt:   now,
			ContentB64:  "YQ==",
			CoverImage:  "https://example.com/42.png",
		},
	}
	s := NewGoldenServer(services.NewGoldenService(repo))

	got, err := s.GetGoldenById(context.Background(), &pb.GetGoldenByIdRequest{Id: "id-42"})
	if err != nil {
		t.Fatalf("unexpected err: %v", err)
	}
	if got == nil || got.Golden == nil {
		t.Fatalf("unexpected response: %+v", got)
	}
	if got.Golden.Id != "id-42" {
		t.Fatalf("expected id-42, got %q", got.Golden.Id)
	}
}

func TestGoldenServer_GetGoldenById_Error(t *testing.T) {
	s := NewGoldenServer(services.NewGoldenService(&stubRepo{err: errors.New("not found")}))

	got, err := s.GetGoldenById(context.Background(), &pb.GetGoldenByIdRequest{Id: "missing"})
	if err == nil {
		t.Fatal("expected error, got nil")
	}
	if got != nil {
		t.Fatalf("expected nil response, got %+v", got)
	}
	if status.Code(err) != codes.NotFound {
		t.Fatalf("expected NotFound, got %v", status.Code(err))
	}
}

// TestGoldenServer_GetGoldenById_AllFieldsMapped verifies that every field of the
// domain.Golden is correctly mapped to the corresponding proto field.
func TestGoldenServer_GetGoldenById_AllFieldsMapped(t *testing.T) {
	now := time.Date(2026, 3, 6, 12, 0, 0, 0, time.UTC)
	doc := &domain.Golden{
		ID:          "id-fields",
		Title:       "Test Title",
		Description: "Test Description",
		Category:    "TestCat",
		Tags:        []string{"tag1", "tag2"},
		UpdatedAt:   now,
		ContentB64:  "Y29udGVudA==",
		CoverImage:  "https://example.com/cover.png",
	}
	s := NewGoldenServer(services.NewGoldenService(&stubRepo{doc: doc}))

	resp, err := s.GetGoldenById(context.Background(), &pb.GetGoldenByIdRequest{Id: doc.ID})
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	g := resp.Golden

	if g.Id != doc.ID {
		t.Errorf("Id: want %q, got %q", doc.ID, g.Id)
	}
	if g.Title != doc.Title {
		t.Errorf("Title: want %q, got %q", doc.Title, g.Title)
	}
	if g.Description != doc.Description {
		t.Errorf("Description: want %q, got %q", doc.Description, g.Description)
	}
	if g.Category != doc.Category {
		t.Errorf("Category: want %q, got %q", doc.Category, g.Category)
	}
	if len(g.Tags) != len(doc.Tags) {
		t.Fatalf("Tags length: want %d, got %d", len(doc.Tags), len(g.Tags))
	}
	for i, tag := range doc.Tags {
		if g.Tags[i] != tag {
			t.Errorf("Tags[%d]: want %q, got %q", i, tag, g.Tags[i])
		}
	}
	if !g.UpdatedAt.AsTime().Equal(doc.UpdatedAt) {
		t.Errorf("UpdatedAt: want %v, got %v", doc.UpdatedAt, g.UpdatedAt.AsTime())
	}
	if g.ContentB64 != doc.ContentB64 {
		t.Errorf("ContentB64: want %q, got %q", doc.ContentB64, g.ContentB64)
	}
	if g.CoverImage != doc.CoverImage {
		t.Errorf("CoverImage: want %q, got %q", doc.CoverImage, g.CoverImage)
	}
}
