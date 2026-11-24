CREATE TABLE IF NOT EXISTS user_tags (
    user_id BIGINT NOT NULL REFERENCES users(id),
    tag_id BIGINT NOT NULL REFERENCES tags(id),

    verification_status VARCHAR(20) NOT NULL DEFAULT 'SELF_DECLARED'
	CHECK (verification_status IN (
		'SELF_DECLARED',
		'PURSUING',
		'PENDING',
		'VERIFIED'
	)),

    assigned_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    verified_at TIMESTAMPTZ,
    PRIMARY KEY (user_id, tag_id)
);