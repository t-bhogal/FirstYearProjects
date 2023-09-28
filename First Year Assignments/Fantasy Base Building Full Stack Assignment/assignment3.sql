--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2
-- Dumped by pg_dump version 15.2

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
-- Name: building; Type: TABLE; Schema: public; Owner: fsad
--

CREATE TABLE public.building (
    building_id integer NOT NULL,
    building_name text,
    building_description text,
    resource_generated integer
);


ALTER TABLE public.building OWNER TO fsad;

--
-- Name: player_name_building_number_table; Type: TABLE; Schema: public; Owner: fsad
--

CREATE TABLE public.player_name_building_number_table (
    player_name text,
    building_id integer
);


ALTER TABLE public.player_name_building_number_table OWNER TO fsad;

--
-- Name: player_buildings; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.player_buildings AS
 SELECT player_name_building_number_table.player_name,
    building.building_name
   FROM (public.player_name_building_number_table
     JOIN public.building ON ((player_name_building_number_table.building_id = building.building_id)));


ALTER TABLE public.player_buildings OWNER TO fsad;

--
-- Name: aisha_khan_buildings; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.aisha_khan_buildings AS
 SELECT player_buildings.player_name,
    player_buildings.building_name
   FROM public.player_buildings
  WHERE (player_buildings.player_name = 'AishaKhan'::text);


ALTER TABLE public.aisha_khan_buildings OWNER TO fsad;

--
-- Name: currency; Type: TABLE; Schema: public; Owner: fsad
--

CREATE TABLE public.currency (
    currency_id integer NOT NULL,
    currency_name text,
    premium boolean
);


ALTER TABLE public.currency OWNER TO fsad;

--
-- Name: player; Type: TABLE; Schema: public; Owner: fsad
--

CREATE TABLE public.player (
    player_id integer NOT NULL,
    player_name text,
    player_password text
);


ALTER TABLE public.player OWNER TO fsad;

--
-- Name: player_currency; Type: TABLE; Schema: public; Owner: fsad
--

CREATE TABLE public.player_currency (
    player_id integer,
    currency_id integer,
    amount integer
);


ALTER TABLE public.player_currency OWNER TO fsad;

--
-- Name: player_currencies_old; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.player_currencies_old AS
 SELECT player.player_name,
    currency.currency_name,
    player_currency.amount
   FROM ((public.player_currency
     JOIN public.player ON ((player_currency.player_id = player.player_id)))
     JOIN public.currency ON ((player_currency.currency_id = currency.currency_id)));


ALTER TABLE public.player_currencies_old OWNER TO fsad;

--
-- Name: player_currencies; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.player_currencies AS
 SELECT player_currencies_old.player_name,
    sum(player_currencies_old.amount) FILTER (WHERE (player_currencies_old.currency_name = 'Gold'::text)) AS gold,
    sum(player_currencies_old.amount) FILTER (WHERE (player_currencies_old.currency_name = 'Ethereal Silver'::text)) AS silver,
    sum(player_currencies_old.amount) FILTER (WHERE (player_currencies_old.currency_name = 'Diamonds'::text)) AS diamonds
   FROM public.player_currencies_old
  GROUP BY player_currencies_old.player_name;


ALTER TABLE public.player_currencies OWNER TO fsad;

--
-- Name: aisha_khan_currency; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.aisha_khan_currency AS
 SELECT player_currencies.player_name,
    player_currencies.gold,
    player_currencies.silver,
    player_currencies.diamonds
   FROM public.player_currencies
  WHERE (player_currencies.player_name = 'AishaKhan'::text);


ALTER TABLE public.aisha_khan_currency OWNER TO fsad;

--
-- Name: player_resource; Type: TABLE; Schema: public; Owner: fsad
--

CREATE TABLE public.player_resource (
    player_id integer,
    resource_id integer,
    amount integer
);


ALTER TABLE public.player_resource OWNER TO fsad;

--
-- Name: resource; Type: TABLE; Schema: public; Owner: fsad
--

CREATE TABLE public.resource (
    resource_id integer NOT NULL,
    resource_name text
);


ALTER TABLE public.resource OWNER TO fsad;

--
-- Name: test_view; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.test_view AS
 SELECT player.player_name,
    resource.resource_name,
    player_resource.amount
   FROM ((public.player_resource
     JOIN public.player ON ((player_resource.player_id = player.player_id)))
     JOIN public.resource ON ((player_resource.resource_id = resource.resource_id)));


ALTER TABLE public.test_view OWNER TO fsad;

--
-- Name: player_resources_wrong_format; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.player_resources_wrong_format AS
 SELECT test_view.player_name,
    test_view.resource_name,
    test_view.amount
   FROM public.test_view
  WHERE (test_view.resource_name <> 'Gold'::text);


ALTER TABLE public.player_resources_wrong_format OWNER TO fsad;

--
-- Name: player_resources; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.player_resources AS
 SELECT player_resources_wrong_format.player_name,
    sum(player_resources_wrong_format.amount) FILTER (WHERE (player_resources_wrong_format.resource_name = 'Food'::text)) AS food,
    sum(player_resources_wrong_format.amount) FILTER (WHERE (player_resources_wrong_format.resource_name = 'Wood'::text)) AS wood,
    sum(player_resources_wrong_format.amount) FILTER (WHERE (player_resources_wrong_format.resource_name = 'Stone'::text)) AS stone
   FROM public.player_resources_wrong_format
  GROUP BY player_resources_wrong_format.player_name;


ALTER TABLE public.player_resources OWNER TO fsad;

--
-- Name: aisha_khan_resources; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.aisha_khan_resources AS
 SELECT player_resources.player_name,
    player_resources.food,
    player_resources.wood,
    player_resources.stone
   FROM public.player_resources
  WHERE (player_resources.player_name = 'AishaKhan'::text);


ALTER TABLE public.aisha_khan_resources OWNER TO fsad;

--
-- Name: base; Type: TABLE; Schema: public; Owner: fsad
--

CREATE TABLE public.base (
    base_id integer NOT NULL,
    player_id integer,
    level integer
);


ALTER TABLE public.base OWNER TO fsad;

--
-- Name: base_building; Type: TABLE; Schema: public; Owner: fsad
--

CREATE TABLE public.base_building (
    building_id integer,
    base_id integer
);


ALTER TABLE public.base_building OWNER TO fsad;

--
-- Name: building_cost; Type: TABLE; Schema: public; Owner: fsad
--

CREATE TABLE public.building_cost (
    building_id integer NOT NULL,
    resource_id integer,
    amount integer,
    build_time interval
);


ALTER TABLE public.building_cost OWNER TO fsad;

--
-- Name: building_info; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.building_info AS
 SELECT building.building_name,
    building.building_description,
    building.resource_generated,
    building_cost.amount,
    building_cost.build_time
   FROM (public.building
     JOIN public.building_cost ON ((building.building_id = building_cost.building_id)));


ALTER TABLE public.building_info OWNER TO fsad;

--
-- Name: farm_info; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.farm_info AS
 SELECT building_info.building_name,
    building_info.building_description,
    building_info.resource_generated,
    building_info.amount,
    building_info.build_time
   FROM public.building_info
  WHERE (building_info.building_name = 'Farm'::text);


ALTER TABLE public.farm_info OWNER TO fsad;

--
-- Name: fatima_ahmed_buildings; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.fatima_ahmed_buildings AS
 SELECT player_buildings.player_name,
    player_buildings.building_name
   FROM public.player_buildings
  WHERE (player_buildings.player_name = 'FatimaAhmed'::text);


ALTER TABLE public.fatima_ahmed_buildings OWNER TO fsad;

--
-- Name: fatima_ahmed_currency; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.fatima_ahmed_currency AS
 SELECT player_currencies.player_name,
    player_currencies.gold,
    player_currencies.silver,
    player_currencies.diamonds
   FROM public.player_currencies
  WHERE (player_currencies.player_name = 'FatimaAhmed'::text);


ALTER TABLE public.fatima_ahmed_currency OWNER TO fsad;

--
-- Name: fatima_ahmed_resources; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.fatima_ahmed_resources AS
 SELECT player_resources.player_name,
    player_resources.food,
    player_resources.wood,
    player_resources.stone
   FROM public.player_resources
  WHERE (player_resources.player_name = 'FatimaAhmed'::text);


ALTER TABLE public.fatima_ahmed_resources OWNER TO fsad;

--
-- Name: gold_mine_info; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.gold_mine_info AS
 SELECT building_info.building_name,
    building_info.building_description,
    building_info.resource_generated,
    building_info.amount,
    building_info.build_time
   FROM public.building_info
  WHERE (building_info.building_name = 'Gold Mine'::text);


ALTER TABLE public.gold_mine_info OWNER TO fsad;

--
-- Name: harry_smith_buildings; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.harry_smith_buildings AS
 SELECT player_buildings.player_name,
    player_buildings.building_name
   FROM public.player_buildings
  WHERE (player_buildings.player_name = 'HarrySmith'::text);


ALTER TABLE public.harry_smith_buildings OWNER TO fsad;

--
-- Name: harry_smith_currency; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.harry_smith_currency AS
 SELECT player_currencies.player_name,
    player_currencies.gold,
    player_currencies.silver,
    player_currencies.diamonds
   FROM public.player_currencies
  WHERE (player_currencies.player_name = 'HarrySmith'::text);


ALTER TABLE public.harry_smith_currency OWNER TO fsad;

--
-- Name: harry_smith_resources; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.harry_smith_resources AS
 SELECT player_resources.player_name,
    player_resources.food,
    player_resources.wood,
    player_resources.stone
   FROM public.player_resources
  WHERE (player_resources.player_name = 'HarrySmith'::text);


ALTER TABLE public.harry_smith_resources OWNER TO fsad;

--
-- Name: lumber_mill_info; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.lumber_mill_info AS
 SELECT building_info.building_name,
    building_info.building_description,
    building_info.resource_generated,
    building_info.amount,
    building_info.build_time
   FROM public.building_info
  WHERE (building_info.building_name = 'Lumber Mill'::text);


ALTER TABLE public.lumber_mill_info OWNER TO fsad;

--
-- Name: marketplace_info; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.marketplace_info AS
 SELECT building_info.building_name,
    building_info.building_description,
    building_info.resource_generated,
    building_info.amount,
    building_info.build_time
   FROM public.building_info
  WHERE (building_info.building_name = 'Marketplace'::text);


ALTER TABLE public.marketplace_info OWNER TO fsad;

--
-- Name: mohammed_ali_buildings; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.mohammed_ali_buildings AS
 SELECT player_buildings.player_name,
    player_buildings.building_name
   FROM public.player_buildings
  WHERE (player_buildings.player_name = 'MohammedAli'::text);


ALTER TABLE public.mohammed_ali_buildings OWNER TO fsad;

--
-- Name: mohammed_ali_currency; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.mohammed_ali_currency AS
 SELECT player_currencies.player_name,
    player_currencies.gold,
    player_currencies.silver,
    player_currencies.diamonds
   FROM public.player_currencies
  WHERE (player_currencies.player_name = 'MohammedAli'::text);


ALTER TABLE public.mohammed_ali_currency OWNER TO fsad;

--
-- Name: mohammed_ali_resources; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.mohammed_ali_resources AS
 SELECT player_resources.player_name,
    player_resources.food,
    player_resources.wood,
    player_resources.stone
   FROM public.player_resources
  WHERE (player_resources.player_name = 'MohammedAli'::text);


ALTER TABLE public.mohammed_ali_resources OWNER TO fsad;

--
-- Name: oliver_taylor_buildings; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.oliver_taylor_buildings AS
 SELECT player_buildings.player_name,
    player_buildings.building_name
   FROM public.player_buildings
  WHERE (player_buildings.player_name = 'OliverTaylor'::text);


ALTER TABLE public.oliver_taylor_buildings OWNER TO fsad;

--
-- Name: oliver_taylor_currency; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.oliver_taylor_currency AS
 SELECT player_currencies.player_name,
    player_currencies.gold,
    player_currencies.silver,
    player_currencies.diamonds
   FROM public.player_currencies
  WHERE (player_currencies.player_name = 'OliverTaylor'::text);


ALTER TABLE public.oliver_taylor_currency OWNER TO fsad;

--
-- Name: oliver_taylor_resources; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.oliver_taylor_resources AS
 SELECT player_resources.player_name,
    player_resources.food,
    player_resources.wood,
    player_resources.stone
   FROM public.player_resources
  WHERE (player_resources.player_name = 'OliverTaylor'::text);


ALTER TABLE public.oliver_taylor_resources OWNER TO fsad;

--
-- Name: player_name_base_id; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.player_name_base_id AS
 SELECT player.player_name,
    base.base_id
   FROM (public.player
     JOIN public.base ON ((player.player_id = base.player_id)));


ALTER TABLE public.player_name_base_id OWNER TO fsad;

--
-- Name: player_resources_table; Type: TABLE; Schema: public; Owner: fsad
--

CREATE TABLE public.player_resources_table (
    player_name text,
    resource_name text,
    amount integer
);


ALTER TABLE public.player_resources_table OWNER TO fsad;

--
-- Name: sophie_brown_buildings; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.sophie_brown_buildings AS
 SELECT player_buildings.player_name,
    player_buildings.building_name
   FROM public.player_buildings
  WHERE (player_buildings.player_name = 'SophieBrown'::text);


ALTER TABLE public.sophie_brown_buildings OWNER TO fsad;

--
-- Name: sophie_brown_currency; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.sophie_brown_currency AS
 SELECT player_currencies.player_name,
    player_currencies.gold,
    player_currencies.silver,
    player_currencies.diamonds
   FROM public.player_currencies
  WHERE (player_currencies.player_name = 'SophieBrown'::text);


ALTER TABLE public.sophie_brown_currency OWNER TO fsad;

--
-- Name: sophie_brown_resources; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.sophie_brown_resources AS
 SELECT player_resources.player_name,
    player_resources.food,
    player_resources.wood,
    player_resources.stone
   FROM public.player_resources
  WHERE (player_resources.player_name = 'SophieBrown'::text);


ALTER TABLE public.sophie_brown_resources OWNER TO fsad;

--
-- Name: stone_quarry_info; Type: VIEW; Schema: public; Owner: fsad
--

CREATE VIEW public.stone_quarry_info AS
 SELECT building_info.building_name,
    building_info.building_description,
    building_info.resource_generated,
    building_info.amount,
    building_info.build_time
   FROM public.building_info
  WHERE (building_info.building_name = 'Stone Quarry'::text);


ALTER TABLE public.stone_quarry_info OWNER TO fsad;

--
-- Data for Name: base; Type: TABLE DATA; Schema: public; Owner: fsad
--

COPY public.base (base_id, player_id, level) FROM stdin;
1       1       2
2       2       1
3       3       3
4       4       1
5       5       2
6       6       1
\.


--
-- Data for Name: base_building; Type: TABLE DATA; Schema: public; Owner: fsad
--

COPY public.base_building (building_id, base_id) FROM stdin;
1       1
2       1
3       1
4       1
5       1
1       2
2       2
3       2
1       3
2       3
3       3
4       3
5       3
1       4
2       4
3       4
1       5
2       5
1       6
2       6
3       6
4       6
\.


--
-- Data for Name: building; Type: TABLE DATA; Schema: public; Owner: fsad
--

COPY public.building (building_id, building_name, building_description, resource_generated) FROM stdin;
1       Farm    Produces food for the kingdom   1
2       Lumber Mill     Produces wood for the kingdom   2
3       Stone Quarry    Produces stone for the kingdom  3
4       Gold Mine       Produces gold for the kingdom   4
5       Marketplace     Allows for the exchange of resources between kingdoms   4
\.


--
-- Data for Name: building_cost; Type: TABLE DATA; Schema: public; Owner: fsad
--

COPY public.building_cost (building_id, resource_id, amount, build_time) FROM stdin;
1       4       100     3 days
2       4       75      2 days
3       4       150     5 days
4       4       200     7 days
5       4       350     14 days
\.


--
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: fsad
--

COPY public.currency (currency_id, currency_name, premium) FROM stdin;
1       Gold    f
2       Ethereal Silver f
3       Diamonds        t
\.


--
-- Data for Name: player; Type: TABLE DATA; Schema: public; Owner: fsad
--

COPY public.player (player_id, player_name, player_password) FROM stdin;
1       HarrySmith      password1
2       SophieBrown     password2
3       OliverTaylor    password3
4       FatimaAhmed     password4
5       MohammedAli     password5
6       AishaKhan       password6
\.


--
-- Data for Name: player_currency; Type: TABLE DATA; Schema: public; Owner: fsad
--

COPY public.player_currency (player_id, currency_id, amount) FROM stdin;
1       1       100
1       2       50
1       3       10
2       1       200
2       2       100
2       3       20
3       1       50
3       2       20
3       3       5
4       1       150
4       2       75
5       1       75
5       2       30
5       3       8
6       1       300
6       2       150
6       3       50
\.


--
-- Data for Name: player_name_building_number_table; Type: TABLE DATA; Schema: public; Owner: fsad
--

COPY public.player_name_building_number_table (player_name, building_id) FROM stdin;
HarrySmith      1
HarrySmith      2
HarrySmith      3
HarrySmith      4
HarrySmith      5
SophieBrown     1
SophieBrown     2
SophieBrown     3
OliverTaylor    1
OliverTaylor    2
OliverTaylor    3
OliverTaylor    4
OliverTaylor    5
FatimaAhmed     1
FatimaAhmed     2
FatimaAhmed     3
MohammedAli     1
MohammedAli     2
AishaKhan       1
AishaKhan       2
AishaKhan       3
AishaKhan       4
\.


--
-- Data for Name: player_resource; Type: TABLE DATA; Schema: public; Owner: fsad
--

COPY public.player_resource (player_id, resource_id, amount) FROM stdin;
1       1       5000
1       2       2500
1       3       1000
1       4       100
2       1       4500
2       2       2000
2       3       500
2       4       50
3       1       6000
3       2       3000
3       3       1500
3       4       200
4       1       4000
4       2       1500
4       3       2000
4       4       300
5       1       5500
5       2       3500
5       3       800
5       4       150
6       1       7000
6       2       4000
6       3       2000
6       4       500
\.


--
-- Data for Name: player_resources_table; Type: TABLE DATA; Schema: public; Owner: fsad
--

COPY public.player_resources_table (player_name, resource_name, amount) FROM stdin;
HarrySmith      Food    5000
HarrySmith      Wood    2500
HarrySmith      Stone   1000
SophieBrown     Food    4500
SophieBrown     Wood    2000
SophieBrown     Stone   500
OliverTaylor    Food    6000
OliverTaylor    Wood    3000
OliverTaylor    Stone   1500
FatimaAhmed     Food    4000
FatimaAhmed     Wood    1500
FatimaAhmed     Stone   2000
MohammedAli     Food    5500
MohammedAli     Wood    3500
MohammedAli     Stone   800
AishaKhan       Food    7000
AishaKhan       Wood    4000
AishaKhan       Stone   2000
\.


--
-- Data for Name: resource; Type: TABLE DATA; Schema: public; Owner: fsad
--

COPY public.resource (resource_id, resource_name) FROM stdin;
1       Food
2       Wood
3       Stone
4       Gold
\.


--
-- Name: base base_pkey; Type: CONSTRAINT; Schema: public; Owner: fsad
--

ALTER TABLE ONLY public.base
    ADD CONSTRAINT base_pkey PRIMARY KEY (base_id);


--
-- Name: building_cost building_cost_pkey; Type: CONSTRAINT; Schema: public; Owner: fsad
--

ALTER TABLE ONLY public.building_cost
    ADD CONSTRAINT building_cost_pkey PRIMARY KEY (building_id);


--
-- Name: building building_pkey; Type: CONSTRAINT; Schema: public; Owner: fsad
--

ALTER TABLE ONLY public.building
    ADD CONSTRAINT building_pkey PRIMARY KEY (building_id);


--
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: public; Owner: fsad
--

ALTER TABLE ONLY public.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (currency_id);


--
-- Name: player player_pkey; Type: CONSTRAINT; Schema: public; Owner: fsad
--

ALTER TABLE ONLY public.player
    ADD CONSTRAINT player_pkey PRIMARY KEY (player_id);


--
-- Name: resource resource_pkey; Type: CONSTRAINT; Schema: public; Owner: fsad
--

ALTER TABLE ONLY public.resource
    ADD CONSTRAINT resource_pkey PRIMARY KEY (resource_id);


--
-- Name: base base_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fsad
--

ALTER TABLE ONLY public.base
    ADD CONSTRAINT base_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.player(player_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- Name: building_cost building_cost_building_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fsad
--

ALTER TABLE ONLY public.building_cost
    ADD CONSTRAINT building_cost_building_id_fkey FOREIGN KEY (building_id) REFERENCES public.building(building_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- Name: building_cost building_cost_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fsad
--

ALTER TABLE ONLY public.building_cost
    ADD CONSTRAINT building_cost_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.resource(resource_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- Name: building building_resource_generated_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fsad
--

ALTER TABLE ONLY public.building
    ADD CONSTRAINT building_resource_generated_fkey FOREIGN KEY (resource_generated) REFERENCES public.resource(resource_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO fsad;


--
-- PostgreSQL database dump complete
--