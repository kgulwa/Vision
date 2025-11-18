--
-- PostgreSQL database dump
--

\restrict BCtYL6w3nya1yyaZI85K8yBM2VILTsQAZ1bgQkVXp9Uaq5pSRzuDuzOT436LfAl

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: konkecodes
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    name character varying NOT NULL,
    record_id bigint NOT NULL,
    record_type character varying NOT NULL
);


ALTER TABLE public.active_storage_attachments OWNER TO konkecodes;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: konkecodes
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.active_storage_attachments_id_seq OWNER TO konkecodes;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: konkecodes
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: konkecodes
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    content_type character varying,
    created_at timestamp(6) without time zone NOT NULL,
    filename character varying NOT NULL,
    key character varying NOT NULL,
    metadata text,
    service_name character varying NOT NULL
);


ALTER TABLE public.active_storage_blobs OWNER TO konkecodes;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: konkecodes
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.active_storage_blobs_id_seq OWNER TO konkecodes;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: konkecodes
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: konkecodes
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


ALTER TABLE public.active_storage_variant_records OWNER TO konkecodes;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: konkecodes
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNER TO konkecodes;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: konkecodes
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: konkecodes
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO konkecodes;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: konkecodes
--

CREATE TABLE public.comments (
    id bigint NOT NULL,
    content text,
    created_at timestamp(6) without time zone NOT NULL,
    pin_id integer NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.comments OWNER TO konkecodes;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: konkecodes
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comments_id_seq OWNER TO konkecodes;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: konkecodes
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: follows; Type: TABLE; Schema: public; Owner: konkecodes
--

CREATE TABLE public.follows (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    followed_id integer NOT NULL,
    follower_id integer NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.follows OWNER TO konkecodes;

--
-- Name: follows_id_seq; Type: SEQUENCE; Schema: public; Owner: konkecodes
--

CREATE SEQUENCE public.follows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.follows_id_seq OWNER TO konkecodes;

--
-- Name: follows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: konkecodes
--

ALTER SEQUENCE public.follows_id_seq OWNED BY public.follows.id;


--
-- Name: likes; Type: TABLE; Schema: public; Owner: konkecodes
--

CREATE TABLE public.likes (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    pin_id integer NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.likes OWNER TO konkecodes;

--
-- Name: likes_id_seq; Type: SEQUENCE; Schema: public; Owner: konkecodes
--

CREATE SEQUENCE public.likes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.likes_id_seq OWNER TO konkecodes;

--
-- Name: likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: konkecodes
--

ALTER SEQUENCE public.likes_id_seq OWNED BY public.likes.id;


--
-- Name: pins; Type: TABLE; Schema: public; Owner: konkecodes
--

CREATE TABLE public.pins (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    description text,
    reposts_count integer,
    title character varying,
    updated_at timestamp(6) without time zone NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.pins OWNER TO konkecodes;

--
-- Name: pins_id_seq; Type: SEQUENCE; Schema: public; Owner: konkecodes
--

CREATE SEQUENCE public.pins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pins_id_seq OWNER TO konkecodes;

--
-- Name: pins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: konkecodes
--

ALTER SEQUENCE public.pins_id_seq OWNED BY public.pins.id;


--
-- Name: reposts; Type: TABLE; Schema: public; Owner: konkecodes
--

CREATE TABLE public.reposts (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    pin_id integer NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.reposts OWNER TO konkecodes;

--
-- Name: reposts_id_seq; Type: SEQUENCE; Schema: public; Owner: konkecodes
--

CREATE SEQUENCE public.reposts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reposts_id_seq OWNER TO konkecodes;

--
-- Name: reposts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: konkecodes
--

ALTER SEQUENCE public.reposts_id_seq OWNED BY public.reposts.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: konkecodes
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO konkecodes;

--
-- Name: users; Type: TABLE; Schema: public; Owner: konkecodes
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    email character varying,
    password_digest character varying,
    string character varying,
    updated_at timestamp(6) without time zone NOT NULL,
    username character varying
);


ALTER TABLE public.users OWNER TO konkecodes;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: konkecodes
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO konkecodes;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: konkecodes
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: follows id; Type: DEFAULT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.follows ALTER COLUMN id SET DEFAULT nextval('public.follows_id_seq'::regclass);


--
-- Name: likes id; Type: DEFAULT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.likes ALTER COLUMN id SET DEFAULT nextval('public.likes_id_seq'::regclass);


--
-- Name: pins id; Type: DEFAULT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.pins ALTER COLUMN id SET DEFAULT nextval('public.pins_id_seq'::regclass);


--
-- Name: reposts id; Type: DEFAULT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.reposts ALTER COLUMN id SET DEFAULT nextval('public.reposts_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: active_storage_attachments; Type: TABLE DATA; Schema: public; Owner: konkecodes
--

COPY public.active_storage_attachments (id, blob_id, created_at, name, record_id, record_type) FROM stdin;
\.


--
-- Data for Name: active_storage_blobs; Type: TABLE DATA; Schema: public; Owner: konkecodes
--

COPY public.active_storage_blobs (id, byte_size, checksum, content_type, created_at, filename, key, metadata, service_name) FROM stdin;
\.


--
-- Data for Name: active_storage_variant_records; Type: TABLE DATA; Schema: public; Owner: konkecodes
--

COPY public.active_storage_variant_records (id, blob_id, variation_digest) FROM stdin;
\.


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: konkecodes
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	development	2025-11-18 18:56:41.583835	2025-11-18 18:56:41.583842
schema_sha1	201f0dfa85f94b0a619b2ca5188079fceb97ab40	2025-11-18 18:56:41.600494	2025-11-18 18:56:41.6005
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: konkecodes
--

COPY public.comments (id, content, created_at, pin_id, updated_at, user_id) FROM stdin;
\.


--
-- Data for Name: follows; Type: TABLE DATA; Schema: public; Owner: konkecodes
--

COPY public.follows (id, created_at, followed_id, follower_id, updated_at) FROM stdin;
\.


--
-- Data for Name: likes; Type: TABLE DATA; Schema: public; Owner: konkecodes
--

COPY public.likes (id, created_at, pin_id, updated_at, user_id) FROM stdin;
\.


--
-- Data for Name: pins; Type: TABLE DATA; Schema: public; Owner: konkecodes
--

COPY public.pins (id, created_at, description, reposts_count, title, updated_at, user_id) FROM stdin;
\.


--
-- Data for Name: reposts; Type: TABLE DATA; Schema: public; Owner: konkecodes
--

COPY public.reposts (id, created_at, pin_id, updated_at, user_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: konkecodes
--

COPY public.schema_migrations (version) FROM stdin;
20251117224003
20251106115500
20251106115453
20251106115447
20251106115436
20251106115331
20251106114651
20251105152051
20251105075147
20251105073540
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: konkecodes
--

COPY public.users (id, created_at, email, password_digest, string, updated_at, username) FROM stdin;
1	2025-11-18 18:57:50.288154	aphiwe@example.com	$2a$12$kp6zeOV9QhYfjCRA.B405eNS97PvYM6G.OcRdbHHWHa5I7SBrVWcq	\N	2025-11-18 18:57:50.288154	Aphiwe
\.


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: konkecodes
--

SELECT pg_catalog.setval('public.active_storage_attachments_id_seq', 1, false);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: konkecodes
--

SELECT pg_catalog.setval('public.active_storage_blobs_id_seq', 1, false);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: konkecodes
--

SELECT pg_catalog.setval('public.active_storage_variant_records_id_seq', 1, false);


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: konkecodes
--

SELECT pg_catalog.setval('public.comments_id_seq', 1, false);


--
-- Name: follows_id_seq; Type: SEQUENCE SET; Schema: public; Owner: konkecodes
--

SELECT pg_catalog.setval('public.follows_id_seq', 1, false);


--
-- Name: likes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: konkecodes
--

SELECT pg_catalog.setval('public.likes_id_seq', 1, false);


--
-- Name: pins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: konkecodes
--

SELECT pg_catalog.setval('public.pins_id_seq', 1, false);


--
-- Name: reposts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: konkecodes
--

SELECT pg_catalog.setval('public.reposts_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: konkecodes
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: follows follows_pkey; Type: CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (id);


--
-- Name: likes likes_pkey; Type: CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (id);


--
-- Name: pins pins_pkey; Type: CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.pins
    ADD CONSTRAINT pins_pkey PRIMARY KEY (id);


--
-- Name: reposts reposts_pkey; Type: CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.reposts
    ADD CONSTRAINT reposts_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: konkecodes
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: konkecodes
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: konkecodes
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: konkecodes
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_comments_on_pin_id; Type: INDEX; Schema: public; Owner: konkecodes
--

CREATE INDEX index_comments_on_pin_id ON public.comments USING btree (pin_id);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: konkecodes
--

CREATE INDEX index_comments_on_user_id ON public.comments USING btree (user_id);


--
-- Name: index_follows_on_followed_id; Type: INDEX; Schema: public; Owner: konkecodes
--

CREATE INDEX index_follows_on_followed_id ON public.follows USING btree (followed_id);


--
-- Name: index_follows_on_follower_id; Type: INDEX; Schema: public; Owner: konkecodes
--

CREATE INDEX index_follows_on_follower_id ON public.follows USING btree (follower_id);


--
-- Name: index_follows_on_follower_id_and_followed_id; Type: INDEX; Schema: public; Owner: konkecodes
--

CREATE UNIQUE INDEX index_follows_on_follower_id_and_followed_id ON public.follows USING btree (follower_id, followed_id);


--
-- Name: index_likes_on_pin_id; Type: INDEX; Schema: public; Owner: konkecodes
--

CREATE INDEX index_likes_on_pin_id ON public.likes USING btree (pin_id);


--
-- Name: index_likes_on_user_id; Type: INDEX; Schema: public; Owner: konkecodes
--

CREATE INDEX index_likes_on_user_id ON public.likes USING btree (user_id);


--
-- Name: index_likes_on_user_id_and_pin_id; Type: INDEX; Schema: public; Owner: konkecodes
--

CREATE UNIQUE INDEX index_likes_on_user_id_and_pin_id ON public.likes USING btree (user_id, pin_id);


--
-- Name: index_pins_on_user_id; Type: INDEX; Schema: public; Owner: konkecodes
--

CREATE INDEX index_pins_on_user_id ON public.pins USING btree (user_id);


--
-- Name: index_reposts_on_pin_id; Type: INDEX; Schema: public; Owner: konkecodes
--

CREATE INDEX index_reposts_on_pin_id ON public.reposts USING btree (pin_id);


--
-- Name: index_reposts_on_user_id; Type: INDEX; Schema: public; Owner: konkecodes
--

CREATE INDEX index_reposts_on_user_id ON public.reposts USING btree (user_id);


--
-- Name: index_reposts_on_user_id_and_pin_id; Type: INDEX; Schema: public; Owner: konkecodes
--

CREATE UNIQUE INDEX index_reposts_on_user_id_and_pin_id ON public.reposts USING btree (user_id, pin_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: konkecodes
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: comments fk_rails_03de2dc08c; Type: FK CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_03de2dc08c FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: likes fk_rails_1e09b5dabf; Type: FK CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT fk_rails_1e09b5dabf FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: pins fk_rails_51b0c024f1; Type: FK CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.pins
    ADD CONSTRAINT fk_rails_51b0c024f1 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: follows fk_rails_5ef72a3867; Type: FK CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT fk_rails_5ef72a3867 FOREIGN KEY (followed_id) REFERENCES public.users(id);


--
-- Name: follows fk_rails_622d34a301; Type: FK CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT fk_rails_622d34a301 FOREIGN KEY (follower_id) REFERENCES public.users(id);


--
-- Name: likes fk_rails_761dab019f; Type: FK CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT fk_rails_761dab019f FOREIGN KEY (pin_id) REFERENCES public.pins(id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: reposts fk_rails_c395f67885; Type: FK CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.reposts
    ADD CONSTRAINT fk_rails_c395f67885 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: comments fk_rails_e43582f94b; Type: FK CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_e43582f94b FOREIGN KEY (pin_id) REFERENCES public.pins(id);


--
-- Name: reposts fk_rails_f83c75b31a; Type: FK CONSTRAINT; Schema: public; Owner: konkecodes
--

ALTER TABLE ONLY public.reposts
    ADD CONSTRAINT fk_rails_f83c75b31a FOREIGN KEY (pin_id) REFERENCES public.pins(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO konkecodes;


--
-- PostgreSQL database dump complete
--

\unrestrict BCtYL6w3nya1yyaZI85K8yBM2VILTsQAZ1bgQkVXp9Uaq5pSRzuDuzOT436LfAl

