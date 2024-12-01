CREATE TABLE reviews (
    id UUID NOT NULL DEFAULT uuid_generate_v1mc(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    organization_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
    rating INT CHECK (rating >= 1 AND rating <= 5), 
    review TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);