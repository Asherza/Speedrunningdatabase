--Written by Asher Straubing
--Scripts at bottem can be ran on an SQL database
-- 4/21/2017

-- Here I droped the tables in order of Child then parent. 
DROP TABLE Post CASCADE CONSTRAINTS;
DROP TABLE Topic CASCADE CONSTRAINTS;
DROP TABLE Forum CASCADE CONSTRAINTS;
DROP TABLE Run CASCADE CONSTRAINTS;
DROP TABLE Category CASCADE CONSTRAINTS;
DROP TABLE Moderator CASCADE CONSTRAINTS;
DROP TABLE users CASCADE CONSTRAINTS;
DROP TABLE Game CASCADE CONSTRAINTS;

--Here I create the Users table with the primary key usersId.
--Note: I tried to use User as a table but it did not let us so I had to use the plural version users
CREATE TABLE Users
(
	usersId NUMBER(15) NOT NULL,
	usersName VARCHAR2(25),
	usersEmail VARCHAR2(25),
	usersPassword VARCHAR2(15),
	usersCountry VARCHAR2(25),
	CONSTRAINT users_usersID_pk PRIMARY KEY (usersId) -- create PK constraint
);

--Create the Category table with the PK being category ID
CREATE TABLE Category
(
	categoryId NUMBER(15) NOT NULL,
	categoryType VARCHAR2(25),
	categoryDescription VARCHAR2(250),
	CONSTRAINT Category_CategoryId_pk PRIMARY KEY (categoryId) -- create PK constraint
); 

--Create One of the main tables Game
CREATE TABLE Game
(
	gameId NUMBER(15) NOT NULL,
	gameName VARCHAR2(50),
	gameGenre VARCHAR(25),
	gameReleaseDate DATE,
	gamePlatform VARCHAR2(25),
	gameLogo BLOB,
	CONSTRAINT Game_GameID_pk PRIMARY KEY (gameId) -- create The PK contstraint

);
-- Create one of the second level tables Run that links Users, Game, and Category
CREATE TABLE Run
(
	runId NUMBER(15) NOT NULL,
	usersId NUMBER(15) NOT NULL,
	gameId NUMBER(15) NOT NULL,
	categoryId NUMBER(15) NOT NULL,
	runTime VARCHAR2(15),
	runDate DATE,
	CONSTRAINT Run_runId_pk PRIMARY KEY (runId), -- create the PK of the table 
	CONSTRAINT Run_usersID_fk FOREIGN KEY (usersId) REFERENCES users(usersId), -- Create a FK relationship for users
	CONSTRAINT Run_gameID_fk FOREIGN KEY (gameId) REFERENCES Game(GameId), -- Create a FK relationship for Game
	CONSTRAINT Run_categoryID_fk FOREIGN KEY (CategoryId) REFERENCES Category(CategoryId) -- Create a FK relationship for Category
);
--Create the Moderator table 
CREATE TABLE Moderator
(
	usersId NUMBER(15) NOT NULL,
	gameId NUMBER(15) NOT NULL,
	modPriv NUMBER(1),
	CONSTRAINT Moderator_usersId_fk FOREIGN KEY (usersId) REFERENCES users(usersId), -- Create the FK relationship with Users
	CONSTRAINT Moderator_gameId_fk FOREIGN KEY (gameId) REFERENCES Game(GameId), -- Create the FK relationship with Game
	CONSTRAINT Moderator_pk PRIMARY KEY (usersId, gameId) -- uses both the FK to create a composite primary key
);
--create the forum table
CREATE TABLE Forum
(
	forumId NUMBER(15) NOT NULL,
	gameId NUMBER(15) NOT NULL,
	forumDOC DATE,
	forumName VARCHAR2(25),
	forumDescription VARCHAR2(250),
	CONSTRAINT Forum_forumId_pk PRIMARY KEY (forumId), -- Create the PK of forum 
	CONSTRAINT Forum_gameId_fk FOREIGN KEY (gameId) REFERENCES Game(GameId) -- create the fk relationship with Game
);
-- Create the Topic table 
CREATE TABLE Topic
(
	topicId NUMBER(15) NOT NULL,
	forumId NUMBER(15) NOT NULL,
	topicDOC DATE,
	topicTitle VARCHAR2(25),
	topicDescription VARCHAR2(250),
	CONSTRAINT Topic_topicId_pk PRIMARY KEY (topicId), -- Create the pk for forum
	CONSTRAINT Topic_forumId_fk FOREIGN KEY (forumId) REFERENCES Forum(forumId) -- Create the FK relationship with Forum 
);
-- Create the post table 
CREATE TABLE Post
(
	postId NUMBER(15) NOT NULL,
	usersId NUMBER(15) NOT NULL, 
	topicId NUMBER(15) NOT NULL,
	postDate DATE,
	postContent VARCHAR2(250),
	CONSTRAINT Post_postId_pk PRIMARY KEY (postId), -- Create the PK of Post 	
	CONSTRAINT Post_usersId_fk FOREIGN KEY (usersId) REFERENCES users(usersId) -- create the FK relationship with Users
);

--This is a inner join statement that pulls the username the game name, categorytype, and the runtime from three tables

SELECT u.USERSNAME,  g.GAMENAME, c.CATEGORYTYPE, r.RUNTIME
FROM RUN r -- Pulls all the info from the run table
JOIN USERS u ON r.usersid = u.usersid -- Joins users on the user id
JOIN GAME g on r.gameid = g.gameid -- Joins game on the game id
JOIN CATEGORY c on r.categoryId = c.categoryid --Joings category on Category ID
ORDER BY CATEGORYTYPE; -- We order by Categotrype to filter out the runs 

--This Self join will find all the users that have the same username and password
SELECT u.USERSNAME, j.USERSPASSWORD 
FROM USERS u, USERS j
WHERE u.USERSNAME = j.USERSPASSWORD;--Search where the usernames and the passwords are the same in the table 


