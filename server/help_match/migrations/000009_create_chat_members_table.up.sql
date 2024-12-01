CREATE TABLE job_chat_members (
    chat_room_id UUID REFERENCES job_chat_rooms(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    joined_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    left_at TIMESTAMP,
    PRIMARY KEY (chat_room_id, user_id)
)