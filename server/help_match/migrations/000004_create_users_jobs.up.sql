CREATE TYPE job_status_type AS ENUM (
    'pending',
    'accepted',
    'rejected',
    'finished'
);

CREATE TABLE user_jobs (
    id UUID NOT NULL DEFAULT uuid_generate_v1mc(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE, 
    job_id UUID REFERENCES org_jobs(id) ON DELETE CASCADE,
    job_status job_status_type DEFAULT 'pending',  
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    version INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    CONSTRAINT unique_user_job UNIQUE (user_id, job_id) 
);