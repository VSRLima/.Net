IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [Batalhas] (
    [Id] int NOT NULL IDENTITY,
    [Nome] nvarchar(max) NULL,
    [Descricao] nvarchar(max) NULL,
    [DtInicio] datetime2 NOT NULL,
    [DtFim] datetime2 NOT NULL,
    CONSTRAINT [PK_Batalhas] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [Herois] (
    [ID] int NOT NULL IDENTITY,
    [Nome] nvarchar(max) NULL,
    [BatalhaId] int NOT NULL,
    CONSTRAINT [PK_Herois] PRIMARY KEY ([ID]),
    CONSTRAINT [FK_Herois_Batalhas_BatalhaId] FOREIGN KEY ([BatalhaId]) REFERENCES [Batalhas] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [Armas] (
    [Id] int NOT NULL IDENTITY,
    [Nome] nvarchar(max) NULL,
    [HeroiId] int NOT NULL,
    CONSTRAINT [PK_Armas] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Armas_Herois_HeroiId] FOREIGN KEY ([HeroiId]) REFERENCES [Herois] ([ID]) ON DELETE CASCADE
);
GO

CREATE INDEX [IX_Armas_HeroiId] ON [Armas] ([HeroiId]);
GO

CREATE INDEX [IX_Herois_BatalhaId] ON [Herois] ([BatalhaId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210520000157_heroi', N'5.0.6');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [Herois] DROP CONSTRAINT [FK_Herois_Batalhas_BatalhaId];
GO

DROP INDEX [IX_Herois_BatalhaId] ON [Herois];
GO

DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Herois]') AND [c].[name] = N'BatalhaId');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [Herois] DROP CONSTRAINT [' + @var0 + '];');
ALTER TABLE [Herois] DROP COLUMN [BatalhaId];
GO

CREATE TABLE [HeroisBatalhas] (
    [HeroiId] int NOT NULL,
    [BatalhaId] int NOT NULL,
    CONSTRAINT [PK_HeroisBatalhas] PRIMARY KEY ([BatalhaId], [HeroiId]),
    CONSTRAINT [FK_HeroisBatalhas_Batalhas_BatalhaId] FOREIGN KEY ([BatalhaId]) REFERENCES [Batalhas] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_HeroisBatalhas_Herois_HeroiId] FOREIGN KEY ([HeroiId]) REFERENCES [Herois] ([ID]) ON DELETE CASCADE
);
GO

CREATE TABLE [IdentidadeSecretas] (
    [Id] int NOT NULL IDENTITY,
    [NomeReal] nvarchar(max) NULL,
    [HeroiID] int NOT NULL,
    CONSTRAINT [PK_IdentidadeSecretas] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_IdentidadeSecretas_Herois_HeroiID] FOREIGN KEY ([HeroiID]) REFERENCES [Herois] ([ID]) ON DELETE CASCADE
);
GO

CREATE INDEX [IX_HeroisBatalhas_HeroiId] ON [HeroisBatalhas] ([HeroiId]);
GO

CREATE UNIQUE INDEX [IX_IdentidadeSecretas_HeroiID] ON [IdentidadeSecretas] ([HeroiID]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210520003232_HeroisBatalhas_identidade', N'5.0.6');
GO

COMMIT;
GO

