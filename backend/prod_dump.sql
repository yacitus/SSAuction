--
-- PostgreSQL database dump
--

-- Dumped from database version 12.5 (Ubuntu 12.5-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 13.1

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

--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: all_players; Type: TABLE; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE TABLE public.all_players (
    id bigint NOT NULL,
    year_range character varying(255) NOT NULL,
    ssnum integer NOT NULL,
    name character varying(255) NOT NULL,
    "position" character varying(255) NOT NULL,
    inserted_at timestamp(0) without time zone DEFAULT '2021-01-01 00:00:01'::timestamp without time zone NOT NULL,
    updated_at timestamp(0) without time zone DEFAULT '2021-01-01 00:00:01'::timestamp without time zone NOT NULL
);


ALTER TABLE public.all_players OWNER TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";

--
-- Name: all_players_id_seq; Type: SEQUENCE; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE SEQUENCE public.all_players_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.all_players_id_seq OWNER TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";

--
-- Name: all_players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER SEQUENCE public.all_players_id_seq OWNED BY public.all_players.id;


--
-- Name: auctions; Type: TABLE; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE TABLE public.auctions (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    year_range character varying(255) NOT NULL,
    nominations_per_team integer NOT NULL,
    seconds_before_autonomination integer NOT NULL,
    new_nominations_created character varying(255) NOT NULL,
    bid_timeout_seconds integer NOT NULL,
    active boolean NOT NULL,
    players_per_team integer NOT NULL,
    must_roster_all_players boolean NOT NULL,
    team_dollars_per_player integer NOT NULL,
    started_or_paused_at timestamp(0) without time zone,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.auctions OWNER TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";

--
-- Name: auctions_id_seq; Type: SEQUENCE; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE SEQUENCE public.auctions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auctions_id_seq OWNER TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";

--
-- Name: auctions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER SEQUENCE public.auctions_id_seq OWNED BY public.auctions.id;


--
-- Name: auctions_users; Type: TABLE; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE TABLE public.auctions_users (
    id bigint NOT NULL,
    auction_id bigint,
    user_id bigint
);


ALTER TABLE public.auctions_users OWNER TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";

--
-- Name: auctions_users_id_seq; Type: SEQUENCE; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE SEQUENCE public.auctions_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auctions_users_id_seq OWNER TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";

--
-- Name: auctions_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER SEQUENCE public.auctions_users_id_seq OWNED BY public.auctions_users.id;


--
-- Name: bids; Type: TABLE; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE TABLE public.bids (
    id bigint NOT NULL,
    bid_amount integer NOT NULL,
    hidden_high_bid integer,
    expires_at timestamp(0) without time zone NOT NULL,
    nominated_by integer NOT NULL,
    team_id bigint,
    auction_id bigint,
    closed boolean NOT NULL,
    inserted_at timestamp(0) without time zone DEFAULT '2021-01-01 00:00:01'::timestamp without time zone NOT NULL,
    updated_at timestamp(0) without time zone DEFAULT '2021-01-01 00:00:01'::timestamp without time zone NOT NULL
);


ALTER TABLE public.bids OWNER TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";

--
-- Name: bids_id_seq; Type: SEQUENCE; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE SEQUENCE public.bids_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bids_id_seq OWNER TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";

--
-- Name: bids_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER SEQUENCE public.bids_id_seq OWNED BY public.bids.id;


--
-- Name: ordered_players; Type: TABLE; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE TABLE public.ordered_players (
    id bigint NOT NULL,
    rank integer NOT NULL,
    player_id bigint,
    team_id bigint,
    auction_id bigint,
    inserted_at timestamp(0) without time zone DEFAULT '2021-01-01 00:00:01'::timestamp without time zone NOT NULL,
    updated_at timestamp(0) without time zone DEFAULT '2021-01-01 00:00:01'::timestamp without time zone NOT NULL
);


ALTER TABLE public.ordered_players OWNER TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";

--
-- Name: ordered_players_id_seq; Type: SEQUENCE; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE SEQUENCE public.ordered_players_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ordered_players_id_seq OWNER TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";

--
-- Name: ordered_players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER SEQUENCE public.ordered_players_id_seq OWNED BY public.ordered_players.id;


--
-- Name: players; Type: TABLE; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE TABLE public.players (
    id bigint NOT NULL,
    year_range character varying(255) NOT NULL,
    ssnum integer NOT NULL,
    name character varying(255) NOT NULL,
    "position" character varying(255) NOT NULL,
    bid_id bigint,
    rostered_player_id bigint,
    auction_id bigint,
    inserted_at timestamp(0) without time zone DEFAULT '2021-01-01 00:00:01'::timestamp without time zone NOT NULL,
    updated_at timestamp(0) without time zone DEFAULT '2021-01-01 00:00:01'::timestamp without time zone NOT NULL
);


ALTER TABLE public.players OWNER TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";

--
-- Name: players_id_seq; Type: SEQUENCE; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE SEQUENCE public.players_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.players_id_seq OWNER TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";

--
-- Name: players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER SEQUENCE public.players_id_seq OWNED BY public.players.id;


--
-- Name: rostered_players; Type: TABLE; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE TABLE public.rostered_players (
    id bigint NOT NULL,
    cost integer NOT NULL,
    team_id bigint,
    auction_id bigint,
    inserted_at timestamp(0) without time zone DEFAULT '2021-01-01 00:00:01'::timestamp without time zone NOT NULL,
    updated_at timestamp(0) without time zone DEFAULT '2021-01-01 00:00:01'::timestamp without time zone NOT NULL
);


ALTER TABLE public.rostered_players OWNER TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";

--
-- Name: rostered_players_id_seq; Type: SEQUENCE; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE SEQUENCE public.rostered_players_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rostered_players_id_seq OWNER TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";

--
-- Name: rostered_players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER SEQUENCE public.rostered_players_id_seq OWNED BY public.rostered_players.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE public.schema_migrations OWNER TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";

--
-- Name: teams; Type: TABLE; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE TABLE public.teams (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    unused_nominations integer NOT NULL,
    time_nominations_expire timestamp(0) without time zone,
    new_nominations_open_at timestamp(0) without time zone,
    auction_id bigint,
    inserted_at timestamp(0) without time zone DEFAULT '2021-01-01 00:00:01'::timestamp without time zone NOT NULL,
    updated_at timestamp(0) without time zone DEFAULT '2021-01-01 00:00:01'::timestamp without time zone NOT NULL
);


ALTER TABLE public.teams OWNER TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";

--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE SEQUENCE public.teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teams_id_seq OWNER TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";

--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


--
-- Name: teams_users; Type: TABLE; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE TABLE public.teams_users (
    id bigint NOT NULL,
    team_id bigint,
    user_id bigint
);


ALTER TABLE public.teams_users OWNER TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";

--
-- Name: teams_users_id_seq; Type: SEQUENCE; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE SEQUENCE public.teams_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teams_users_id_seq OWNER TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";

--
-- Name: teams_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER SEQUENCE public.teams_users_id_seq OWNED BY public.teams_users.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    super boolean NOT NULL,
    password_hash character varying(255) NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    slack_display_name character varying(255) NOT NULL
);


ALTER TABLE public.users OWNER TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: all_players id; Type: DEFAULT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.all_players ALTER COLUMN id SET DEFAULT nextval('public.all_players_id_seq'::regclass);


--
-- Name: auctions id; Type: DEFAULT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.auctions ALTER COLUMN id SET DEFAULT nextval('public.auctions_id_seq'::regclass);


--
-- Name: auctions_users id; Type: DEFAULT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.auctions_users ALTER COLUMN id SET DEFAULT nextval('public.auctions_users_id_seq'::regclass);


--
-- Name: bids id; Type: DEFAULT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.bids ALTER COLUMN id SET DEFAULT nextval('public.bids_id_seq'::regclass);


--
-- Name: ordered_players id; Type: DEFAULT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.ordered_players ALTER COLUMN id SET DEFAULT nextval('public.ordered_players_id_seq'::regclass);


--
-- Name: players id; Type: DEFAULT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.players ALTER COLUMN id SET DEFAULT nextval('public.players_id_seq'::regclass);


--
-- Name: rostered_players id; Type: DEFAULT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.rostered_players ALTER COLUMN id SET DEFAULT nextval('public.rostered_players_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- Name: teams_users id; Type: DEFAULT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.teams_users ALTER COLUMN id SET DEFAULT nextval('public.teams_users_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: all_players; Type: TABLE DATA; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

COPY public.all_players (id, year_range, ssnum, name, "position", inserted_at, updated_at) FROM stdin;
1	1988-1991-SL	1	Frank Viola	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
2	1988-1991-SL	3	Tom Browning	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
3	1988-1991-SL	5	Dennis Martinez	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
4	1988-1991-SL	7	David Cone	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
5	1988-1991-SL	9	Jose DeLeon	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
6	1988-1991-SL	11	Dwight Gooden	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
7	1988-1991-SL	13	Tim Belcher	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
8	1988-1991-SL	15	Tim Leary	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
9	1988-1991-SL	17	Ed Whitson	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
10	1988-1991-SL	19	Zane Smith	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
11	1988-1991-SL	21	Kevin Gross	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
12	1988-1991-SL	23	Jose Rijo	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
13	1988-1991-SL	25	Rick Mahler	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
14	1988-1991-SL	27	Mike Scott	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
15	1988-1991-SL	29	Don Robinson	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
16	1988-1991-SL	31	Joe Magrane	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
17	1988-1991-SL	33	Ramon Martinez	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
18	1988-1991-SL	35	Rick Sutcliffe	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
19	1988-1991-SL	37	OilCan Boyd	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
20	1988-1991-SL	39	Danny Darwin	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
21	1988-1991-SL	41	Bruce Ruffin	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
22	1988-1991-SL	43	Jim Clancy	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
23	1988-1991-SL	45	Scott Garrelts	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
24	1988-1991-SL	47	Pascual Perez	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
25	1988-1991-SL	49	Ken Hill	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
26	1988-1991-SL	51	Neal Heaton	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
27	1988-1991-SL	53	Kelly Downs	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
28	1988-1991-SL	55	Norm Charlton	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
29	1988-1991-SL	57	Jimmy Jones	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
30	1988-1991-SL	59	Jeff Robinson(Pit)	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
31	1988-1991-SL	61	Greg Harris(SD)	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
32	1988-1991-SL	63	Bob Knepper	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
33	1988-1991-SL	65	Randy Myers	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
34	1988-1991-SL	67	Bob Tewksbury	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
35	1988-1991-SL	69	Mark Gardner	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
36	1988-1991-SL	71	Ron Robinson	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
37	1988-1991-SL	73	Ken Howell	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
38	1988-1991-SL	75	Jose DeJesus	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
39	1988-1991-SL	77	Atlee Hammaker	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
40	1988-1991-SL	79	Derek Lilliquist	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
41	1988-1991-SL	81	Jeff Pico	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
42	1988-1991-SL	83	Pat Combs	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
43	1988-1991-SL	85	Scott Scudder	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
44	1988-1991-SL	87	Mike Maddux	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
45	1988-1991-SL	89	Steve Wilson	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
46	1988-1991-SL	91	Ricky Horton	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
47	1988-1991-SL	93	Shawn Boskie	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
48	1988-1991-SL	95	Omar Olivares	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
49	1988-1991-SL	97	Marty Clary	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
50	1988-1991-SL	99	Danny Cox	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
51	1988-1991-SL	101	Bob Patterson	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
52	1988-1991-SL	103	Bill Sampen	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
53	1988-1991-SL	105	Mike Krukow	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
54	1988-1991-SL	107	Brian Fisher	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
55	1988-1991-SL	109	Darryl Kile	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
56	1988-1991-SL	111	Xavier Hernandez	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
57	1988-1991-SL	113	David Palmer	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
58	1988-1991-SL	115	Randy O'Neal	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
59	1988-1991-SL	117	Jason Grimsley	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
60	1988-1991-SL	119	Floyd Youmans	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
61	1988-1991-SL	121	Rick Reed	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
62	1988-1991-SL	123	Frank Castillo	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
63	1988-1991-SL	125	Bob Scanlan	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
64	1988-1991-SL	127	Jose Nunez	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
65	1988-1991-SL	129	Greg Booker	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
66	1988-1991-SL	131	Mario Soto	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
67	1988-1991-SL	133	Kip Gross	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
68	1988-1991-SL	135	Chris Haney	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
69	1988-1991-SL	137	Bob Sebra	SP	2021-01-01 00:00:01	2021-01-01 00:00:01
70	1988-1991-SL	139	Paul Assenmacher	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
71	1988-1991-SL	141	Craig Lefferts	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
72	1988-1991-SL	143	Rob Dibble	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
73	1988-1991-SL	145	Jeff Parrett	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
74	1988-1991-SL	147	Tim Crews	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
75	1988-1991-SL	149	Larry Andersen	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
76	1988-1991-SL	151	Jeff Brantley	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
77	1988-1991-SL	153	Joe Boever	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
78	1988-1991-SL	155	Bob Kipper	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
79	1988-1991-SL	157	Frank DiPino	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
80	1988-1991-SL	159	Jim Gott	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
81	1988-1991-SL	161	Ken Dayley	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
82	1988-1991-SL	163	John Costello	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
83	1988-1991-SL	165	Jose Alvarez	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
84	1988-1991-SL	167	Stan Belinda	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
85	1988-1991-SL	169	Rich Gossage	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
86	1988-1991-SL	171	Todd Worrell	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
87	1988-1991-SL	173	Scott Ruskin	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
88	1988-1991-SL	175	Kent Tekulve	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
89	1988-1991-SL	177	Rich Rodriguez	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
90	1988-1991-SL	179	Kent Mercker	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
91	1988-1991-SL	181	Doug Bair	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
92	1988-1991-SL	183	Tim Layana	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
93	1988-1991-SL	185	Al Osuna	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
94	1988-1991-SL	187	Dave Leiper	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
95	1988-1991-SL	189	Wally Ritchie	RP	2021-01-01 00:00:01	2021-01-01 00:00:01
96	1988-1991-SL	191	Benito Santiago	C	2021-01-01 00:00:01	2021-01-01 00:00:01
97	1988-1991-SL	193	Mike Scioscia	C	2021-01-01 00:00:01	2021-01-01 00:00:01
98	1988-1991-SL	195	Mike LaValliere	C	2021-01-01 00:00:01	2021-01-01 00:00:01
99	1988-1991-SL	197	Gary Carter	C	2021-01-01 00:00:01	2021-01-01 00:00:01
100	1988-1991-SL	199	Jeff Reed	C	2021-01-01 00:00:01	2021-01-01 00:00:01
101	1988-1991-SL	201	Tom Pagnozzi	C	2021-01-01 00:00:01	2021-01-01 00:00:01
102	1988-1991-SL	203	Damon Berryhill	C	2021-01-01 00:00:01	2021-01-01 00:00:01
103	1988-1991-SL	205	Mackey Sasser	C	2021-01-01 00:00:01	2021-01-01 00:00:01
104	1988-1991-SL	207	Lloyd McClendon	C/1B/OF	2021-01-01 00:00:01	2021-01-01 00:00:01
105	1988-1991-SL	209	Rick Dempsey	C	2021-01-01 00:00:01	2021-01-01 00:00:01
106	1988-1991-SL	211	Jody Davis	C	2021-01-01 00:00:01	2021-01-01 00:00:01
107	1988-1991-SL	213	Mark Parent	C	2021-01-01 00:00:01	2021-01-01 00:00:01
108	1988-1991-SL	215	Bo Diaz	C	2021-01-01 00:00:01	2021-01-01 00:00:01
109	1988-1991-SL	217	Bruce Benedict	C	2021-01-01 00:00:01	2021-01-01 00:00:01
110	1988-1991-SL	219	John Russell(of)	C	2021-01-01 00:00:01	2021-01-01 00:00:01
111	1988-1991-SL	221	Ozzie Virgil	C	2021-01-01 00:00:01	2021-01-01 00:00:01
112	1988-1991-SL	223	Alan Ashby	C	2021-01-01 00:00:01	2021-01-01 00:00:01
113	1988-1991-SL	225	Francisco Cabrera	C/1B	2021-01-01 00:00:01	2021-01-01 00:00:01
114	1988-1991-SL	227	Gilberto Reyes	C	2021-01-01 00:00:01	2021-01-01 00:00:01
115	1988-1991-SL	229	Will Clark	1B	2021-01-01 00:00:01	2021-01-01 00:00:01
116	1988-1991-SL	231	Andres Galarraga	1B	2021-01-01 00:00:01	2021-01-01 00:00:01
117	1988-1991-SL	233	Todd Benzinger	1B	2021-01-01 00:00:01	2021-01-01 00:00:01
118	1988-1991-SL	235	Dave Magadan	1B	2021-01-01 00:00:01	2021-01-01 00:00:01
119	1988-1991-SL	237	Ricky Jordan	1B	2021-01-01 00:00:01	2021-01-01 00:00:01
120	1988-1991-SL	239	Franklin Stubbs	1B/OF	2021-01-01 00:00:01	2021-01-01 00:00:01
121	1988-1991-SL	241	Keith Hernandez	1B	2021-01-01 00:00:01	2021-01-01 00:00:01
122	1988-1991-SL	243	Jeff Bagwell	1B	2021-01-01 00:00:01	2021-01-01 00:00:01
123	1988-1991-SL	245	Brian Hunter	1B	2021-01-01 00:00:01	2021-01-01 00:00:01
124	1988-1991-SL	247	Phil Stephenson	1B	2021-01-01 00:00:01	2021-01-01 00:00:01
125	1988-1991-SL	249	Benny Distefano	1B	2021-01-01 00:00:01	2021-01-01 00:00:01
126	1988-1991-SL	251	Roberto Alomar	2B	2021-01-01 00:00:01	2021-01-01 00:00:01
127	1988-1991-SL	253	Jose Lind	2B	2021-01-01 00:00:01	2021-01-01 00:00:01
128	1988-1991-SL	255	Ron Gant	2B/OF	2021-01-01 00:00:01	2021-01-01 00:00:01
129	1988-1991-SL	257	Bill Doran	2B	2021-01-01 00:00:01	2021-01-01 00:00:01
130	1988-1991-SL	259	Gregg Jefferies	2B/3B	2021-01-01 00:00:01	2021-01-01 00:00:01
131	1988-1991-SL	261	Bip Roberts	2B/3B/OF	2021-01-01 00:00:01	2021-01-01 00:00:01
132	1988-1991-SL	263	Delino DeShields	2B	2021-01-01 00:00:01	2021-01-01 00:00:01
133	1988-1991-SL	265	Tim Teufel	2B/1B/3B	2021-01-01 00:00:01	2021-01-01 00:00:01
134	1988-1991-SL	267	Rex Hudler	2B/SS/OF	2021-01-01 00:00:01	2021-01-01 00:00:01
135	1988-1991-SL	269	Mark Lemke	2B/3B	2021-01-01 00:00:01	2021-01-01 00:00:01
136	1988-1991-SL	271	Greg Litton	2B/3B/OF	2021-01-01 00:00:01	2021-01-01 00:00:01
137	1988-1991-SL	273	Luis Alicea	2B	2021-01-01 00:00:01	2021-01-01 00:00:01
138	1988-1991-SL	275	Damaso Garcia	2B	2021-01-01 00:00:01	2021-01-01 00:00:01
139	1988-1991-SL	277	Dave Concepcion	2B	2021-01-01 00:00:01	2021-01-01 00:00:01
140	1988-1991-SL	279	Bobby Bonilla	3B/OF	2021-01-01 00:00:01	2021-01-01 00:00:01
141	1988-1991-SL	281	Howard Johnson	3B/SS	2021-01-01 00:00:01	2021-01-01 00:00:01
142	1988-1991-SL	283	Chris Sabo	3B	2021-01-01 00:00:01	2021-01-01 00:00:01
143	1988-1991-SL	285	Matt Williams	3B	2021-01-01 00:00:01	2021-01-01 00:00:01
144	1988-1991-SL	287	Charlie Hayes	3B	2021-01-01 00:00:01	2021-01-01 00:00:01
145	1988-1991-SL	289	Vance Law	3B	2021-01-01 00:00:01	2021-01-01 00:00:01
146	1988-1991-SL	291	Ken Oberkfell	3B	2021-01-01 00:00:01	2021-01-01 00:00:01
147	1988-1991-SL	293	Mike Sharperson	3B	2021-01-01 00:00:01	2021-01-01 00:00:01
148	1988-1991-SL	295	Mickey Hatcher	3B/1B/OF	2021-01-01 00:00:01	2021-01-01 00:00:01
149	1988-1991-SL	297	Chico Walker	3B/OF	2021-01-01 00:00:01	2021-01-01 00:00:01
150	1988-1991-SL	299	Tim Flannery	3B	2021-01-01 00:00:01	2021-01-01 00:00:01
151	1988-1991-SL	301	Dave Hollins	3B	2021-01-01 00:00:01	2021-01-01 00:00:01
152	1988-1991-SL	303	Ozzie Smith	SS	2021-01-01 00:00:01	2021-01-01 00:00:01
153	1988-1991-SL	305	Barry Larkin	SS	2021-01-01 00:00:01	2021-01-01 00:00:01
154	1988-1991-SL	307	Rafael Ramirez	SS	2021-01-01 00:00:01	2021-01-01 00:00:01
155	1988-1991-SL	309	Spike Owen	SS	2021-01-01 00:00:01	2021-01-01 00:00:01
156	1988-1991-SL	311	Garry Templeton	SS	2021-01-01 00:00:01	2021-01-01 00:00:01
157	1988-1991-SL	313	Kevin Elster	SS	2021-01-01 00:00:01	2021-01-01 00:00:01
158	1988-1991-SL	315	Jeff Blauser	SS/2B/3B	2021-01-01 00:00:01	2021-01-01 00:00:01
159	1988-1991-SL	317	Ernie Riles	SS/2B/3B	2021-01-01 00:00:01	2021-01-01 00:00:01
160	1988-1991-SL	319	Eric Yelding	SS/OF	2021-01-01 00:00:01	2021-01-01 00:00:01
161	1988-1991-SL	321	Rafael Belliard	SS	2021-01-01 00:00:01	2021-01-01 00:00:01
162	1988-1991-SL	323	Dave Anderson	SS	2021-01-01 00:00:01	2021-01-01 00:00:01
163	1988-1991-SL	325	Domingo Ramos	SS/3B	2021-01-01 00:00:01	2021-01-01 00:00:01
164	1988-1991-SL	327	Tim Jones	SS/2B	2021-01-01 00:00:01	2021-01-01 00:00:01
165	1988-1991-SL	329	Rod Booker	SS/2B/3B	2021-01-01 00:00:01	2021-01-01 00:00:01
166	1988-1991-SL	331	Al Pedrique	SS	2021-01-01 00:00:01	2021-01-01 00:00:01
167	1988-1991-SL	333	Jose Offerman	SS	2021-01-01 00:00:01	2021-01-01 00:00:01
168	1988-1991-SL	335	Dale Murphy	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
169	1988-1991-SL	337	Tony Gwynn	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
170	1988-1991-SL	339	Darryl Strawberry	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
171	1988-1991-SL	341	Tim Raines	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
172	1988-1991-SL	343	Andre Dawson	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
173	1988-1991-SL	345	Kevin Mitchell	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
174	1988-1991-SL	347	Vince Coleman	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
175	1988-1991-SL	349	Billy Hatcher	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
176	1988-1991-SL	351	Willie McGee	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
177	1988-1991-SL	353	Von Hayes	OF/1B	2021-01-01 00:00:01	2021-01-01 00:00:01
178	1988-1991-SL	355	Kal Daniels	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
179	1988-1991-SL	357	Kirk Gibson	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
180	1988-1991-SL	359	Lonnie Smith	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
181	1988-1991-SL	361	Mitch Webster	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
182	1988-1991-SL	363	Mike Marshall	OF/1B	2021-01-01 00:00:01	2021-01-01 00:00:01
183	1988-1991-SL	365	Otis Nixon	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
184	1988-1991-SL	367	Carmelo Martinez	OF/1B	2021-01-01 00:00:01	2021-01-01 00:00:01
185	1988-1991-SL	369	Jerome Walton	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
186	1988-1991-SL	371	Dion James	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
187	1988-1991-SL	373	Larry Walker	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
188	1988-1991-SL	375	David Justice	OF/1B	2021-01-01 00:00:01	2021-01-01 00:00:01
189	1988-1991-SL	377	Marquis Grissom	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
190	1988-1991-SL	379	Marvell Wynne	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
191	1988-1991-SL	381	Dwight Smith	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
192	1988-1991-SL	383	Ken Griffey(Sr)	OF/1B	2021-01-01 00:00:01	2021-01-01 00:00:01
193	1988-1991-SL	385	Ray Lankford	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
194	1988-1991-SL	387	Mark Carreon	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
195	1988-1991-SL	389	Mike Kingery	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
196	1988-1991-SL	391	Jose Gonzalez	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
197	1988-1991-SL	393	Mike Davis	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
198	1988-1991-SL	395	Eric Anthony	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
199	1988-1991-SL	397	Gary Varsho	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
200	1988-1991-SL	399	Rolando Roomes	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
201	1988-1991-SL	401	Bob Dernier	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
202	1988-1991-SL	403	Chris Gwynn	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
203	1988-1991-SL	405	Thomas Howard	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
204	1988-1991-SL	407	Darren Lewis	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
205	1988-1991-SL	409	Lee Mazzilli	OF/1B	2021-01-01 00:00:01	2021-01-01 00:00:01
206	1988-1991-SL	411	Donell Nixon	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
207	1988-1991-SL	413	Ron Jones	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
208	1988-1991-SL	415	Karl Rhodes	OF	2021-01-01 00:00:01	2021-01-01 00:00:01
209	1988-1991-SL	417	Greg Gross	OF/1B	2021-01-01 00:00:01	2021-01-01 00:00:01
\.


--
-- Data for Name: auctions; Type: TABLE DATA; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

COPY public.auctions (id, name, year_range, nominations_per_team, seconds_before_autonomination, new_nominations_created, bid_timeout_seconds, active, players_per_team, must_roster_all_players, team_dollars_per_player, started_or_paused_at, inserted_at, updated_at) FROM stdin;
1	Inaugural: 1988-1991-SL	1988-1991-SL	7	3600	time	43200	f	50	f	20	2020-12-06 16:19:00	2020-11-15 23:35:05	2020-12-06 16:19:53
\.


--
-- Data for Name: auctions_users; Type: TABLE DATA; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

COPY public.auctions_users (id, auction_id, user_id) FROM stdin;
1	1	1
\.


--
-- Data for Name: bids; Type: TABLE DATA; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

COPY public.bids (id, bid_amount, hidden_high_bid, expires_at, nominated_by, team_id, auction_id, closed, inserted_at, updated_at) FROM stdin;
\.


--
-- Data for Name: ordered_players; Type: TABLE DATA; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

COPY public.ordered_players (id, rank, player_id, team_id, auction_id, inserted_at, updated_at) FROM stdin;
372	1	68	2	\N	2021-01-01 00:00:01	2021-01-01 00:00:01
93	93	29	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
120	120	40	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
129	129	43	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
135	135	197	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
139	139	198	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
140	140	46	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
146	146	199	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
150	150	137	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
152	152	201	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
153	153	50	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
157	157	203	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
161	161	54	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
168	168	56	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
171	171	57	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
178	178	58	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
185	185	124	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
191	191	209	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
193	193	62	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
195	195	139	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
197	197	166	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
204	204	66	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
206	206	68	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
208	208	69	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
\.


--
-- Data for Name: players; Type: TABLE DATA; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

COPY public.players (id, year_range, ssnum, name, "position", bid_id, rostered_player_id, auction_id, inserted_at, updated_at) FROM stdin;
29	1988-1991-SL	57	Jimmy Jones	SP	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
40	1988-1991-SL	79	Derek Lilliquist	SP	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
43	1988-1991-SL	85	Scott Scudder	SP	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
46	1988-1991-SL	91	Ricky Horton	SP	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
50	1988-1991-SL	99	Danny Cox	SP	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
54	1988-1991-SL	107	Brian Fisher	SP	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
56	1988-1991-SL	111	Xavier Hernandez	SP	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
57	1988-1991-SL	113	David Palmer	SP	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
58	1988-1991-SL	115	Randy O'Neal	SP	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
62	1988-1991-SL	123	Frank Castillo	SP	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
66	1988-1991-SL	131	Mario Soto	SP	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
68	1988-1991-SL	135	Chris Haney	SP	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
69	1988-1991-SL	137	Bob Sebra	SP	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
25	1988-1991-SL	49	Ken Hill	SP	\N	13	1	2021-01-01 00:00:01	2021-01-01 00:00:01
13	1988-1991-SL	25	Rick Mahler	SP	\N	6	1	2021-01-01 00:00:01	2021-01-01 00:00:01
18	1988-1991-SL	35	Rick Sutcliffe	SP	\N	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
1	1988-1991-SL	1	Frank Viola	SP	\N	10	1	2021-01-01 00:00:01	2021-01-01 00:00:01
21	1988-1991-SL	41	Bruce Ruffin	SP	\N	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
28	1988-1991-SL	55	Norm Charlton	SP	\N	36	1	2021-01-01 00:00:01	2021-01-01 00:00:01
84	1988-1991-SL	167	Stan Belinda	RP	\N	9	1	2021-01-01 00:00:01	2021-01-01 00:00:01
85	1988-1991-SL	169	Rich Gossage	RP	\N	8	1	2021-01-01 00:00:01	2021-01-01 00:00:01
86	1988-1991-SL	171	Todd Worrell	RP	\N	7	1	2021-01-01 00:00:01	2021-01-01 00:00:01
72	1988-1991-SL	143	Rob Dibble	RP	\N	33	1	2021-01-01 00:00:01	2021-01-01 00:00:01
36	1988-1991-SL	71	Ron Robinson	SP	\N	26	1	2021-01-01 00:00:01	2021-01-01 00:00:01
6	1988-1991-SL	11	Dwight Gooden	SP	\N	24	1	2021-01-01 00:00:01	2021-01-01 00:00:01
20	1988-1991-SL	39	Danny Darwin	SP	\N	35	1	2021-01-01 00:00:01	2021-01-01 00:00:01
23	1988-1991-SL	45	Scott Garrelts	SP	\N	34	1	2021-01-01 00:00:01	2021-01-01 00:00:01
31	1988-1991-SL	61	Greg Harris(SD)	SP	\N	38	1	2021-01-01 00:00:01	2021-01-01 00:00:01
75	1988-1991-SL	149	Larry Andersen	RP	\N	41	1	2021-01-01 00:00:01	2021-01-01 00:00:01
4	1988-1991-SL	7	David Cone	SP	\N	32	1	2021-01-01 00:00:01	2021-01-01 00:00:01
9	1988-1991-SL	17	Ed Whitson	SP	\N	53	1	2021-01-01 00:00:01	2021-01-01 00:00:01
70	1988-1991-SL	139	Paul Assenmacher	RP	\N	51	1	2021-01-01 00:00:01	2021-01-01 00:00:01
76	1988-1991-SL	151	Jeff Brantley	RP	\N	46	1	2021-01-01 00:00:01	2021-01-01 00:00:01
45	1988-1991-SL	89	Steve Wilson	SP	\N	44	1	2021-01-01 00:00:01	2021-01-01 00:00:01
48	1988-1991-SL	95	Omar Olivares	SP	\N	42	1	2021-01-01 00:00:01	2021-01-01 00:00:01
33	1988-1991-SL	65	Randy Myers	SP	\N	69	1	2021-01-01 00:00:01	2021-01-01 00:00:01
74	1988-1991-SL	147	Tim Crews	RP	\N	49	1	2021-01-01 00:00:01	2021-01-01 00:00:01
81	1988-1991-SL	161	Ken Dayley	RP	\N	50	1	2021-01-01 00:00:01	2021-01-01 00:00:01
26	1988-1991-SL	51	Neal Heaton	SP	\N	54	1	2021-01-01 00:00:01	2021-01-01 00:00:01
64	1988-1991-SL	127	Jose Nunez	SP	\N	60	1	2021-01-01 00:00:01	2021-01-01 00:00:01
10	1988-1991-SL	19	Zane Smith	SP	\N	56	1	2021-01-01 00:00:01	2021-01-01 00:00:01
12	1988-1991-SL	23	Jose Rijo	SP	\N	57	1	2021-01-01 00:00:01	2021-01-01 00:00:01
15	1988-1991-SL	29	Don Robinson	SP	\N	104	1	2021-01-01 00:00:01	2021-01-01 00:00:01
96	1988-1991-SL	191	Benito Santiago	C	\N	87	1	2021-01-01 00:00:01	2021-01-01 00:00:01
90	1988-1991-SL	179	Kent Mercker	RP	\N	66	1	2021-01-01 00:00:01	2021-01-01 00:00:01
16	1988-1991-SL	31	Joe Magrane	SP	\N	70	1	2021-01-01 00:00:01	2021-01-01 00:00:01
44	1988-1991-SL	87	Mike Maddux	SP	\N	83	1	2021-01-01 00:00:01	2021-01-01 00:00:01
14	1988-1991-SL	27	Mike Scott	SP	\N	72	1	2021-01-01 00:00:01	2021-01-01 00:00:01
2	1988-1991-SL	3	Tom Browning	SP	\N	84	1	2021-01-01 00:00:01	2021-01-01 00:00:01
97	1988-1991-SL	193	Mike Scioscia	C	\N	106	1	2021-01-01 00:00:01	2021-01-01 00:00:01
55	1988-1991-SL	109	Darryl Kile	SP	\N	81	1	2021-01-01 00:00:01	2021-01-01 00:00:01
77	1988-1991-SL	153	Joe Boever	RP	\N	89	1	2021-01-01 00:00:01	2021-01-01 00:00:01
79	1988-1991-SL	157	Frank DiPino	RP	\N	88	1	2021-01-01 00:00:01	2021-01-01 00:00:01
24	1988-1991-SL	47	Pascual Perez	SP	\N	95	1	2021-01-01 00:00:01	2021-01-01 00:00:01
17	1988-1991-SL	33	Ramon Martinez	SP	\N	112	1	2021-01-01 00:00:01	2021-01-01 00:00:01
71	1988-1991-SL	141	Craig Lefferts	RP	\N	82	1	2021-01-01 00:00:01	2021-01-01 00:00:01
82	1988-1991-SL	163	John Costello	RP	\N	117	1	2021-01-01 00:00:01	2021-01-01 00:00:01
19	1988-1991-SL	37	OilCan Boyd	SP	\N	102	1	2021-01-01 00:00:01	2021-01-01 00:00:01
30	1988-1991-SL	59	Jeff Robinson(Pit)	SP	\N	101	1	2021-01-01 00:00:01	2021-01-01 00:00:01
11	1988-1991-SL	21	Kevin Gross	SP	\N	103	1	2021-01-01 00:00:01	2021-01-01 00:00:01
22	1988-1991-SL	43	Jim Clancy	SP	\N	105	1	2021-01-01 00:00:01	2021-01-01 00:00:01
27	1988-1991-SL	53	Kelly Downs	SP	\N	100	1	2021-01-01 00:00:01	2021-01-01 00:00:01
94	1988-1991-SL	187	Dave Leiper	RP	\N	114	1	2021-01-01 00:00:01	2021-01-01 00:00:01
95	1988-1991-SL	189	Wally Ritchie	RP	\N	115	1	2021-01-01 00:00:01	2021-01-01 00:00:01
32	1988-1991-SL	63	Bob Knepper	SP	\N	123	1	2021-01-01 00:00:01	2021-01-01 00:00:01
80	1988-1991-SL	159	Jim Gott	RP	\N	121	1	2021-01-01 00:00:01	2021-01-01 00:00:01
73	1988-1991-SL	145	Jeff Parrett	RP	\N	122	1	2021-01-01 00:00:01	2021-01-01 00:00:01
38	1988-1991-SL	75	Jose DeJesus	SP	\N	132	1	2021-01-01 00:00:01	2021-01-01 00:00:01
51	1988-1991-SL	101	Bob Patterson	SP	\N	124	1	2021-01-01 00:00:01	2021-01-01 00:00:01
91	1988-1991-SL	181	Doug Bair	RP	\N	146	1	2021-01-01 00:00:01	2021-01-01 00:00:01
49	1988-1991-SL	97	Marty Clary	SP	\N	171	1	2021-01-01 00:00:01	2021-01-01 00:00:01
52	1988-1991-SL	103	Bill Sampen	SP	\N	137	1	2021-01-01 00:00:01	2021-01-01 00:00:01
35	1988-1991-SL	69	Mark Gardner	SP	\N	136	1	2021-01-01 00:00:01	2021-01-01 00:00:01
59	1988-1991-SL	117	Jason Grimsley	SP	\N	131	1	2021-01-01 00:00:01	2021-01-01 00:00:01
37	1988-1991-SL	73	Ken Howell	SP	\N	148	1	2021-01-01 00:00:01	2021-01-01 00:00:01
39	1988-1991-SL	77	Atlee Hammaker	SP	\N	133	1	2021-01-01 00:00:01	2021-01-01 00:00:01
53	1988-1991-SL	105	Mike Krukow	SP	\N	143	1	2021-01-01 00:00:01	2021-01-01 00:00:01
47	1988-1991-SL	93	Shawn Boskie	SP	\N	169	1	2021-01-01 00:00:01	2021-01-01 00:00:01
65	1988-1991-SL	129	Greg Booker	SP	\N	145	1	2021-01-01 00:00:01	2021-01-01 00:00:01
83	1988-1991-SL	165	Jose Alvarez	RP	\N	147	1	2021-01-01 00:00:01	2021-01-01 00:00:01
63	1988-1991-SL	125	Bob Scanlan	SP	\N	170	1	2021-01-01 00:00:01	2021-01-01 00:00:01
93	1988-1991-SL	185	Al Osuna	RP	\N	155	1	2021-01-01 00:00:01	2021-01-01 00:00:01
41	1988-1991-SL	81	Jeff Pico	SP	\N	173	1	2021-01-01 00:00:01	2021-01-01 00:00:01
61	1988-1991-SL	121	Rick Reed	SP	\N	178	1	2021-01-01 00:00:01	2021-01-01 00:00:01
124	1988-1991-SL	247	Phil Stephenson	1B	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
166	1988-1991-SL	331	Al Pedrique	SS	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
198	1988-1991-SL	395	Eric Anthony	OF	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
174	1988-1991-SL	347	Vince Coleman	OF	\N	30	1	2021-01-01 00:00:01	2021-01-01 00:00:01
112	1988-1991-SL	223	Alan Ashby	C	\N	134	1	2021-01-01 00:00:01	2021-01-01 00:00:01
188	1988-1991-SL	375	David Justice	OF/1B	\N	71	1	2021-01-01 00:00:01	2021-01-01 00:00:01
170	1988-1991-SL	339	Darryl Strawberry	OF	\N	31	1	2021-01-01 00:00:01	2021-01-01 00:00:01
164	1988-1991-SL	327	Tim Jones	SS/2B	\N	110	1	2021-01-01 00:00:01	2021-01-01 00:00:01
168	1988-1991-SL	335	Dale Murphy	OF	\N	16	1	2021-01-01 00:00:01	2021-01-01 00:00:01
196	1988-1991-SL	391	Jose Gonzalez	OF	\N	180	1	2021-01-01 00:00:01	2021-01-01 00:00:01
152	1988-1991-SL	303	Ozzie Smith	SS	\N	17	1	2021-01-01 00:00:01	2021-01-01 00:00:01
118	1988-1991-SL	235	Dave Magadan	1B	\N	76	1	2021-01-01 00:00:01	2021-01-01 00:00:01
142	1988-1991-SL	283	Chris Sabo	3B	\N	40	1	2021-01-01 00:00:01	2021-01-01 00:00:01
144	1988-1991-SL	287	Charlie Hayes	3B	\N	111	1	2021-01-01 00:00:01	2021-01-01 00:00:01
140	1988-1991-SL	279	Bobby Bonilla	3B/OF	\N	18	1	2021-01-01 00:00:01	2021-01-01 00:00:01
130	1988-1991-SL	259	Gregg Jefferies	2B/3B	\N	45	1	2021-01-01 00:00:01	2021-01-01 00:00:01
128	1988-1991-SL	255	Ron Gant	2B/OF	\N	19	1	2021-01-01 00:00:01	2021-01-01 00:00:01
98	1988-1991-SL	195	Mike LaValliere	C	\N	79	1	2021-01-01 00:00:01	2021-01-01 00:00:01
126	1988-1991-SL	251	Roberto Alomar	2B	\N	47	1	2021-01-01 00:00:01	2021-01-01 00:00:01
116	1988-1991-SL	231	Andres Galarraga	1B	\N	22	1	2021-01-01 00:00:01	2021-01-01 00:00:01
156	1988-1991-SL	311	Garry Templeton	SS	\N	23	1	2021-01-01 00:00:01	2021-01-01 00:00:01
180	1988-1991-SL	359	Lonnie Smith	OF	\N	80	1	2021-01-01 00:00:01	2021-01-01 00:00:01
160	1988-1991-SL	319	Eric Yelding	SS/OF	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
158	1988-1991-SL	315	Jeff Blauser	SS/2B/3B	\N	25	1	2021-01-01 00:00:01	2021-01-01 00:00:01
154	1988-1991-SL	307	Rafael Ramirez	SS	\N	85	1	2021-01-01 00:00:01	2021-01-01 00:00:01
104	1988-1991-SL	207	Lloyd McClendon	C/1B/OF	\N	27	1	2021-01-01 00:00:01	2021-01-01 00:00:01
182	1988-1991-SL	363	Mike Marshall	OF/1B	\N	113	1	2021-01-01 00:00:01	2021-01-01 00:00:01
146	1988-1991-SL	291	Ken Oberkfell	3B	\N	55	1	2021-01-01 00:00:01	2021-01-01 00:00:01
208	1988-1991-SL	415	Karl Rhodes	OF	\N	182	1	2021-01-01 00:00:01	2021-01-01 00:00:01
206	1988-1991-SL	411	Donell Nixon	OF	\N	58	1	2021-01-01 00:00:01	2021-01-01 00:00:01
122	1988-1991-SL	243	Jeff Bagwell	1B	\N	116	1	2021-01-01 00:00:01	2021-01-01 00:00:01
172	1988-1991-SL	343	Andre Dawson	OF	\N	59	1	2021-01-01 00:00:01	2021-01-01 00:00:01
134	1988-1991-SL	267	Rex Hudler	2B/SS/OF	\N	92	1	2021-01-01 00:00:01	2021-01-01 00:00:01
176	1988-1991-SL	351	Willie McGee	OF	\N	61	1	2021-01-01 00:00:01	2021-01-01 00:00:01
108	1988-1991-SL	215	Bo Diaz	C	\N	162	1	2021-01-01 00:00:01	2021-01-01 00:00:01
148	1988-1991-SL	295	Mickey Hatcher	3B/1B/OF	\N	138	1	2021-01-01 00:00:01	2021-01-01 00:00:01
120	1988-1991-SL	239	Franklin Stubbs	1B/OF	\N	94	1	2021-01-01 00:00:01	2021-01-01 00:00:01
150	1988-1991-SL	299	Tim Flannery	3B	\N	139	1	2021-01-01 00:00:01	2021-01-01 00:00:01
178	1988-1991-SL	355	Kal Daniels	OF	\N	99	1	2021-01-01 00:00:01	2021-01-01 00:00:01
114	1988-1991-SL	227	Gilberto Reyes	C	\N	163	1	2021-01-01 00:00:01	2021-01-01 00:00:01
110	1988-1991-SL	219	John Russell(of)	C	\N	142	1	2021-01-01 00:00:01	2021-01-01 00:00:01
200	1988-1991-SL	399	Rolando Roomes	OF	\N	183	1	2021-01-01 00:00:01	2021-01-01 00:00:01
132	1988-1991-SL	263	Delino DeShields	2B	\N	119	1	2021-01-01 00:00:01	2021-01-01 00:00:01
102	1988-1991-SL	203	Damon Berryhill	C	\N	165	1	2021-01-01 00:00:01	2021-01-01 00:00:01
138	1988-1991-SL	275	Damaso Garcia	2B	\N	126	1	2021-01-01 00:00:01	2021-01-01 00:00:01
136	1988-1991-SL	271	Greg Litton	2B/3B/OF	\N	127	1	2021-01-01 00:00:01	2021-01-01 00:00:01
106	1988-1991-SL	211	Jody Davis	C	\N	151	1	2021-01-01 00:00:01	2021-01-01 00:00:01
162	1988-1991-SL	323	Dave Anderson	SS	\N	129	1	2021-01-01 00:00:01	2021-01-01 00:00:01
184	1988-1991-SL	367	Carmelo Martinez	OF/1B	\N	166	1	2021-01-01 00:00:01	2021-01-01 00:00:01
204	1988-1991-SL	407	Darren Lewis	OF	\N	184	1	2021-01-01 00:00:01	2021-01-01 00:00:01
192	1988-1991-SL	383	Ken Griffey(Sr)	OF/1B	\N	153	1	2021-01-01 00:00:01	2021-01-01 00:00:01
186	1988-1991-SL	371	Dion James	OF	\N	168	1	2021-01-01 00:00:01	2021-01-01 00:00:01
100	1988-1991-SL	199	Jeff Reed	C	\N	154	1	2021-01-01 00:00:01	2021-01-01 00:00:01
194	1988-1991-SL	387	Mark Carreon	OF	\N	158	1	2021-01-01 00:00:01	2021-01-01 00:00:01
190	1988-1991-SL	379	Marvell Wynne	OF	\N	174	1	2021-01-01 00:00:01	2021-01-01 00:00:01
202	1988-1991-SL	403	Chris Gwynn	OF	\N	176	1	2021-01-01 00:00:01	2021-01-01 00:00:01
137	1988-1991-SL	273	Luis Alicea	2B	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
139	1988-1991-SL	277	Dave Concepcion	2B	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
197	1988-1991-SL	393	Mike Davis	OF	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
199	1988-1991-SL	397	Gary Varsho	OF	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
201	1988-1991-SL	401	Bob Dernier	OF	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
203	1988-1991-SL	405	Thomas Howard	OF	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
209	1988-1991-SL	417	Greg Gross	OF/1B	\N	\N	1	2021-01-01 00:00:01	2021-01-01 00:00:01
117	1988-1991-SL	233	Todd Benzinger	1B	\N	74	1	2021-01-01 00:00:01	2021-01-01 00:00:01
171	1988-1991-SL	341	Tim Raines	OF	\N	62	1	2021-01-01 00:00:01	2021-01-01 00:00:01
67	1988-1991-SL	133	Kip Gross	SP	\N	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
87	1988-1991-SL	173	Scott Ruskin	RP	\N	75	1	2021-01-01 00:00:01	2021-01-01 00:00:01
88	1988-1991-SL	175	Kent Tekulve	RP	\N	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
157	1988-1991-SL	313	Kevin Elster	SS	\N	28	1	2021-01-01 00:00:01	2021-01-01 00:00:01
119	1988-1991-SL	237	Ricky Jordan	1B	\N	5	1	2021-01-01 00:00:01	2021-01-01 00:00:01
169	1988-1991-SL	337	Tony Gwynn	OF	\N	63	1	2021-01-01 00:00:01	2021-01-01 00:00:01
159	1988-1991-SL	317	Ernie Riles	SS/2B/3B	\N	29	1	2021-01-01 00:00:01	2021-01-01 00:00:01
115	1988-1991-SL	229	Will Clark	1B	\N	11	1	2021-01-01 00:00:01	2021-01-01 00:00:01
141	1988-1991-SL	281	Howard Johnson	3B/SS	\N	37	1	2021-01-01 00:00:01	2021-01-01 00:00:01
187	1988-1991-SL	373	Larry Walker	OF	\N	12	1	2021-01-01 00:00:01	2021-01-01 00:00:01
8	1988-1991-SL	15	Tim Leary	SP	\N	93	1	2021-01-01 00:00:01	2021-01-01 00:00:01
7	1988-1991-SL	13	Tim Belcher	SP	\N	14	1	2021-01-01 00:00:01	2021-01-01 00:00:01
131	1988-1991-SL	261	Bip Roberts	2B/3B/OF	\N	15	1	2021-01-01 00:00:01	2021-01-01 00:00:01
165	1988-1991-SL	329	Rod Booker	SS/2B/3B	\N	128	1	2021-01-01 00:00:01	2021-01-01 00:00:01
175	1988-1991-SL	349	Billy Hatcher	OF	\N	64	1	2021-01-01 00:00:01	2021-01-01 00:00:01
3	1988-1991-SL	5	Dennis Martinez	SP	\N	20	1	2021-01-01 00:00:01	2021-01-01 00:00:01
105	1988-1991-SL	209	Rick Dempsey	C	\N	96	1	2021-01-01 00:00:01	2021-01-01 00:00:01
153	1988-1991-SL	305	Barry Larkin	SS	\N	21	1	2021-01-01 00:00:01	2021-01-01 00:00:01
145	1988-1991-SL	289	Vance Law	3B	\N	39	1	2021-01-01 00:00:01	2021-01-01 00:00:01
179	1988-1991-SL	357	Kirk Gibson	OF	\N	77	1	2021-01-01 00:00:01	2021-01-01 00:00:01
193	1988-1991-SL	385	Ray Lankford	OF	\N	157	1	2021-01-01 00:00:01	2021-01-01 00:00:01
89	1988-1991-SL	177	Rich Rodriguez	RP	\N	65	1	2021-01-01 00:00:01	2021-01-01 00:00:01
5	1988-1991-SL	9	Jose DeLeon	SP	\N	43	1	2021-01-01 00:00:01	2021-01-01 00:00:01
177	1988-1991-SL	353	Von Hayes	OF/1B	\N	78	1	2021-01-01 00:00:01	2021-01-01 00:00:01
143	1988-1991-SL	285	Matt Williams	3B	\N	48	1	2021-01-01 00:00:01	2021-01-01 00:00:01
34	1988-1991-SL	67	Bob Tewksbury	SP	\N	67	1	2021-01-01 00:00:01	2021-01-01 00:00:01
173	1988-1991-SL	345	Kevin Mitchell	OF	\N	52	1	2021-01-01 00:00:01	2021-01-01 00:00:01
191	1988-1991-SL	381	Dwight Smith	OF	\N	97	1	2021-01-01 00:00:01	2021-01-01 00:00:01
103	1988-1991-SL	205	Mackey Sasser	C	\N	86	1	2021-01-01 00:00:01	2021-01-01 00:00:01
127	1988-1991-SL	253	Jose Lind	2B	\N	68	1	2021-01-01 00:00:01	2021-01-01 00:00:01
163	1988-1991-SL	325	Domingo Ramos	SS/3B	\N	109	1	2021-01-01 00:00:01	2021-01-01 00:00:01
205	1988-1991-SL	409	Lee Mazzilli	OF/1B	\N	161	1	2021-01-01 00:00:01	2021-01-01 00:00:01
185	1988-1991-SL	369	Jerome Walton	OF	\N	159	1	2021-01-01 00:00:01	2021-01-01 00:00:01
129	1988-1991-SL	257	Bill Doran	2B	\N	73	1	2021-01-01 00:00:01	2021-01-01 00:00:01
147	1988-1991-SL	293	Mike Sharperson	3B	\N	98	1	2021-01-01 00:00:01	2021-01-01 00:00:01
78	1988-1991-SL	155	Bob Kipper	RP	\N	130	1	2021-01-01 00:00:01	2021-01-01 00:00:01
111	1988-1991-SL	221	Ozzie Virgil	C	\N	149	1	2021-01-01 00:00:01	2021-01-01 00:00:01
133	1988-1991-SL	265	Tim Teufel	2B/1B/3B	\N	90	1	2021-01-01 00:00:01	2021-01-01 00:00:01
42	1988-1991-SL	83	Pat Combs	SP	\N	135	1	2021-01-01 00:00:01	2021-01-01 00:00:01
155	1988-1991-SL	309	Spike Owen	SS	\N	91	1	2021-01-01 00:00:01	2021-01-01 00:00:01
181	1988-1991-SL	361	Mitch Webster	OF	\N	118	1	2021-01-01 00:00:01	2021-01-01 00:00:01
207	1988-1991-SL	413	Ron Jones	OF	\N	107	1	2021-01-01 00:00:01	2021-01-01 00:00:01
109	1988-1991-SL	217	Bruce Benedict	C	\N	164	1	2021-01-01 00:00:01	2021-01-01 00:00:01
183	1988-1991-SL	365	Otis Nixon	OF	\N	108	1	2021-01-01 00:00:01	2021-01-01 00:00:01
101	1988-1991-SL	201	Tom Pagnozzi	C	\N	140	1	2021-01-01 00:00:01	2021-01-01 00:00:01
151	1988-1991-SL	301	Dave Hollins	3B	\N	120	1	2021-01-01 00:00:01	2021-01-01 00:00:01
189	1988-1991-SL	377	Marquis Grissom	OF	\N	160	1	2021-01-01 00:00:01	2021-01-01 00:00:01
135	1988-1991-SL	269	Mark Lemke	2B/3B	\N	125	1	2021-01-01 00:00:01	2021-01-01 00:00:01
113	1988-1991-SL	225	Francisco Cabrera	C/1B	\N	150	1	2021-01-01 00:00:01	2021-01-01 00:00:01
99	1988-1991-SL	197	Gary Carter	C	\N	141	1	2021-01-01 00:00:01	2021-01-01 00:00:01
60	1988-1991-SL	119	Floyd Youmans	SP	\N	144	1	2021-01-01 00:00:01	2021-01-01 00:00:01
123	1988-1991-SL	245	Brian Hunter	1B	\N	179	1	2021-01-01 00:00:01	2021-01-01 00:00:01
125	1988-1991-SL	249	Benny Distefano	1B	\N	167	1	2021-01-01 00:00:01	2021-01-01 00:00:01
107	1988-1991-SL	213	Mark Parent	C	\N	152	1	2021-01-01 00:00:01	2021-01-01 00:00:01
92	1988-1991-SL	183	Tim Layana	RP	\N	156	1	2021-01-01 00:00:01	2021-01-01 00:00:01
167	1988-1991-SL	333	Jose Offerman	SS	\N	175	1	2021-01-01 00:00:01	2021-01-01 00:00:01
195	1988-1991-SL	389	Mike Kingery	OF	\N	181	1	2021-01-01 00:00:01	2021-01-01 00:00:01
161	1988-1991-SL	321	Rafael Belliard	SS	\N	177	1	2021-01-01 00:00:01	2021-01-01 00:00:01
121	1988-1991-SL	241	Keith Hernandez	1B	\N	172	1	2021-01-01 00:00:01	2021-01-01 00:00:01
149	1988-1991-SL	297	Chico Walker	3B/OF	\N	185	1	2021-01-01 00:00:01	2021-01-01 00:00:01
\.


--
-- Data for Name: rostered_players; Type: TABLE DATA; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

COPY public.rostered_players (id, cost, team_id, auction_id, inserted_at, updated_at) FROM stdin;
1	2	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
2	5	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
3	3	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
4	2	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
5	10	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
6	7	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
7	8	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
8	5	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
9	5	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
10	63	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
11	112	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
12	15	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
13	7	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
14	76	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
15	39	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
16	32	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
17	105	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
18	110	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
19	80	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
20	112	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
21	112	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
22	36	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
23	2	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
24	40	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
25	11	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
26	11	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
27	24	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
28	8	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
29	8	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
30	18	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
31	101	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
32	83	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
33	61	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
34	30	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
35	48	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
36	39	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
37	95	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
38	76	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
39	5	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
40	55	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
41	54	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
42	10	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
43	42	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
44	3	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
45	21	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
46	39	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
47	75	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
48	47	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
49	19	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
50	12	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
51	23	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
52	92	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
53	60	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
54	16	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
55	1	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
56	54	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
57	97	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
58	2	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
59	65	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
60	4	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
61	39	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
62	52	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
63	78	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
64	3	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
65	11	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
66	15	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
67	21	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
68	10	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
69	58	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
70	51	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
71	38	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
72	35	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
73	24	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
74	4	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
75	9	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
76	47	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
77	35	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
78	40	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
79	26	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
80	54	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
81	3	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
82	24	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
83	19	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
84	15	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
85	1	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
86	19	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
87	24	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
88	10	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
89	12	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
90	13	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
91	13	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
92	7	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
93	12	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
94	14	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
95	45	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
96	12	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
97	8	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
98	9	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
99	79	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
100	5	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
101	10	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
102	11	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
103	3	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
104	28	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
105	3	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
106	34	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
107	9	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
108	5	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
109	5	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
110	5	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
111	3	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
112	52	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
113	9	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
114	12	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
115	13	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
116	24	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
117	23	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
118	8	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
119	8	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
120	9	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
121	20	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
122	8	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
123	11	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
124	4	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
125	5	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
126	1	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
127	1	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
128	2	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
129	14	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
130	4	3	1	2021-01-01 00:00:01	2021-01-01 00:00:01
131	1	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
132	5	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
133	1	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
134	5	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
135	3	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
136	3	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
137	5	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
138	1	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
142	1	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
143	1	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
145	1	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
147	8	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
149	4	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
150	1	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
153	10	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
154	14	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
157	1	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
159	10	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
160	5	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
161	1	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
139	1	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
140	8	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
141	10	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
144	1	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
146	8	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
148	5	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
151	1	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
152	1	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
155	1	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
156	1	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
158	8	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
162	1	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
163	1	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
164	2	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
165	17	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
166	2	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
167	2	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
168	1	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
169	1	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
170	1	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
171	17	4	1	2021-01-01 00:00:01	2021-01-01 00:00:01
172	6	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
173	1	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
174	1	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
175	1	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
176	1	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
177	2	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
178	1	1	1	2021-01-01 00:00:01	2021-01-01 00:00:01
179	1	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
180	1	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
181	1	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
182	1	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
183	1	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
184	1	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
185	1	2	1	2021-01-01 00:00:01	2021-01-01 00:00:01
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

COPY public.schema_migrations (version, inserted_at) FROM stdin;
20190901163909	2020-11-15 23:34:28
20190901174613	2020-11-15 23:34:28
20190901180401	2020-11-15 23:34:28
20190901202304	2020-11-15 23:34:28
20190901202719	2020-11-15 23:34:28
20190902030142	2020-11-15 23:34:28
20190907181155	2020-11-15 23:34:28
20190907181349	2020-11-15 23:34:28
20190922183400	2020-11-15 23:34:28
20191006200151	2020-11-15 23:34:28
20191013044545	2020-11-15 23:34:28
20191013050920	2020-11-15 23:34:28
20191111172509	2020-11-15 23:34:28
20200518024714	2020-11-15 23:34:28
20210102220119	2021-01-03 17:22:33
20210103054210	2021-01-03 17:22:33
20210103054451	2021-01-03 17:22:33
20210103054612	2021-01-03 17:22:33
20210103054727	2021-01-03 17:22:33
20210103054849	2021-01-03 17:22:33
\.


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

COPY public.teams (id, name, unused_nominations, time_nominations_expire, new_nominations_open_at, auction_id, inserted_at, updated_at) FROM stdin;
4	Team Harry/George/John	0	\N	2020-12-04 21:00:00	1	2021-01-01 00:00:01	2021-01-01 00:00:01
1	Team Daryl	0	2020-12-05 17:45:00	2020-12-06 16:45:00	1	2021-01-01 00:00:01	2021-01-01 00:00:01
2	Team Tom & Jerry	0	2020-12-06 13:00:00	2020-12-07 12:00:00	1	2021-01-01 00:00:01	2021-01-01 00:00:01
3	Hot Ice (Joe)	0	\N	2020-12-07 14:30:00	1	2021-01-01 00:00:01	2021-01-01 00:00:01
\.


--
-- Data for Name: teams_users; Type: TABLE DATA; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

COPY public.teams_users (id, team_id, user_id) FROM stdin;
1	1	1
2	2	2
3	2	3
4	3	4
5	4	6
6	4	7
7	4	5
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

COPY public.users (id, username, email, super, password_hash, inserted_at, updated_at, slack_display_name) FROM stdin;
1	daryl	daryl.spitzer@gmail.com	t	$pbkdf2-sha512$160000$XxfT.6DMieOZyPxR5pdIxw$ZDIAuehghJswlDSOP5W.uEwhdOAFqDe35gRMq6blOiRMtxkjxhXWsSsdafMv77QOuLLllYwuO46lMC71kGxszg	2020-11-15 23:35:06	2020-11-15 23:35:06	@daryl
2	tom	han60man@aol.com	f	$pbkdf2-sha512$160000$Lpb/pioDbfusbSOOU0KV8g$LjLXCld7V8um3XO0qNjR/ZPweOwRr9.DicXNQ34tGP/1wWjXngl2M5S3pNqSbGvfsK3h0BWHqzvn36AqQ27kiA	2020-11-15 23:35:06	2020-11-15 23:35:06	@han60man
3	jerry	gvelli@comcast.net	f	$pbkdf2-sha512$160000$ruS3YZ7gtEilTajEjzo5Sg$Ln7SmmxWuXlTXDbS5Lw9M6.iyedzJTUHTOb0uPgnGkWWMv5psebWrZXKSacJ.22eTbrmgxWFDFyXUvUmFkbG/g	2020-11-15 23:35:06	2020-11-15 23:35:06	@Jerry V
4	joe	joe@manycycles.com	f	$pbkdf2-sha512$160000$RvEYsC3v4BlZKjeVnlmoqQ$D1jc6sSu.UaMrmtRUUm19gm3uGzFW/1KQVpunBqRlZxfjAq7eYigWzSkh7Uzkefeyyu5lKWTGurAqIr/uDvVtg	2020-11-15 23:35:07	2020-11-15 23:35:07	@Joe Golton
5	john	johndjones44@yahoo.com	f	$pbkdf2-sha512$160000$mNBo7Re6UoKvuGDlYtNawg$R9GKG.0vAaRIeoQ/qymbpHO0DK3kkSPIm6sZicDQVV5QV4muaMPqK8PAOtmy84eYX6H9wgQ9ggLioMV7a0/sgQ	2020-11-15 23:35:07	2020-11-15 23:35:07	@johndjones44
6	harry	haguilera1021@gmail.com	f	$pbkdf2-sha512$160000$Hm/S8siPsXMjPX5W6WDwnA$HscQxQIkd7fXSvJzqiqWH1CZldekc8Vd2LHb3JY6hdY.qI8fQj/apgvONc8FeAoEy1/g0t/7m2RtzYMT4nwYNg	2020-11-15 23:35:08	2020-11-15 23:35:08	@Harry
7	george	gejoycejr@gmail.com	f	$pbkdf2-sha512$160000$L4JkzzxJutn8CU24H8rDiw$tOa4/SMGXAz2DWFqYswbCxx3vXJHtofGS2rIePFcYv7ZzDyjMg/f.arlzDTzRyffeyJnb92S3tp7AuDIwRpn3g	2020-11-15 23:35:08	2020-11-15 23:35:08	@George E Joyce Jr
\.


--
-- Name: all_players_id_seq; Type: SEQUENCE SET; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

SELECT pg_catalog.setval('public.all_players_id_seq', 209, true);


--
-- Name: auctions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

SELECT pg_catalog.setval('public.auctions_id_seq', 1, true);


--
-- Name: auctions_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

SELECT pg_catalog.setval('public.auctions_users_id_seq', 1, true);


--
-- Name: bids_id_seq; Type: SEQUENCE SET; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

SELECT pg_catalog.setval('public.bids_id_seq', 186, true);


--
-- Name: ordered_players_id_seq; Type: SEQUENCE SET; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

SELECT pg_catalog.setval('public.ordered_players_id_seq', 388, true);


--
-- Name: players_id_seq; Type: SEQUENCE SET; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

SELECT pg_catalog.setval('public.players_id_seq', 209, true);


--
-- Name: rostered_players_id_seq; Type: SEQUENCE SET; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

SELECT pg_catalog.setval('public.rostered_players_id_seq', 185, true);


--
-- Name: teams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

SELECT pg_catalog.setval('public.teams_id_seq', 4, true);


--
-- Name: teams_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

SELECT pg_catalog.setval('public.teams_users_id_seq', 7, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

SELECT pg_catalog.setval('public.users_id_seq', 7, true);


--
-- Name: all_players all_players_pkey; Type: CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.all_players
    ADD CONSTRAINT all_players_pkey PRIMARY KEY (id);


--
-- Name: auctions auctions_pkey; Type: CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.auctions
    ADD CONSTRAINT auctions_pkey PRIMARY KEY (id);


--
-- Name: auctions_users auctions_users_pkey; Type: CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.auctions_users
    ADD CONSTRAINT auctions_users_pkey PRIMARY KEY (id);


--
-- Name: bids bids_pkey; Type: CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.bids
    ADD CONSTRAINT bids_pkey PRIMARY KEY (id);


--
-- Name: ordered_players ordered_players_pkey; Type: CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.ordered_players
    ADD CONSTRAINT ordered_players_pkey PRIMARY KEY (id);


--
-- Name: players players_pkey; Type: CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_pkey PRIMARY KEY (id);


--
-- Name: rostered_players rostered_players_pkey; Type: CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.rostered_players
    ADD CONSTRAINT rostered_players_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: teams_users teams_users_pkey; Type: CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.teams_users
    ADD CONSTRAINT teams_users_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: all_players_year_range_ssnum_index; Type: INDEX; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE UNIQUE INDEX all_players_year_range_ssnum_index ON public.all_players USING btree (year_range, ssnum);


--
-- Name: auctions_name_index; Type: INDEX; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE UNIQUE INDEX auctions_name_index ON public.auctions USING btree (name);


--
-- Name: auctions_users_auction_id_user_id_index; Type: INDEX; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE UNIQUE INDEX auctions_users_auction_id_user_id_index ON public.auctions_users USING btree (auction_id, user_id);


--
-- Name: teams_name_index; Type: INDEX; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE UNIQUE INDEX teams_name_index ON public.teams USING btree (name);


--
-- Name: teams_users_team_id_user_id_index; Type: INDEX; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE UNIQUE INDEX teams_users_team_id_user_id_index ON public.teams_users USING btree (team_id, user_id);


--
-- Name: users_username_email_index; Type: INDEX; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

CREATE UNIQUE INDEX users_username_email_index ON public.users USING btree (username, email);


--
-- Name: auctions_users auctions_users_auction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.auctions_users
    ADD CONSTRAINT auctions_users_auction_id_fkey FOREIGN KEY (auction_id) REFERENCES public.auctions(id);


--
-- Name: auctions_users auctions_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.auctions_users
    ADD CONSTRAINT auctions_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: bids bids_auction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.bids
    ADD CONSTRAINT bids_auction_id_fkey FOREIGN KEY (auction_id) REFERENCES public.auctions(id);


--
-- Name: bids bids_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.bids
    ADD CONSTRAINT bids_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: ordered_players ordered_players_auction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.ordered_players
    ADD CONSTRAINT ordered_players_auction_id_fkey FOREIGN KEY (auction_id) REFERENCES public.auctions(id);


--
-- Name: ordered_players ordered_players_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.ordered_players
    ADD CONSTRAINT ordered_players_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(id);


--
-- Name: ordered_players ordered_players_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.ordered_players
    ADD CONSTRAINT ordered_players_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: players players_auction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_auction_id_fkey FOREIGN KEY (auction_id) REFERENCES public.auctions(id);


--
-- Name: players players_bid_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_bid_id_fkey FOREIGN KEY (bid_id) REFERENCES public.bids(id);


--
-- Name: players players_rostered_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_rostered_player_id_fkey FOREIGN KEY (rostered_player_id) REFERENCES public.rostered_players(id);


--
-- Name: rostered_players rostered_players_auction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.rostered_players
    ADD CONSTRAINT rostered_players_auction_id_fkey FOREIGN KEY (auction_id) REFERENCES public.auctions(id);


--
-- Name: rostered_players rostered_players_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.rostered_players
    ADD CONSTRAINT rostered_players_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: teams teams_auction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_auction_id_fkey FOREIGN KEY (auction_id) REFERENCES public.auctions(id);


--
-- Name: teams_users teams_users_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.teams_users
    ADD CONSTRAINT teams_users_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: teams_users teams_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: 6acad2f2-ff4e-428e-8292-71bf56b8133f-user
--

ALTER TABLE ONLY public.teams_users
    ADD CONSTRAINT teams_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO "6acad2f2-ff4e-428e-8292-71bf56b8133f-user";


--
-- PostgreSQL database dump complete
--

