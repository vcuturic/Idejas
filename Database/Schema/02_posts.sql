CREATE TABLE IF NOT EXISTS posts (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    author_id BIGINT NOT NULL REFERENCES users(id),
	owner_id BIGINT NOT NULL REFERENCES users(id),
    title VARCHAR(255),
    content JSONB NOT NULL,
	root_post_id BIGINT REFERENCES posts(id),
    quoted_post_id BIGINT REFERENCES posts(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ,
	
	post_type VARCHAR(20) NOT NULL
	CHECK (post_type IN ('STANDARD', 'IDEA', 'COMMENT')),
		
    status VARCHAR(20) NOT NULL DEFAULT 'PUBLISHED'
	CHECK (status IN ('DRAFT', 'PUBLISHED', 'ARCHIVED')),

	min_verification_level SMALLINT NOT NULL DEFAULT 1
	CHECK (min_verification_level BETWEEN 1 AND 3)

    CONSTRAINT posts_type_structure_check CHECK (
	(
		post_type IN ('STANDARD', 'IDEA')
		AND root_post_id IS NULL
	)
	OR
	(
		post_type = 'COMMENT'
		AND root_post_id IS NOT NULL
	))
);