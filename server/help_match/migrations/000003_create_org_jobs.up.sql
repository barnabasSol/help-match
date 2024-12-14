CREATE TABLE org_jobs (
    id UUID NOT NULL DEFAULT uuid_generate_v1mc(),
    org_id UUID REFERENCES organizations(id) ON DELETE CASCADE, 
    job_title VARCHAR(100) NOT NULL,
    description TEXT DEFAULT '',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    version INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY (id)
);