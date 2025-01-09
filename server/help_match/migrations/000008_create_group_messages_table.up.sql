CREATE TABLE group_messages (
    id UUID NOT NULL DEFAULT uuid_generate_v1mc(),
    chat_room_id UUID REFERENCES job_chat_rooms(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES users(id) ON DELETE CASCADE,
    is_seen BOOLEAN DEFAULT FALSE,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);