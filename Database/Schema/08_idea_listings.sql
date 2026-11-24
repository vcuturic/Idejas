CREATE TABLE IF NOT EXISTS idea_listings (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    idea_id BIGINT NOT NULL UNIQUE
        REFERENCES posts(id),

    seller_id BIGINT NOT NULL
        REFERENCES users(id),

    listing_type VARCHAR(20) NOT NULL
        CHECK (listing_type IN (
            'AUCTION',
            'FIXED_PRICE',
            'FREE_TRANSFER'
        )),

    starting_price NUMERIC(12, 2),

    fixed_price NUMERIC(12, 2),

    currency VARCHAR(3) NOT NULL DEFAULT 'EUR',

    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
        CHECK (status IN (
            'ACTIVE',
            'COMPLETED',
            'CANCELLED',
            'EXPIRED'
        )),

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    expires_at TIMESTAMPTZ,

    CONSTRAINT listing_price_check CHECK (
        (
            listing_type = 'AUCTION'
            AND starting_price IS NOT NULL
            AND starting_price >= 0
            AND fixed_price IS NULL
        )
        OR
        (
            listing_type = 'FIXED_PRICE'
            AND fixed_price IS NOT NULL
            AND fixed_price > 0
            AND starting_price IS NULL
        )
        OR
        (
            listing_type = 'FREE_TRANSFER'
            AND starting_price IS NULL
            AND fixed_price IS NULL
        )
    )
);