CREATE DATABASE IF NOT EXISTS NordicDoor;
USE NordicDoor;

CREATE TABLE IF NOT EXISTS Bruker
(
    AnsattNr    INTEGER      NOT NULL,
    Fornavn     VARCHAR(50)  NOT NULL,
    Etternavn   VARCHAR(50)  NOT NULL,
    Email       VARCHAR(254) NOT NULL,
    PassordHash VARCHAR(200) NOT NULL,
    Opprettet   DATETIME DEFAULT CURRENT_TIMESTAMP,
    Rolle       VARCHAR(50),
    LederId     INTEGER  DEFAULT NULL,
    KEY LederId (LederId),
    FOREIGN KEY (LederId) REFERENCES Bruker (AnsattNr),
    CONSTRAINT PK_Bruker PRIMARY KEY (AnsattNr)
);

CREATE TABLE IF NOT EXISTS Team
(
    TeamId      INTEGER NOT NULL AUTO_INCREMENT,
    TeamLederId INTEGER NOT NULL,
    Navn        VARCHAR(50),
    AvdelingId  INTEGER,
    FOREIGN KEY (TeamLederId) REFERENCES Bruker (AnsattNr),
    FOREIGN KEY (AvdelingId) REFERENCES Team (TeamId),
    CONSTRAINT PK_Team PRIMARY KEY (TeamId)
);

CREATE TABLE IF NOT EXISTS Forslag
(
    ForslagId     INTEGER                   NOT NULL AUTO_INCREMENT,
    ForfatterId   INTEGER                   NOT NULL,
    TeamId        INTEGER                   NOT NULL,
    Emne          VARCHAR(150)              NOT NULL,
    Beskrivelse   VARCHAR(2000)             NOT NULL,
    Bilde         MEDIUMBLOB,
    Status        VARCHAR(5) DEFAULT "plan" NOT NULL,
    Opprettet     DATETIME   DEFAULT CURRENT_TIMESTAMP,
    SistOppdatert DATETIME   DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    Frist         DATETIME,
    Kategori      VARCHAR(150),
    CONSTRAINT PK_Forslag PRIMARY KEY (ForslagId),
    FOREIGN KEY (ForfatterId) REFERENCES Bruker (AnsattNr),
    FOREIGN KEY (TeamId) REFERENCES Team (TeamId)
);

CREATE TABLE IF NOT EXISTS TeamMedlemskap
(
    TeamId   INTEGER,
    AnsattNr INTEGER,
    CONSTRAINT PK_TeamMedlemskap PRIMARY KEY (TeamId, AnsattNr),
    FOREIGN KEY (TeamId) REFERENCES Team (TeamId),
    FOREIGN KEY (AnsattNr) REFERENCES Bruker (AnsattNr)
);

CREATE TABLE IF NOT EXISTS ForslagKobling
(
    AnsattNr  INTEGER NOT NULL,
    ForslagId INTEGER NOT NULL,
    CONSTRAINT PK_ForslagKobling PRIMARY KEY (AnsattNr, ForslagId),
    CONSTRAINT FK_ForslagKobling_Bruker FOREIGN KEY (AnsattNr) REFERENCES Bruker (AnsattNr) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ForslagId) REFERENCES Forslag (ForslagId) ON DELETE CASCADE ON UPDATE CASCADE
);
