# Pl-SQL-Project-Zensar
# Cricket Score Management System - PL/SQL Project

## Project Information
- **Name:** Wadekar Atharv Vinayak
- **Year:** T.E Computer Engineering
- **Contact:** atharvawadekar3012@gmail.com

## Description
The Live Cricket Score Management System is a PL/SQL-based project designed to manage and display real-time cricket match scores. The system leverages PL/SQL to handle large volumes of data related to players, teams, matches, and scores efficiently. It provides a user-friendly interface for dynamic input and retrieval of match details, enabling effective score tracking and match management.

## Features
- **Dynamic Score Updates:** Update player scores in real-time.
- **Team and Player Data Management:** Maintain records of teams and players.
- **Match Information Management:** Store and display match details.
- **Live Score Retrieval:** Fetch current match scores.

## Technical Stack
- **Database:** Oracle Database
- **Programming Language:** PL/SQL

## Database Schema
The system consists of the following tables:

1. **Teams:**
    - `team_id`: Number (Primary Key)
    - `team_name`: Varchar2(100) (Not Null)

2. **Players:**
    - `player_id`: Number (Primary Key)
    - `player_name`: Varchar2(100) (Not Null)
    - `team_id`: Number (Foreign Key referencing Teams.team_id)

3. **Matches:**
    - `match_id`: Number (Primary Key)
    - `team1_id`: Number (Foreign Key referencing Teams.team_id)
    - `team2_id`: Number (Foreign Key referencing Teams.team_id)
    - `match_date`: Date
    - `venue`: Varchar2(100)

4. **Scores:**
    - `score_id`: Number (Primary Key)
    - `match_id`: Number (Foreign Key referencing Matches.match_id)
    - `player_id`: Number (Foreign Key referencing Players.player_id)
    - `runs`: Number (Default 0)
    - `balls`: Number (Default 0)
    - `fours`: Number (Default 0)
    - `sixes`: Number (Default 0)
    - `timestamp`: Date (Default SYSDATE)



