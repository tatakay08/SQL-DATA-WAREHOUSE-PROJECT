/*
=======================================================================
Create Database and Schemas
=======================================================================

Script Purpose
  This script creates a  new database named datawarehouse after checking if it already exists.
  If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas (layers) within the database using the medallion method within the database: 'bronze', 'silver', 'gold'.

WARNING:
  Running this script will drop the entire datawarehouse database if it exists.
  All data in the database will be permanently deleted. Proceed with caution and ensure that you have proper backups before running the script.
*/
-- ============================================================
-- RODUCATE DATA WAREHOUSE — BRONZE LAYER (PRODUCTION)
-- Generated from actual MongoDB BSON inspection
-- Database: roducate (from S3 backup)
-- All ObjectId fields stored as NVARCHAR(50)
-- Arrays/dicts stored as NVARCHAR(MAX)
-- ingestion_timestamp added to every table
-- ============================================================

USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Roducate_DataWarehouse')
BEGIN
    ALTER DATABASE Roducate_DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Roducate_DataWarehouse;
END;
GO

CREATE DATABASE Roducate_DataWarehouse;
GO

USE Roducate_DataWarehouse;
GO

CREATE SCHEMA Bronze;
GO
CREATE SCHEMA Silver;
GO
CREATE SCHEMA Gold;
GO


-- ============================================================
-- bronze.mongo_users (2,235 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_users', 'U') IS NOT NULL DROP TABLE bronze.mongo_users;
GO
CREATE TABLE bronze.mongo_users (
    _id                   NVARCHAR(50)  NOT NULL PRIMARY KEY,
    firstName             NVARCHAR(100),
    lastName              NVARCHAR(100),
    email                 NVARCHAR(255),
    role                  NVARCHAR(MAX),         -- array of ObjectId
    language              NVARCHAR(50),
    verified              BIT,
    avatar                NVARCHAR(50),          -- ObjectId ref
    status                NVARCHAR(50),
    isOnline              BIT,
    isSuspended           BIT,
    isTurnOffNotification BIT,
    isTwoFaEnabled        BIT,
    twoFaSecret           NVARCHAR(MAX),         -- dict {secret, temp}
    twoFaSecret_secret    NVARCHAR(255),
    twoFaSecret_temp      NVARCHAR(255),
    oathUser              BIT,
    region                NVARCHAR(100),
    device                NVARCHAR(50),
    deviceName            NVARCHAR(100),
    deviceToken           NVARCHAR(255),
    lastLoginDate         DATETIME2,
    roducateId            NVARCHAR(50),
    school                NVARCHAR(50),
    block                 BIT,
    otpRequest            INT,
    otpCode               NVARCHAR(50),
    otpExpire             DATETIME2,
    password              NVARCHAR(255),
    referralCode          NVARCHAR(50),
    timeZone              NVARCHAR(50),
    activeSessionId       NVARCHAR(255),
    country               NVARCHAR(100),
    gender                NVARCHAR(20),
    location              NVARCHAR(100),
    dob                   NVARCHAR(50),
    countryCode           NVARCHAR(10),
    phoneNumber           NVARCHAR(50),
    webDeviceToken        NVARCHAR(255),
    isProfessional        BIT,
    state                 NVARCHAR(50),
    address               NVARCHAR(255),
    accountName           NVARCHAR(100),
    accountNumber         NVARCHAR(50),
    bankCode              NVARCHAR(50),
    bankName              NVARCHAR(255),
    sponsorId             NVARCHAR(50),
    createdAt             DATETIME2,
    updatedAt             DATETIME2,
    __v                   INT,
    ingestion_timestamp   DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_uservisits (2,943 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_uservisits', 'U') IS NOT NULL DROP TABLE bronze.mongo_uservisits;
GO
CREATE TABLE bronze.mongo_uservisits (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    userId              NVARCHAR(50),
    day                 NVARCHAR(20),
    video               INT,
    podcast             INT,
    study               INT,
    digipreneur         INT,
    mockExam            INT,
    examSuccess         INT,
    game                INT,
    lifeSkill           INT,
    createdAt           DATETIME2,
    updatedAt           DATETIME2,
    __v                 INT,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_timelines (3,878 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_timelines', 'U') IS NOT NULL DROP TABLE bronze.mongo_timelines;
GO
CREATE TABLE bronze.mongo_timelines (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    title               NVARCHAR(255),
    event               NVARCHAR(100),
    userIds             NVARCHAR(MAX),
    transactionIds      NVARCHAR(MAX),
    schoolIds           NVARCHAR(MAX),
    sponsorId           NVARCHAR(50),
    createdAt           DATETIME2,
    updatedAt           DATETIME2,
    __v                 INT,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_progresstrackeritems (10,449 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_progresstrackeritems', 'U') IS NOT NULL DROP TABLE bronze.mongo_progresstrackeritems;
GO
CREATE TABLE bronze.mongo_progresstrackeritems (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    userId              NVARCHAR(50),
    item                NVARCHAR(100),
    itemId              NVARCHAR(50),
    topicProgressId     NVARCHAR(50),
    schoolId            NVARCHAR(50),
    progress            INT,
    playTime            INT,
    groupId             NVARCHAR(50),
    sectionId           NVARCHAR(50),
    isDone              BIT,
    createdAt           DATETIME2,
    updatedAt           DATETIME2,
    __v                 INT,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_tutorlearners (60 docs)
-- No createdAt/updatedAt in source
-- ============================================================
IF OBJECT_ID('bronze.mongo_tutorlearners', 'U') IS NOT NULL DROP TABLE bronze.mongo_tutorlearners;
GO
CREATE TABLE bronze.mongo_tutorlearners (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    learnerId           NVARCHAR(50),
    tutorId             NVARCHAR(50),
    status              NVARCHAR(50),
    __v                 INT,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_mockexams (12 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_mockexams', 'U') IS NOT NULL DROP TABLE bronze.mongo_mockexams;
GO
CREATE TABLE bronze.mongo_mockexams (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    name                NVARCHAR(255),
    description         NVARCHAR(MAX),
    classificationId    NVARCHAR(50),
    imageUrl            NVARCHAR(500),
    educationLevelId    NVARCHAR(50),
    createdBy           NVARCHAR(50),
    school              NVARCHAR(50),
    isPublished         BIT,
    createdAt           DATETIME2,
    updatedAt           DATETIME2,
    __v                 INT,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_topicprogresstrackers (301 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_topicprogresstrackers', 'U') IS NOT NULL DROP TABLE bronze.mongo_topicprogresstrackers;
GO
CREATE TABLE bronze.mongo_topicprogresstrackers (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    userId              NVARCHAR(50),
    topicId             NVARCHAR(50),
    subjectProgressId   NVARCHAR(50),
    schoolId            NVARCHAR(50),
    sectionId           NVARCHAR(50),
    progress            DECIMAL(10,4),
    createdAt           DATETIME2,
    updatedAt           DATETIME2,
    __v                 INT,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_sectionprogresstrackers (487 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_sectionprogresstrackers', 'U') IS NOT NULL DROP TABLE bronze.mongo_sectionprogresstrackers;
GO
CREATE TABLE bronze.mongo_sectionprogresstrackers (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    userId              NVARCHAR(50),
    sectionType         NVARCHAR(50),
    schoolId            NVARCHAR(50),
    sectionTypeId       NVARCHAR(50),
    progress            INT,
    createdAt           DATETIME2,
    updatedAt           DATETIME2,
    __v                 INT,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_subjectprogresstrackers (367 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_subjectprogresstrackers', 'U') IS NOT NULL DROP TABLE bronze.mongo_subjectprogresstrackers;
GO
CREATE TABLE bronze.mongo_subjectprogresstrackers (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    userId              NVARCHAR(50),
    subjectId           NVARCHAR(50),
    sectionId           NVARCHAR(50),
    schoolId            NVARCHAR(50),
    progress            DECIMAL(10,4),
    dayId               NVARCHAR(50),
    classificationId    NVARCHAR(50),
    createdAt           DATETIME2,
    updatedAt           DATETIME2,
    __v                 INT,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_userprogresstrackers (375 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_userprogresstrackers', 'U') IS NOT NULL DROP TABLE bronze.mongo_userprogresstrackers;
GO
CREATE TABLE bronze.mongo_userprogresstrackers (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    userId              NVARCHAR(50),
    syllabus            NVARCHAR(50),
    educationLevel      NVARCHAR(50),
    educationYear       NVARCHAR(50),
    educationPeriod     NVARCHAR(50),
    schoolId            NVARCHAR(50),
    progress            INT,
    createdAt           DATETIME2,
    updatedAt           DATETIME2,
    __v                 INT,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_views (1,045 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_views', 'U') IS NOT NULL DROP TABLE bronze.mongo_views;
GO
CREATE TABLE bronze.mongo_views (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    userId              NVARCHAR(50),
    resourceId          NVARCHAR(50),
    count               INT,
    createdAt           DATETIME2,
    updatedAt           DATETIME2,
    __v                 INT,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_tutors (315 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_tutors', 'U') IS NOT NULL DROP TABLE bronze.mongo_tutors;
GO
CREATE TABLE bronze.mongo_tutors (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    userId              NVARCHAR(50),
    subjects            NVARCHAR(MAX),
    resources           NVARCHAR(MAX),
    isPrivatePractice   BIT,
    isAgreeTermsOfUse   BIT,
    isVerified          BIT,
    isAgreed            BIT,
    schoolAcceptStatus  NVARCHAR(50),
    boosted             BIT,
    boostLevel          INT,
    boostExpiryDate     DATETIME2,
    educationLevel      NVARCHAR(50),
    syllabus            NVARCHAR(50),
    bio                 NVARCHAR(MAX),
    access              NVARCHAR(MAX),
    revenue             NVARCHAR(MAX),
    asEnterReferee      BIT,
    asUploadDocument    BIT,
    createdAt           DATETIME2,
    updatedAt           DATETIME2,
    __v                 INT,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_digipreneursubscriptions (270 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_digipreneursubscriptions', 'U') IS NOT NULL DROP TABLE bronze.mongo_digipreneursubscriptions;
GO
CREATE TABLE bronze.mongo_digipreneursubscriptions (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    userId              NVARCHAR(50),
    transactionId       NVARCHAR(50),
    digipreneurId       NVARCHAR(50),
    courseLevelGroups   NVARCHAR(MAX),
    createdAt           DATETIME2,
    updatedAt           DATETIME2,
    __v                 INT,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_planitems (10 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_planitems', 'U') IS NOT NULL DROP TABLE bronze.mongo_planitems;
GO
CREATE TABLE bronze.mongo_planitems (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    name                NVARCHAR(255),
    price               NVARCHAR(50),
    userId              NVARCHAR(50),
    text                NVARCHAR(MAX),
    subText             NVARCHAR(MAX),
    coverImage          NVARCHAR(MAX),
    smallCoverImage     NVARCHAR(MAX),
    bg                  NVARCHAR(100),
    textColor           NVARCHAR(50),
    dashboard           NVARCHAR(MAX),
    createdAt           DATETIME2,
    updatedAt           DATETIME2,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_plans (8 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_plans', 'U') IS NOT NULL DROP TABLE bronze.mongo_plans;
GO
CREATE TABLE bronze.mongo_plans (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    title               NVARCHAR(255),
    userId              NVARCHAR(50),
    planItems           NVARCHAR(MAX),
    masterPrice         NVARCHAR(50),
    useMasterPrice      BIT,
    disabled            BIT,
    duration            NVARCHAR(50),
    price               INT,
    resources           NVARCHAR(MAX),
    subscriptionType    NVARCHAR(50),
    createdAt           DATETIME2,
    updatedAt           DATETIME2,
    __v                 INT,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_dayprogresstrackers (207 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_dayprogresstrackers', 'U') IS NOT NULL DROP TABLE bronze.mongo_dayprogresstrackers;
GO
CREATE TABLE bronze.mongo_dayprogresstrackers (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    userId              NVARCHAR(50),
    dayId               NVARCHAR(50),
    levelId             NVARCHAR(50),
    levelGroupId        NVARCHAR(50),
    schoolId            NVARCHAR(50),
    sectionId           NVARCHAR(50),
    classificationId    NVARCHAR(50),
    progress            INT,
    createdAt           DATETIME2,
    updatedAt           DATETIME2,
    __v                 INT,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_educationyearandperiods (62 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_educationyearandperiods', 'U') IS NOT NULL DROP TABLE bronze.mongo_educationyearandperiods;
GO
CREATE TABLE bronze.mongo_educationyearandperiods (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    yearId              NVARCHAR(50),
    periodId            NVARCHAR(50),
    createdAt           DATETIME2,
    updatedAt           DATETIME2,
    __v                 INT,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_transactions (16,869 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_transactions', 'U') IS NOT NULL DROP TABLE bronze.mongo_transactions;
GO
CREATE TABLE bronze.mongo_transactions (
    _id                        NVARCHAR(50)  NOT NULL PRIMARY KEY,
    sender                     NVARCHAR(50),
    userId                     NVARCHAR(50),
    paymentId                  NVARCHAR(100),
    amount                     DECIMAL(15,2),
    method                     NVARCHAR(50),
    paymentType                NVARCHAR(50),
    merchant                   NVARCHAR(100),
    status                     NVARCHAR(50),
    isUsed                     BIT,
    schoolId                   NVARCHAR(50),
    item                       NVARCHAR(MAX),
    item_name                  NVARCHAR(255),
    item_quantity              INT,
    item_id                    NVARCHAR(50),
    item_subscriptionId        NVARCHAR(50),
    item_subscribedPlanItemsId NVARCHAR(50),
    item_eventId               NVARCHAR(50),
    item_userId                NVARCHAR(50),
    item_school                NVARCHAR(255),
    item_schoolId              NVARCHAR(50),
    item_tutorId               NVARCHAR(50),
    item_metaData              NVARCHAR(MAX),
    meta                       NVARCHAR(MAX),
    createdAt                  DATETIME2,
    updatedAt                  DATETIME2,
    __v                        INT,
    ingestion_timestamp        DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_students (1,656 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_students', 'U') IS NOT NULL DROP TABLE bronze.mongo_students;
GO
CREATE TABLE bronze.mongo_students (
    _id                           NVARCHAR(50)  NOT NULL PRIMARY KEY,
    userId                        NVARCHAR(50),
    subscription                  NVARCHAR(MAX),
    appMode                       NVARCHAR(50),
    contentType                   NVARCHAR(50),
    access                        NVARCHAR(MAX),
    chatPeriod_startTime          NVARCHAR(10),
    chatPeriod_endTime            NVARCHAR(10),
    toggleChat                    BIT,
    educationLevel                NVARCHAR(50),
    syllabus                      NVARCHAR(50),
    educationPeriod               NVARCHAR(50),
    educationYear                 NVARCHAR(50),
    schoolAcceptStatus            NVARCHAR(50),
    hasPaidForSuperTask           BIT,
    superTasks                    NVARCHAR(MAX),
    school                        NVARCHAR(255),
    schoolProfile_syllabus        NVARCHAR(50),
    schoolProfile_educationLevel  NVARCHAR(50),
    schoolProfile_educationYear   NVARCHAR(50),
    schoolProfile_educationPeriod NVARCHAR(50),
    revenue                       NVARCHAR(MAX),
    createdAt                     DATETIME2,
    updatedAt                     DATETIME2,
    __v                           INT,
    ingestion_timestamp           DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_schools (13 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_schools', 'U') IS NOT NULL DROP TABLE bronze.mongo_schools;
GO
CREATE TABLE bronze.mongo_schools (
    _id                      NVARCHAR(50)  NOT NULL PRIMARY KEY,
    institutionName          NVARCHAR(255),
    institutionAddress       NVARCHAR(MAX),
    email                    NVARCHAR(255),
    phoneNumber              NVARCHAR(50),
    imageUrl                 NVARCHAR(MAX),
    alias                    NVARCHAR(255),
    country                  NVARCHAR(100),
    state                    NVARCHAR(100),
    location                 NVARCHAR(255),
    address                  NVARCHAR(MAX),
    resources                NVARCHAR(MAX),
    revenue                  NVARCHAR(MAX),
    isVerified               BIT,
    isUploadedDoc            BIT,
    isProfessional           BIT,
    isBlocked                BIT,
    verified                 BIT,
    status                   NVARCHAR(50),
    defaultAdmin             NVARCHAR(50),
    lastLoginDate            DATETIME2,
    firstName                NVARCHAR(100),
    lastName                 NVARCHAR(100),
    enableRGCounsellor       BIT,
    enableRGMarketplace      BIT,
    enableRGTeachatBoosting  BIT,
    enableRGTeachatGroup     BIT,
    enableRGTeachatSingle    BIT,
    enableRGTeachatSuperTask BIT,
    createdAt                DATETIME2,
    updatedAt                DATETIME2,
    __v                      INT,
    ingestion_timestamp      DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_digipreneurs (15 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_digipreneurs', 'U') IS NOT NULL DROP TABLE bronze.mongo_digipreneurs;
GO
CREATE TABLE bronze.mongo_digipreneurs (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    title               NVARCHAR(255),
    description         NVARCHAR(MAX),
    image               NVARCHAR(MAX),
    sponsor             NVARCHAR(100),
    slots               INT,
    funding             NVARCHAR(10),
    author              NVARCHAR(50),
    isPublished         BIT,
    paymentOption       NVARCHAR(50),
    amount              INT,
    certificateOption   NVARCHAR(50),
    school              NVARCHAR(50),
    publicView          NVARCHAR(10),
    age                 INT,
    minimumScore        INT,
    createdAt           DATETIME2,
    updatedAt           DATETIME2,
    __v                 INT,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_digipreneurparticipants (270 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_digipreneurparticipants', 'U') IS NOT NULL DROP TABLE bronze.mongo_digipreneurparticipants;
GO
CREATE TABLE bronze.mongo_digipreneurparticipants (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    userId              NVARCHAR(50),
    digipreneurId       NVARCHAR(50),
    createdAt           DATETIME2,
    updatedAt           DATETIME2,
    __v                 INT,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_classes (16 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_classes', 'U') IS NOT NULL DROP TABLE bronze.mongo_classes;
GO
CREATE TABLE bronze.mongo_classes (
    _id                   NVARCHAR(50)  NOT NULL PRIMARY KEY,
    classType             NVARCHAR(50),
    mode                  NVARCHAR(50),
    classTitle            NVARCHAR(255),
    subjectId             NVARCHAR(50),
    description           NVARCHAR(MAX),
    educationyearId       NVARCHAR(50),
    startDateTimeString   NVARCHAR(100),
    endDateTimeString     NVARCHAR(100),
    startDateTimeIso      NVARCHAR(100),
    endDateTimeIso        NVARCHAR(100),
    tutorId               NVARCHAR(50),
    learnerIds            NVARCHAR(MAX),
    conversationId        NVARCHAR(50),
    amount                DECIMAL(12,2),
    taskIds               NVARCHAR(MAX),
    eventId               NVARCHAR(MAX),
    status                NVARCHAR(50),
    streamTime            NVARCHAR(50),
    isLive                BIT,
    classLink             NVARCHAR(MAX),
    createdAt             DATETIME2,
    updatedAt             DATETIME2,
    __v                   INT,
    ingestion_timestamp   DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_subscriptionhistories (540 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_subscriptionhistories', 'U') IS NOT NULL DROP TABLE bronze.mongo_subscriptionhistories;
GO
CREATE TABLE bronze.mongo_subscriptionhistories (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    userId              NVARCHAR(50),
    history             NVARCHAR(MAX),
    createdAt           DATETIME2,
    updatedAt           DATETIME2,
    __v                 INT,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_tasks (9,030 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_tasks', 'U') IS NOT NULL DROP TABLE bronze.mongo_tasks;
GO
CREATE TABLE bronze.mongo_tasks (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    author              NVARCHAR(50),
    school              NVARCHAR(50),
    instruction         NVARCHAR(MAX),
    subject             NVARCHAR(50),
    subjectTitle        NVARCHAR(255),
    educationLevels     NVARCHAR(MAX),
    educationYear       NVARCHAR(MAX),
    educationPeriod     NVARCHAR(MAX),
    isSuperTask         BIT,
    isTopicTask         BIT,
    isClassTask         BIT,
    isDigiTask          BIT,
    isTutorTask         BIT,
    hasSbsg             BIT,
    isPublished         BIT,
    estimatedTime       INT,
    learnerIds          NVARCHAR(MAX),
    [default]           NVARCHAR(MAX),
    userPaymentId       NVARCHAR(MAX),
    topicId             NVARCHAR(50),
    syllabus            NVARCHAR(50),
    deadline            DATETIME2,
    participants        NVARCHAR(MAX),
    iaDigiTask          BIT,
    title               NVARCHAR(255),
    time                NVARCHAR(50),
    professionalId      NVARCHAR(50),
    amount              DECIMAL(12,2),
    allowRetake         BIT,
    priceForSuperTask   DECIMAL(12,2),
    classMode           NVARCHAR(50),
    createdAt           DATETIME2,
    updatedAt           DATETIME2,
    __v                 INT,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_courselevelgroups (29 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_courselevelgroups', 'U') IS NOT NULL DROP TABLE bronze.mongo_courselevelgroups;
GO
CREATE TABLE bronze.mongo_courselevelgroups (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    digipreneurId       NVARCHAR(50),
    title               NVARCHAR(255),
    createdBy           NVARCHAR(50),
    addCertificate      BIT,
    amount              INT,
    createdAt           DATETIME2,
    updatedAt           DATETIME2,
    __v                 INT,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- bronze.mongo_syllabuses (9 docs)
-- ============================================================
IF OBJECT_ID('bronze.mongo_syllabuses', 'U') IS NOT NULL DROP TABLE bronze.mongo_syllabuses;
GO
CREATE TABLE bronze.mongo_syllabuses (
    _id                 NVARCHAR(50)  NOT NULL PRIMARY KEY,
    title               NVARCHAR(255),
    icon                NVARCHAR(MAX),
    country             NVARCHAR(100),
    author              NVARCHAR(50),
    school              NVARCHAR(50),
    isPublished         BIT,
    createdAt           DATETIME2,
    updatedAt           DATETIME2,
    __v                 INT,
    ingestion_timestamp DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================
-- VERIFICATION
-- Run this after executing the script
-- Should return 28 rows
-- ============================================================
SELECT
    TABLE_SCHEMA,
    TABLE_NAME,
    (
        SELECT COUNT(*)
        FROM INFORMATION_SCHEMA.COLUMNS c
        WHERE c.TABLE_SCHEMA = t.TABLE_SCHEMA
          AND c.TABLE_NAME   = t.TABLE_NAME
    ) AS column_count
FROM INFORMATION_SCHEMA.TABLES t
WHERE TABLE_SCHEMA = 'bronze'
ORDER BY TABLE_NAME;
