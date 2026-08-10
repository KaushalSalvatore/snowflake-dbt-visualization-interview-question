-- Pubic API which require no key

-- Step 1 Network rule

CREATE OR REPLACE NETWORK RULE JSON_PLACE_HOLDER_RULE
MODE = EGRESS -- Allows Snowflake to send requests to an external destination.
TYPE = HOST_PORT
VALUE_LIST = ('jsonplaceholder.typicode.com' ) ;

-- Step 2 Create External access integration

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION JSON_PLACE_HOLDER_API
ALLOWED_NETWORK_RULES = (JSON_PLACE_HOLDER_RULE)
ENABLED = TRUE;

-- Step 3- Functions

CREATE OR REPLACE FUNCTION get_users()
RETURNS TABLE (
    user_id NUMBER,
    name VARCHAR,
    email VARCHAR,
    city VARCHAR,
    company_name VARCHAR
    )
    LANGUAGE PYTHON
    RUNTIME_VERSION = 3.10
    PACKAGES = ('requests')
    EXTERNAL_ACCESS_INTEGRATIONS = (JSON_PLACE_HOLDER_API)
    HANDLER = 'userdata'
    AS
    $$
    import requests
    class userdata:
        def grocess (self) :
            # Fetching data from the open-source users endpoint
            response = requests.get("https://jsonplaceholder.typicode.com/users")
            data = response. json()

            for user in data:
            # Extracting flat and nested fields
            user_id = user. get("id")
            name = user. get ("name")
            email = user. get("email")

            # Handling nested JSON objects (address and company)
            city = user.get("address", {}).get("city")
            company_name = user. get ("company", {}) .get("name")
            # Returning the row to the Snowflake table output
            yield (user_id, name, email, city, company_name)

$$:

SELECT * FROM TABLE (get_users());


-- Api data with api key 

-- Step 1 : Create Network Rule

CREATE OR REPLACE NETWORK RULE tmdb_api_network_rule
MODE = EGRESS -- Allows Snowflake to send requests to an external destination.
TYPE = HOST_PORT
VALUE_LIST = ('api.themoviedb.org');


-- Step 2 : Create Secrert ( API KEY) : Don't hard code API key

CREATE OR REPLACE SECRET tmdb_api_key
TYPE = GENERIC_STRING
SECRET_STRING = '5a4066f2edf484d5bcde2d71c16bf0b7';

-- Step 3 : Create External Access

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION tmdb_ext_integration
ALLOWED_NETWORK_RULES = (tmdb_api_network_rule)
ALLOWED_AUTHENTICATION_SECRETS = (tmdb_api_key)
ENABLED = TRUE;

CREATE OR REPLACE TABLE MOVIE (
movie_id NUMBER,
title STRING,
original_title STRING,
original_language STRING,
release_date DATE,
popularity FLOAT,
vote_average FLOAT,
vote_count NUMBER,
adult BOOLEAN,
video BOOLEAN,
overview STRING,
genre_ids ARRAY,
raw_pay\qad VARIANT,
load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);
RUNTIME_VERSION = 3.10
PACKAGES = ('requests', 'snowflake-snowpark-python' )
EXTERNAL_ACCESS_INTEGRATIONS = (tmdk_ext_integration)
SECRETS = ('tmdb_key' = tmdb_api_key)
HANDLER = 'run'
EXECUTE AS OWNER
AS
$$

import requests

CREATE OR REPLACE PROCEDURE load_tmdb_movies (page_number INTEGER)
RETURNS STRING
LANGUAGE PYTHON
import json
import snowflake

def run(session, page_number) :
api_key = _snowflake.get_generic_secret_string("tmdb_key")
url = f"https://api.themoviedb.org/3/movie/popular?page={page_number}&api_key={api_key}"
response = requests. get (url)
response.raise_for_status ()
movies = response. json() ["results"]

# Use SELECT instead of VALUES to allow function calls on bind parameters

insert_sql = """
INSERT INTO MOVIE (
movie_id, title, original_title, original_language,
release_date, popularity, vote_average, vote_count,
adult, video, overview, genre_ids, raw_payload
)
SELECT ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, PARSE_JSON(?), PARSE_JSON(?)
"""
count = 0
for m in movies:
    genre_ids_json = json. dumps (m.get("genre_ids"))
    raw_payload_json = json. dumps (m)
    session. sql(insert_sql, params=[
    m.get("id"),
    m.get("title"),
    m.get("original_title"),
    m.get ("original_language"),
    m.get ("release_date"),
    m.get("popularity"),
    m.get("vote_average"),
    m.get("vote_countl"),
    m.get("adult"),
    m.get("video"),
    m.get("overview"),
    genre_ids_json,
    raw_payload_json
    ]).collect ()
count +:
+= 1
return f"Inserted {count} movies from page {page_number}"
$$ ;

CALL LOAD_TMDB_MOVIES(1);

Select * from MOVIE;