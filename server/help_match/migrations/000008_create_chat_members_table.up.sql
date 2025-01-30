CREATE TABLE job_chat_members (
    id UUID DEFAULT uuid_generate_v1mc() UNIQUE, 
    chat_room_id UUID REFERENCES job_chat_rooms(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    is_admin BOOLEAN DEFAULT FALSE,
    joined_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    left_at TIMESTAMP,
    PRIMARY KEY (chat_room_id, user_id)
);