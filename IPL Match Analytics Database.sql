-- CREATE DATABASE
CREATE DATABASE IPLDB;
USE IPLDB;
 
-- CREATE TEAMS TABLE
CREATE TABLE Teams(
	TeamID INT PRIMARY KEY auto_increment,
    TeamName varchar(50) UNIQUE,
    City VARCHAR(50),
    Coach VARCHAR(50),
    HomeStadium VARCHAR(50),
    Owner VARCHAR(100),
    ChampionshipsWon INT DEFAULT 0
);
select * from teams;

-- Create Players Table
CREATE TABLE Players (
    PlayerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Age INT,
    Role ENUM('Batsman', 'Bowler', 'All-rounder', 'Wicket-keeper'),
    Nationality VARCHAR(50),
    BattingAverage DECIMAL(5,2),
    BowlingAverage DECIMAL(5,2),
    StrikeRate DECIMAL(5,2),
    EconomyRate DECIMAL(5,2),
    TeamID INT,
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);
SELECT * FROM Players;

-- Create Matches Table
CREATE TABLE Matches (
    MatchID INT PRIMARY KEY AUTO_INCREMENT,
    MatchDate DATE,
    Venue VARCHAR(100),
    Team1 INT,
    Team2 INT,
    Winner INT,
    Umpire1 VARCHAR(50),
    Umpire2 VARCHAR(50),
    FOREIGN KEY (Team1) REFERENCES Teams(TeamID),
    FOREIGN KEY (Team2) REFERENCES Teams(TeamID),
    FOREIGN KEY (Winner) REFERENCES Teams(TeamID)
);
select * from matches;

-- Create Scores Table
CREATE TABLE Scores (
    MatchID INT,
    PlayerID INT,
    Runs INT,
    BallsFaced INT,
    Fours INT,
    Sixes INT,
    StrikeRate DECIMAL(5,2),
    PRIMARY KEY (MatchID, PlayerID),
    FOREIGN KEY (MatchID) REFERENCES Matches(MatchID),
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID)
);
truncate table scores;

-- Create Bowling Performance Table
CREATE TABLE Bowling (
    MatchID INT,
    PlayerID INT,
    Overs DECIMAL(3,1),
    RunsConceded INT,
    Wickets INT,
    Economy DECIMAL(5,2),
    PRIMARY KEY (MatchID, PlayerID),
    FOREIGN KEY (MatchID) REFERENCES Matches(MatchID),
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID)
);
select * from bowling;

-- Insert Teams
INSERT INTO Teams (TeamName, City, Coach, HomeStadium, Owner, ChampionshipsWon) VALUES
('Mumbai Indians', 'Mumbai', 'Mark Boucher', 'Wankhede Stadium', 'Reliance', 5),
('Chennai Super Kings', 'Chennai', 'Stephen Fleming', 'M. A. Chidambaram Stadium', 'India Cements', 4),
('Royal Challengers Bangalore', 'Bangalore', 'Sanjay Bangar', 'M. Chinnaswamy Stadium', 'United Spirits', 0);
select * from teams;

-- Insert Players
INSERT INTO Players (Name, Age, Role, Nationality, BattingAverage, BowlingAverage, StrikeRate, EconomyRate, TeamID) VALUES
('Virat Kohli', 35, 'Batsman', 'India', 53.25, NULL, 138.5, NULL, 3),
('MS Dhoni', 42, 'Wicket-keeper', 'India', 40.5, NULL, 135.2, NULL, 2),
('Jasprit Bumrah', 30, 'Bowler', 'India', NULL, 24.3, NULL, 6.5, 1);
select * from players;

-- Insert Matches
INSERT INTO Matches (MatchDate, Venue, Team1, Team2, Winner, Umpire1, Umpire2) VALUES
('2024-04-01', 'Wankhede Stadium', 1, 2, 1, 'Nitin Menon', 'Marais Erasmus'),
('2024-04-02', 'M. A. Chidambaram Stadium', 2, 3, 2, 'Anil Chaudhary', 'Richard Illingworth');
select * from matches;

-- Insert Scores
INSERT INTO Scores (MatchID, PlayerID, Runs, BallsFaced, Fours, Sixes, StrikeRate) VALUES
(1, 1, 75, 50, 8, 3, 150.0),
(2, 2, 45, 30, 5, 2, 150.0);
select * from scores;

-- Insert Bowling Performance
INSERT INTO Bowling (MatchID, PlayerID, Overs, RunsConceded, Wickets, Economy) VALUES
(1, 3, 4, 30, 2, 7.5);
select * from bowling;

-- Queries in database
-- Retrieve all players from the teams
select * from players;

-- Top run scorers
select p.name, sum(s.runs) as TotalRuns
from scores s 
join players p using (playerid)
group by s.playerid
order by TotalRuns desc
limit 5;

-- Most Wickets Taken By A Bowler
select p.Name, sum(b.wickets) as TotalWickets
from bowling b
join players p using(playerid)
group by playerid
order by TotalWickets desc
limit 2;
 
 -- Win Percentage Of A Team
SELECT t.TeamName, COUNT(m.Winner) AS MatchesWon,
       (COUNT(m.Winner) / (SELECT COUNT(*) FROM Matches WHERE Team1 = t.TeamID OR Team2 = t.TeamID)) * 100 AS WinPercentage
FROM Matches m
JOIN Teams t ON m.Winner = t.TeamID
GROUP BY t.TeamID;





