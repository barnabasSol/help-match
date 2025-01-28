CREATE TABLE notifications (
    id UUID NOT NULL DEFAULT uuid_generate_v1mc(),
    from_id UUID REFERENCES users(id) ON DELETE CASCADE,
    to_id UUID REFERENCES users(id) ON DELETE CASCADE,
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);