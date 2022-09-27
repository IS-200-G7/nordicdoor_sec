CREATE TABLE Bruker(
                BrukerId INTEGER NOT NULL AUTO_INCREMENT,
                ForNavn VARCHAR(50) NOT NULL,
                EtterNavn VARCHAR(50) NOT NULL,
                Email VARCHAR(150) NOT NULL,
                PassordHash VARCHAR(200) NOT NULL,
                CONSTRAINT PK_Bruker PRIMARY KEY(BrukerId)
            );

CREATE TABLE Gruppe(
                LagId INTEGER NOT NULL AUTO_INCREMENT,
                Navn VARCHAR(50),
                AvdelingsId INTEGER,
                CONSTRAINT PK_Lag PRIMARY KEY (LagId)
            );

CREATE TABLE Forslag(
                ForslagsId INTEGER NOT NULL AUTO_INCREMENT,
                ForfatterId INTEGER NOT NULL,
                LagId INTEGER NOT NULL,
                Emne VARCHAR(150) NOT NULL,
                Beskrivelse VARCHAR(2000) NOT NULL,
                Bilde MEDIUMBLOB,
                Status INTEGER DEFAULT 1 NOT NULL,
                Tidspunkt DATE,
                CONSTRAINT PK_Forslag PRIMARY KEY (ForslagsId),
                CONSTRAINT FK_Forslag_Lag FOREIGN KEY (LagId) REFERENCES Gruppe(LagId)
                ON DELETE CASCADE
                ON UPDATE CASCADE
            );

CREATE TABLE LagMedlemskap(
                Id INTEGER NOT NULL AUTO_INCREMENT,
                LagId INTEGER,
                BrukerId INTEGER,
                CONSTRAINT PK_LagMedlemskap PRIMARY KEY (Id),
                CONSTRAINT FK_LagMedlemskap_Lag FOREIGN KEY (LagId) REFERENCES Gruppe(LagId)
                ON DELETE CASCADE
                ON UPDATE CASCADE,
                CONSTRAINT FK_LagMedlemskap_Bruker FOREIGN KEY (BrukerId) REFERENCES Bruker(BrukerId)
            );

CREATE TABLE Rolle(
                RolleId INTEGER NOT NULL,
                RolleNavn VARCHAR(150),
                CONSTRAINT PK_Rolle PRIMARY KEY (RolleId)
            );

CREATE TABLE BrukerRolle(
                BrukerId INTEGER NOT NULL,
                RolleId INTEGER NOT NULL,
                CONSTRAINT PK_BrukerRolle PRIMARY KEY (BrukerId,RolleId),
                CONSTRAINT FK_BrukerRolle_Rolle FOREIGN KEY (RolleId) REFERENCES Rolle(RolleId)
                ON DELETE CASCADE
                ON UPDATE CASCADE,
                CONSTRAINT FK_BrukerRolle_Bruker FOREIGN KEY (BrukerId) REFERENCES Bruker(BrukerId)
                ON DELETE CASCADE
                ON UPDATE CASCADE
            );

CREATE TABLE ForslagKobling(
                BrukerId INTEGER NOT NULL,
                ForslagsId INTEGER NOT NULL,
                CONSTRAINT PK_ForslagKobling PRIMARY KEY (BrukerId,ForslagsId),
                CONSTRAINT FK_ForslagKobling_Bruker FOREIGN KEY (BrukerId) REFERENCES Bruker(BrukerId)
                ON DELETE CASCADE
                ON UPDATE CASCADE,
                CONSTRAINT FK_ForslagKobling_Forslag FOREIGN KEY (ForslagsId) REFERENCES Forslag(ForslagsId)
                ON DELETE CASCADE
                ON UPDATE CASCADE
            );

