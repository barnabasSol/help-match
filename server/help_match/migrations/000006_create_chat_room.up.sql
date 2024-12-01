CREATE TABLE job_chat_rooms (
    id UUID UNIQUE NOT NULL DEFAULT uuid_generate_v1mc(),
    job_id UUID REFERENCES org_jobs(id) ON DELETE CASCADE,
    name VARCHAR(255), 
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);
