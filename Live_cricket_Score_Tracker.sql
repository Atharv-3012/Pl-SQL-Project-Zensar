-- Teams Table
CREATE TABLE Teams (
    team_id NUMBER PRIMARY KEY,
    team_name VARCHAR2(100) NOT NULL
);

-- Players Table
CREATE TABLE Players (
    player_id NUMBER PRIMARY KEY,
    player_name VARCHAR2(100) NOT NULL,
    team_id NUMBER REFERENCES Teams(team_id)
);

-- Matches Table
CREATE TABLE Matches (
    match_id NUMBER PRIMARY KEY,
    team1_id NUMBER REFERENCES Teams(team_id),
    team2_id NUMBER REFERENCES Teams(team_id),
    match_date DATE,
    venue VARCHAR2(100)
);

-- Scores Table
CREATE TABLE Scores (
    score_id NUMBER PRIMARY KEY,
    match_id NUMBER REFERENCES Matches(match_id),
    player_id NUMBER REFERENCES Players(player_id),
    runs NUMBER DEFAULT 0,
    balls NUMBER DEFAULT 0,
    fours NUMBER DEFAULT 0,
    sixes NUMBER DEFAULT 0,
    timestamp DATE DEFAULT SYSDATE
);


-- Insert Teams
INSERT INTO Teams VALUES (1, 'Team A');
INSERT INTO Teams VALUES (2, 'Team B');

-- Insert Players
INSERT INTO Players VALUES (1, 'Player 1', 1);
INSERT INTO Players VALUES (2, 'Player 2', 1);
INSERT INTO Players VALUES (3, 'Player 3', 2);
INSERT INTO Players VALUES (4, 'Player 4', 2);

-- Insert Matches
INSERT INTO Matches VALUES (1, 1, 2, TO_DATE('2025-01-08', 'YYYY-MM-DD'), 'Stadium A');

-- Insert Scores
INSERT INTO Scores VALUES (1, 1, 1, 45, 30, 4, 2, SYSDATE);
INSERT INTO Scores VALUES (2, 1, 3, 55, 35, 5, 3, SYSDATE);

----------------------1. Procedure to Update Player Scores------------------------
CREATE OR REPLACE PROCEDURE update_score(
    p_match_id IN NUMBER,
    p_player_id IN NUMBER,
    p_runs IN NUMBER,
    p_balls IN NUMBER,
    p_fours IN NUMBER,
    p_sixes IN NUMBER
) AS
BEGIN
    UPDATE Scores
    SET 
        runs = runs + p_runs,
        balls = balls + p_balls,
        fours = fours + p_fours,
        sixes = sixes + p_sixes,
        timestamp = SYSDATE
    WHERE match_id = p_match_id AND player_id = p_player_id;

    COMMIT;
END;
/

----------------------------2. Function to Get Live Score------------------------
CREATE OR REPLACE FUNCTION get_live_score(p_match_id IN NUMBER)
RETURN VARCHAR2 AS
    v_score VARCHAR2(100);
    v_team1_runs NUMBER := 0;
    v_team2_runs NUMBER := 0;
BEGIN
    SELECT SUM(runs)
    INTO v_team1_runs
    FROM Scores s
    JOIN Players p ON s.player_id = p.player_id
    WHERE s.match_id = p_match_id AND p.team_id = 
        (SELECT team1_id FROM Matches WHERE match_id = p_match_id);

    SELECT SUM(runs)
    INTO v_team2_runs
    FROM Scores s
    JOIN Players p ON s.player_id = p.player_id
    WHERE s.match_id = p_match_id AND p.team_id = 
        (SELECT team2_id FROM Matches WHERE match_id = p_match_id);

    v_score := 'Team A: ' || v_team1_runs || ' | Team B: ' || v_team2_runs;
    RETURN v_score;
END;
/

SELECT get_live_score(1) FROM dual;


---------------------------3. Procedure to Display Match Details-------------------
CREATE OR REPLACE PROCEDURE show_match_details(p_match_id IN NUMBER) AS
    v_match_info VARCHAR2(200);
BEGIN
    SELECT 'Match between ' || t1.team_name || ' and ' || t2.team_name || 
           ' at ' || m.venue || ' on ' || TO_CHAR(m.match_date, 'DD-MON-YYYY')
    INTO v_match_info
    FROM Matches m
    JOIN Teams t1 ON m.team1_id = t1.team_id
    JOIN Teams t2 ON m.team2_id = t2.team_id
    WHERE m.match_id = p_match_id;

    DBMS_OUTPUT.PUT_LINE(v_match_info);
END;
/

BEGIN
    show_match_details(1);
END;


--------------------4. Trigger to Log Score Updates--------------------
CREATE OR REPLACE TRIGGER log_score_update
AFTER UPDATE ON Scores
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Score updated for Player ID ' || :OLD.player_id || 
                         ' in Match ID ' || :OLD.match_id || '.');
    DBMS_OUTPUT.PUT_LINE('Previous Runs: ' || :OLD.runs || ', New Runs: ' || :NEW.runs);
END;
/

