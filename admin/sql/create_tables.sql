BEGIN;

CREATE TABLE "user" (
  id             SERIAL,
  created        TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  musicbrainz_id VARCHAR NOT NULL,
  auth_token     VARCHAR,
  last_login     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  latest_import  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT TIMESTAMP 'epoch'
);
ALTER TABLE "user" ADD CONSTRAINT user_musicbrainz_id_key UNIQUE (musicbrainz_id);

CREATE TABLE api_compat.token (
     id               SERIAL,
     user_id          INTEGER, -- FK to "user".id
     token            TEXT NOT NULL,
     api_key          VARCHAR NOT NULL,
     ts               TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE api_compat.token ADD CONSTRAINT token_api_key_uniq UNIQUE (api_key);
ALTER TABLE api_compat.token ADD CONSTRAINT token_token_uniq UNIQUE (token);

CREATE TABLE api_compat.session (
    id        SERIAL,
    user_id   INTEGER NOT NULL, -- FK to "user".id
    sid       VARCHAR NOT NULL,
    api_key   VARCHAR NOT NULL,
    ts        TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE api_compat.session ADD CONSTRAINT session_sid_uniq UNIQUE (sid);

CREATE TABLE statistics.user (
    user_id                 INTEGER NOT NULL, -- PK and FK to "user".id
    artist                  JSONB,
    release                 JSONB,
    recording               JSONB,
    last_updated            TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TABLE statistics.artist (
    id                      SERIAL, -- PK
    msid                    UUID NOT NULL,
    name                    VARCHAR,
    release                 JSONB,
    recording               JSONB,
    listener                JSONB,
    listen_count            JSONB,
    last_updated            TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);
ALTER TABLE statistics.artist ADD CONSTRAINT artist_stats_msid_uniq UNIQUE (msid);

CREATE TABLE statistics.release (
    id                      SERIAL, -- PK
    msid                    UUID NOT NULL,
    name                    VARCHAR,
    recording               JSONB,
    listener                JSONB,
    listen_count            JSONB,
    last_updated            TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);
ALTER TABLE statistics.release ADD CONSTRAINT release_stats_msid_uniq UNIQUE (msid);

CREATE TABLE statistics.recording (
    id                      SERIAL, -- PK
    msid                    UUID NOT NULL,
    name                    VARCHAR,
    listener                JSONB,
    listen_count            JSONB,
    last_updated            TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()

);
ALTER TABLE statistics.recording ADD CONSTRAINT recording_stats_msid_uniq UNIQUE (msid);


CREATE TABLE data_dump (
  id          SERIAL,
  created     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

COMMIT;
