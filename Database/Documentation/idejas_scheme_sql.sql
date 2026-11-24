--
-- PostgreSQL database dump
--

\restrict JflhHVIp9DMbW5Wv9wJl4f81jk7Exk1j1E51iwpeQTq7xO5ZjZtLUoNnu97IWGh

-- Dumped from database version 19.0
-- Dumped by pg_dump version 19.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: appreciations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appreciations (
    id bigint NOT NULL,
    sender_id bigint NOT NULL,
    receiver_id bigint NOT NULL,
    idea_id bigint NOT NULL,
    post_id bigint NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT appreciation_no_self CHECK ((sender_id <> receiver_id))
);


ALTER TABLE public.appreciations OWNER TO postgres;

--
-- Name: appreciations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.appreciations ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.appreciations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: idea_bids; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.idea_bids (
    id bigint NOT NULL,
    listing_id bigint NOT NULL,
    bidder_id bigint NOT NULL,
    amount numeric(12,2) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT idea_bids_amount_check CHECK ((amount > (0)::numeric))
);


ALTER TABLE public.idea_bids OWNER TO postgres;

--
-- Name: idea_bids_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.idea_bids ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.idea_bids_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: idea_listings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.idea_listings (
    id bigint NOT NULL,
    idea_id bigint NOT NULL,
    seller_id bigint NOT NULL,
    listing_type character varying(20) NOT NULL,
    starting_price numeric(12,2),
    fixed_price numeric(12,2),
    currency character varying(3) DEFAULT 'EUR'::character varying NOT NULL,
    status character varying(20) DEFAULT 'ACTIVE'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    expires_at timestamp with time zone,
    CONSTRAINT idea_listings_listing_type_check CHECK (((listing_type)::text = ANY ((ARRAY['AUCTION'::character varying, 'FIXED_PRICE'::character varying, 'FREE_TRANSFER'::character varying])::text[]))),
    CONSTRAINT idea_listings_status_check CHECK (((status)::text = ANY ((ARRAY['ACTIVE'::character varying, 'COMPLETED'::character varying, 'CANCELLED'::character varying, 'EXPIRED'::character varying])::text[]))),
    CONSTRAINT listing_price_check CHECK (((((listing_type)::text = 'AUCTION'::text) AND (starting_price IS NOT NULL) AND (starting_price >= (0)::numeric) AND (fixed_price IS NULL)) OR (((listing_type)::text = 'FIXED_PRICE'::text) AND (fixed_price IS NOT NULL) AND (fixed_price > (0)::numeric) AND (starting_price IS NULL)) OR (((listing_type)::text = 'FREE_TRANSFER'::text) AND (starting_price IS NULL) AND (fixed_price IS NULL))))
);


ALTER TABLE public.idea_listings OWNER TO postgres;

--
-- Name: idea_listings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.idea_listings ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.idea_listings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: idea_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.idea_members (
    id bigint NOT NULL,
    idea_id bigint NOT NULL,
    user_id bigint NOT NULL,
    team_role character varying(30) DEFAULT 'CONTRIBUTOR'::character varying NOT NULL,
    joined_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT idea_members_team_role_check CHECK (((team_role)::text = ANY ((ARRAY['OWNER'::character varying, 'TEAM_LEAD'::character varying, 'CONTRIBUTOR'::character varying, 'REVIEWER'::character varying, 'ADVISOR'::character varying])::text[])))
);


ALTER TABLE public.idea_members OWNER TO postgres;

--
-- Name: idea_members_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.idea_members ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.idea_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: post_required_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post_required_tags (
    post_id bigint NOT NULL,
    tag_id bigint NOT NULL,
    min_verification character varying(30) DEFAULT 'SELF_DECLARED'::character varying NOT NULL,
    min_qualification character varying(30) DEFAULT 'OTHER'::character varying NOT NULL,
    CONSTRAINT post_required_tags_min_qualification_check CHECK (((min_qualification)::text = ANY ((ARRAY['OTHER'::character varying, 'PROFESSIONAL_CERTIFICATE'::character varying, 'BACHELORS_DEGREE'::character varying, 'MASTERS_DEGREE'::character varying, 'DOCTORAL_DEGREE'::character varying])::text[]))),
    CONSTRAINT post_required_tags_min_verification_check CHECK (((min_verification)::text = ANY ((ARRAY['SELF_DECLARED'::character varying, 'PENDING'::character varying, 'PURSUING'::character varying, 'VERIFIED'::character varying])::text[])))
);


ALTER TABLE public.post_required_tags OWNER TO postgres;

--
-- Name: post_votes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post_votes (
    id bigint NOT NULL,
    post_id bigint NOT NULL,
    user_id bigint NOT NULL,
    vote_type character varying(10) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT post_votes_vote_type_check CHECK (((vote_type)::text = ANY ((ARRAY['LIKE'::character varying, 'DISLIKE'::character varying])::text[])))
);


ALTER TABLE public.post_votes OWNER TO postgres;

--
-- Name: post_votes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.post_votes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.post_votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.posts (
    id bigint NOT NULL,
    author_id bigint NOT NULL,
    owner_id bigint NOT NULL,
    title character varying(255),
    content jsonb NOT NULL,
    root_post_id bigint,
    quoted_post_id bigint,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone,
    post_type character varying(20) NOT NULL,
    status character varying(20) DEFAULT 'PUBLISHED'::character varying NOT NULL,
    min_verification_level smallint DEFAULT 1 NOT NULL,
    CONSTRAINT posts_min_verification_level_check CHECK (((min_verification_level >= 1) AND (min_verification_level <= 3))),
    CONSTRAINT posts_post_type_check CHECK (((post_type)::text = ANY ((ARRAY['STANDARD'::character varying, 'IDEA'::character varying, 'COMMENT'::character varying])::text[]))),
    CONSTRAINT posts_status_check CHECK (((status)::text = ANY ((ARRAY['DRAFT'::character varying, 'PUBLISHED'::character varying, 'ARCHIVED'::character varying])::text[]))),
    CONSTRAINT posts_type_structure_check CHECK (((((post_type)::text = ANY ((ARRAY['STANDARD'::character varying, 'IDEA'::character varying])::text[])) AND (root_post_id IS NULL)) OR (((post_type)::text = 'COMMENT'::text) AND (root_post_id IS NOT NULL))))
);


ALTER TABLE public.posts OWNER TO postgres;

--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.posts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    name character varying(30) NOT NULL,
    qualification_level character varying(30) DEFAULT 'OTHER'::character varying NOT NULL,
    CONSTRAINT tags_qualification_level_check CHECK (((qualification_level)::text = ANY ((ARRAY['OTHER'::character varying, 'PROFESSIONAL_CERTIFICATE'::character varying, 'BACHELORS_DEGREE'::character varying, 'MASTERS_DEGREE'::character varying, 'DOCTORAL_DEGREE'::character varying])::text[])))
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tags ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: user_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_tags (
    user_id bigint NOT NULL,
    tag_id bigint NOT NULL,
    verification_status character varying(20) DEFAULT 'SELF_DECLARED'::character varying NOT NULL,
    assigned_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    verified_at timestamp with time zone,
    CONSTRAINT user_tags_verification_status_check CHECK (((verification_status)::text = ANY ((ARRAY['SELF_DECLARED'::character varying, 'PURSUING'::character varying, 'PENDING'::character varying, 'VERIFIED'::character varying])::text[])))
);


ALTER TABLE public.user_tags OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying(50) NOT NULL,
    umcn character varying(20),
    email character varying(50) NOT NULL,
    password_hash text NOT NULL,
    display_name character varying(50),
    bio text,
    profile_picture_url text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    is_banned boolean DEFAULT false NOT NULL,
    is_online boolean DEFAULT false NOT NULL,
    is_email_verified boolean DEFAULT false NOT NULL,
    is_phone_verified boolean DEFAULT false NOT NULL,
    is_identity_verified boolean DEFAULT false NOT NULL,
    email_verified_at timestamp with time zone,
    phone_verified_at timestamp with time zone,
    identity_verified_at timestamp with time zone,
    last_seen_at timestamp with time zone,
    role character varying(20) DEFAULT 'USER'::character varying NOT NULL,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['USER'::character varying, 'MODERATOR'::character varying, 'ADMIN'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.users ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: appreciations appreciations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appreciations
    ADD CONSTRAINT appreciations_pkey PRIMARY KEY (id);


--
-- Name: idea_bids idea_bids_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idea_bids
    ADD CONSTRAINT idea_bids_pkey PRIMARY KEY (id);


--
-- Name: idea_listings idea_listings_idea_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idea_listings
    ADD CONSTRAINT idea_listings_idea_id_key UNIQUE (idea_id);


--
-- Name: idea_listings idea_listings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idea_listings
    ADD CONSTRAINT idea_listings_pkey PRIMARY KEY (id);


--
-- Name: idea_members idea_members_idea_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idea_members
    ADD CONSTRAINT idea_members_idea_id_user_id_key UNIQUE (idea_id, user_id);


--
-- Name: idea_members idea_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idea_members
    ADD CONSTRAINT idea_members_pkey PRIMARY KEY (id);


--
-- Name: post_required_tags post_required_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_required_tags
    ADD CONSTRAINT post_required_tags_pkey PRIMARY KEY (post_id, tag_id);


--
-- Name: post_votes post_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_votes
    ADD CONSTRAINT post_votes_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: tags tags_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_name_key UNIQUE (name);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: post_votes unique_user_post_vote; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_votes
    ADD CONSTRAINT unique_user_post_vote UNIQUE (post_id, user_id);


--
-- Name: user_tags user_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tags
    ADD CONSTRAINT user_tags_pkey PRIMARY KEY (user_id, tag_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_umcn_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_umcn_key UNIQUE (umcn);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: appreciations appreciations_idea_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appreciations
    ADD CONSTRAINT appreciations_idea_id_fkey FOREIGN KEY (idea_id) REFERENCES public.posts(id);


--
-- Name: appreciations appreciations_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appreciations
    ADD CONSTRAINT appreciations_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id);


--
-- Name: appreciations appreciations_receiver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appreciations
    ADD CONSTRAINT appreciations_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES public.users(id);


--
-- Name: appreciations appreciations_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appreciations
    ADD CONSTRAINT appreciations_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id);


--
-- Name: idea_bids idea_bids_bidder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idea_bids
    ADD CONSTRAINT idea_bids_bidder_id_fkey FOREIGN KEY (bidder_id) REFERENCES public.users(id);


--
-- Name: idea_bids idea_bids_listing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idea_bids
    ADD CONSTRAINT idea_bids_listing_id_fkey FOREIGN KEY (listing_id) REFERENCES public.idea_listings(id);


--
-- Name: idea_listings idea_listings_idea_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idea_listings
    ADD CONSTRAINT idea_listings_idea_id_fkey FOREIGN KEY (idea_id) REFERENCES public.posts(id);


--
-- Name: idea_listings idea_listings_seller_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idea_listings
    ADD CONSTRAINT idea_listings_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.users(id);


--
-- Name: idea_members idea_members_idea_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idea_members
    ADD CONSTRAINT idea_members_idea_id_fkey FOREIGN KEY (idea_id) REFERENCES public.posts(id);


--
-- Name: idea_members idea_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.idea_members
    ADD CONSTRAINT idea_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: post_required_tags post_required_tags_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_required_tags
    ADD CONSTRAINT post_required_tags_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id);


--
-- Name: post_required_tags post_required_tags_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_required_tags
    ADD CONSTRAINT post_required_tags_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tags(id);


--
-- Name: post_votes post_votes_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_votes
    ADD CONSTRAINT post_votes_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id);


--
-- Name: post_votes post_votes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_votes
    ADD CONSTRAINT post_votes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: posts posts_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id);


--
-- Name: posts posts_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: posts posts_quoted_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_quoted_post_id_fkey FOREIGN KEY (quoted_post_id) REFERENCES public.posts(id);


--
-- Name: posts posts_root_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_root_post_id_fkey FOREIGN KEY (root_post_id) REFERENCES public.posts(id);


--
-- Name: user_tags user_tags_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tags
    ADD CONSTRAINT user_tags_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tags(id);


--
-- Name: user_tags user_tags_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_tags
    ADD CONSTRAINT user_tags_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict JflhHVIp9DMbW5Wv9wJl4f81jk7Exk1j1E51iwpeQTq7xO5ZjZtLUoNnu97IWGh

