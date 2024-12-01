CREATE TABLE refresh_tokens (
    id UUID NOT NULL DEFAULT uuid_generate_v1mc(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);