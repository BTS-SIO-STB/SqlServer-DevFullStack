-- Create Database if not exists
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Deezer')
BEGIN
    CREATE DATABASE Deezer;
END

USE Deezer;

-- Create schema if not exists
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dbo')
BEGIN
    EXEC('CREATE SCHEMA dbo');
END

-- Create Artist table if not exists
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Artist')
BEGIN
    CREATE TABLE Deezer.dbo.Artist (
        Id int NOT NULL,
        Name nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
        CONSTRAINT PK_Artist PRIMARY KEY (Id)
    );
END

-- Create Playlist table if not exists
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Playlist')
BEGIN
    CREATE TABLE Deezer.dbo.Playlist (
        Name nvarchar(450) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
        SavedAt datetime2 NOT NULL,
        CONSTRAINT PK_Playlist PRIMARY KEY (Name)
    );
END

-- Create __EFMigrationsHistory table if not exists
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = '__EFMigrationsHistory')
BEGIN
    CREATE TABLE Deezer.dbo.[__EFMigrationsHistory] (
        MigrationId nvarchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
        ProductVersion nvarchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
        CONSTRAINT PK___EFMigrationsHistory PRIMARY KEY (MigrationId)
    );
END

-- Create Song table if not exists
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Song')
BEGIN
    CREATE TABLE Deezer.dbo.Song (
        Id int IDENTITY(1,1) NOT NULL,
        Title nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
        ArtistId int NOT NULL,
        SongUrl nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
        PlaylistName nvarchar(450) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
        CONSTRAINT PK_Song PRIMARY KEY (Id),
        CONSTRAINT FK_Song_Artist_ArtistId FOREIGN KEY (ArtistId) REFERENCES Deezer.dbo.Artist(Id) ON DELETE CASCADE,
        CONSTRAINT FK_Song_Playlist_PlaylistName FOREIGN KEY (PlaylistName) REFERENCES Deezer.dbo.Playlist(Name) ON DELETE CASCADE
    );
END

-- Create Nonclustered Indexes if not exists

-- Check if the index exists on ArtistId
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Song_ArtistId' AND object_id = OBJECT_ID('Deezer.dbo.Song'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Song_ArtistId ON dbo.Song (ArtistId ASC)
        WITH (
            PAD_INDEX = OFF,
            FILLFACTOR = 100,
            SORT_IN_TEMPDB = OFF,
            IGNORE_DUP_KEY = OFF,
            STATISTICS_NORECOMPUTE = OFF,
            ONLINE = OFF,
            ALLOW_ROW_LOCKS = ON,
            ALLOW_PAGE_LOCKS = ON
        )
    ON [PRIMARY];
END

-- Check if the index exists on PlaylistName
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Song_PlaylistName' AND object_id = OBJECT_ID('Deezer.dbo.Song'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Song_PlaylistName ON dbo.Song (PlaylistName ASC)
        WITH (
            PAD_INDEX = OFF,
            FILLFACTOR = 100,
            SORT_IN_TEMPDB = OFF,
            IGNORE_DUP_KEY = OFF,
            STATISTICS_NORECOMPUTE = OFF,
            ONLINE = OFF,
            ALLOW_ROW_LOCKS = ON,
            ALLOW_PAGE_LOCKS = ON
        )
    ON [PRIMARY];
END
