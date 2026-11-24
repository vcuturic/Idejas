CREATE TABLE IF NOT EXISTS post_required_tags (
    post_id BIGINT NOT NULL
        REFERENCES posts(id),

    tag_id BIGINT NOT NULL
        REFERENCES tags(id),

    min_verification VARCHAR(30) NOT NULL DEFAULT 'SELF_DECLARED'
        CHECK (min_verification IN (
            'SELF_DECLARED',
			'PENDING',
            'PURSUING',
            'VERIFIED'
        )),

	min_qualification VARCHAR(30) NOT NULL DEFAULT 'OTHER'
    CHECK (min_qualification IN (
		'OTHER',
		'PROFESSIONAL_CERTIFICATE',
        'BACHELORS_DEGREE',
        'MASTERS_DEGREE',
        'DOCTORAL_DEGREE'
    )),

    PRIMARY KEY (post_id, tag_id)
);