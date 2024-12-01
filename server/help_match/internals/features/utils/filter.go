package utils

import "strings"

type Filter struct {
	Page         int
	PageSize     int
	Sort         string
	SortSafeList []string
}

func (f Filter) Validate(v *Validator) {
	v.Check(f.Page > 0, "page", "must be greater than 0")
	v.Check(f.Page <= 10_000_000, "page", "must be max of 10 mil")
	v.Check(f.PageSize > 0, "page_size", "must be greater than zero")
	v.Check(f.PageSize <= 100, "page_size", "must be a maximum of 100")
	v.Check(In(f.Sort, f.SortSafeList...), "sort", "invalid sort value")
}

func (f Filter) SortColumn() string {
	for _, safeValue := range f.SortSafeList {
		if f.Sort == safeValue {
			return strings.TrimPrefix(f.Sort, "-")
		}
	}
	panic("unsafe sort parameter: " + f.Sort)
}

func (f Filter) SortDirection() string {
	if strings.HasPrefix(f.Sort, "-") {
		return "DESC"
	}
	return "ASC"
}

func (f Filter) Limit() int {
	return f.PageSize
}

func (f Filter) Offset() int {
	return (f.Page - 1) * f.PageSize
}
