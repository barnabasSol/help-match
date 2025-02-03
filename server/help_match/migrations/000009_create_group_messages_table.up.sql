CREATE TABLE group_messages (
    id UUID NOT NULL DEFAULT uuid_generate_v1mc() PRIMARY KEY,
    chat_room_id UUID REFERENCES job_chat_rooms(id) ON DELETE CASCADE,
    sender_id UUID,
    is_seen BOOLEAN DEFAULT FALSE,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (chat_room_id, sender_id) REFERENCES job_chat_members(chat_room_id, user_id)
);