CREATE TABLE IF NOT EXISTS appreciations (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    sender_id BIGINT NOT NULL
        REFERENCES users(id),

    receiver_id BIGINT NOT NULL
        REFERENCES users(id),

    idea_id BIGINT NOT NULL
        REFERENCES posts(id),

    post_id BIGINT NOT NULL
        REFERENCES posts(id),

    description TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT appreciation_no_self
        CHECK (sender_id <> receiver_id)
);