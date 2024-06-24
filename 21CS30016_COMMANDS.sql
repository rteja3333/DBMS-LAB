-- Create tables without foreign keys
CREATE TABLE student (
    id SERIAL PRIMARY KEY,
    roll VARCHAR(20),
    Name VARCHAR(100),
    dept VARCHAR(100)
);

CREATE TABLE role (
    RID SERIAL PRIMARY KEY,
    Rname VARCHAR(100),
    description TEXT
);

CREATE TABLE event (
    EID SERIAL PRIMARY KEY,
    ENAME VARCHAR(100),
    TYPE VARCHAR(50),
    date DATE
);

CREATE TABLE college (
    name VARCHAR(100),
    location VARCHAR(100),
    PRIMARY KEY (name) -- Assuming name is unique
);

CREATE TABLE participant (
    PID SERIAL PRIMARY KEY,
    name VARCHAR(100),
    event_id INTEGER, -- No foreign key yet
    college_name VARCHAR(100) -- No foreign key yet
);

CREATE TABLE volunteer (
    id SERIAL PRIMARY KEY,
    roll VARCHAR(20)

);

-- Add foreign keys using ALTER TABLE
ALTER TABLE student
ADD COLUMN rid INTEGER REFERENCES role(RID);

ALTER TABLE student
ADD COLUMN eid INTEGER REFERENCES event(EID);

ALTER TABLE event
ADD COLUMN volunteer_id VARCHAR(20) REFERENCES volunteer(roll);

ALTER TABLE participant
ADD CONSTRAINT fk_event_id FOREIGN KEY (event_id) REFERENCES event(EID);

ALTER TABLE participant
ADD CONSTRAINT fk_college_name FOREIGN KEY (college_name) REFERENCES college(name);

ALTER TABLE volunteer
ADD COLUMN eid INTEGER REFERENCES event(EID);

INSERT INTO role (Rname, description) VALUES 
('secretary', 'Responsible for administrative tasks and record keeping'),
('associate member', 'Has limited responsibilities within the organization'),
('head', 'head of the whole event'),
('member', 'Regular member of the organization'),
('treasurer', 'Responsible for financial matters within the organization');

INSERT INTO college (name, location) VALUES 
('IITB', 'Mumbai'),
('IITKGP', 'Kharagpur'),
('IITM', 'Chennai'),
('IITK', 'Kanpur'),
('IITD', 'Delhi'),
('IITR', 'Roorkee');

INSERT INTO event (ENAME, TYPE, date) VALUES 
('intro event', 'Introduction', '2024-01-01'),
('megaevent', 'Mega Event', '2024-02-15'),
('closing event', 'Closing Ceremony', '2024-03-01'),
('workshop', 'Educational Workshop', '2024-04-15'),
('cultural event', 'Cultural Program', '2024-05-01');


INSERT INTO student (roll, Name, dept, rid, eid)
VALUES 
('CSE001', 'Amit Kumar', 'CSE', (SELECT RID FROM role WHERE Rname = 'associate member'), (SELECT EID FROM event WHERE ENAME = 'intro event')),
('CSE002', 'Priya Patel', 'CSE', (SELECT RID FROM role WHERE Rname = 'secretary'), (SELECT EID FROM event WHERE ENAME = 'megaevent')),
('ECE001', 'Rahul Sharma', 'ECE', (SELECT RID FROM role WHERE Rname = 'secretary'), (SELECT EID FROM event WHERE ENAME = 'intro event')),
('ECE002', 'Sneha Gupta', 'ECE', (SELECT RID FROM role WHERE Rname = 'associate member'), (SELECT EID FROM event WHERE ENAME = 'megaevent')),
('EE001', 'Ananya Singh', 'EE', (SELECT RID FROM role WHERE Rname = 'head'), (SELECT EID FROM event WHERE ENAME = 'closing event')),
('EE002', 'Sachin Mishra', 'EE', (SELECT RID FROM role WHERE Rname = 'secretary'), (SELECT EID FROM event WHERE ENAME = 'megaevent')),
('CSE003', 'Rajesh Kumar', 'CSE', (SELECT RID FROM role WHERE Rname = 'member'), (SELECT EID FROM event WHERE ENAME = 'workshop')),
('ECE003', 'Deepika Singh', 'ECE', (SELECT RID FROM role WHERE Rname = 'member'), (SELECT EID FROM event WHERE ENAME = 'cultural event'));

-- Insert additional records for participants with colleges
INSERT INTO participant (name, college_name, event_id)
VALUES 
('Ravi Kumar', 'IITB', (SELECT EID FROM event WHERE ENAME = 'intro event')),
('Sunita Gupta', 'IITKGP', (SELECT EID FROM event WHERE ENAME = 'megaevent')),
('Rajesh Sharma', 'IITM', (SELECT EID FROM event WHERE ENAME = 'closing event')),
('Neha Singh', 'IITK', (SELECT EID FROM event WHERE ENAME = 'intro event')),
('Amit Patel', 'IITB', (SELECT EID FROM event WHERE ENAME = 'closing event')),
('Suresh Verma', 'IITM', (SELECT EID FROM event WHERE ENAME = 'workshop')),
('Rohan Gupta', 'IITR', (SELECT EID FROM event WHERE ENAME = 'cultural event'));

-- Insert records for volunteers with Indian names in English
-- Insert records for volunteers with Indian names in English
INSERT INTO volunteer (roll, eid)
VALUES 
('CSE001', (SELECT EID FROM event WHERE ENAME = 'intro event')),
('CSE002', (SELECT EID FROM event WHERE ENAME = 'megaevent')),
('ECE001', (SELECT EID FROM event WHERE ENAME = 'intro event')),
('ECE002', (SELECT EID FROM event WHERE ENAME = 'megaevent')),
('EE001', (SELECT EID FROM event WHERE ENAME = 'closing event')),
('EE002', (SELECT EID FROM event WHERE ENAME = 'megaevent')),
('CSE003', (SELECT EID FROM event WHERE ENAME = 'workshop')),
('ECE003', (SELECT EID FROM event WHERE ENAME = 'cultural event'));





-- Print contents of the student table
SELECT * FROM student;

-- Print contents of the role table
SELECT * FROM role;

-- Print contents of the event table
SELECT * FROM event;

-- Print contents of the college table
SELECT * FROM college;

-- Print contents of the participant table
SELECT * FROM participant;

-- Print contents of the volunteer table
SELECT * FROM volunteer;

-- DROP TABLE IF EXISTS participant;
-- DROP TABLE IF EXISTS volunteer;
-- DROP TABLE IF EXISTS college;
-- DROP TABLE IF EXISTS event;
-- DROP TABLE IF EXISTS role;
-- DROP TABLE IF EXISTS student;



-- COMMANDS FOR THE GIVEN QUERIES


SELECT roll,name FROM student WHERE eid=(SELECT EID FROM event WHERE ENAME='megaevent');


SELECT roll, name FROM student WHERE eid = (SELECT EID FROM event WHERE ENAME = 'megaevent') AND rid = (SELECT RID FROM role WHERE Rname = 'secretary');


SELECT name FROM participant WHERE college_name='IITB' AND event_id=(SELECT eid FROM event WHERE ENAME='megaevent');


SELECT college_name FROM participant WHERE event_id = (SELECT EID FROM event WHERE ENAME = 'megaevent') GROUP BY college_name HAVING COUNT(*) > 0;


SELECT ename  FROM event WHERE eid IN (  SELECT s.eid    FROM student s  JOIN role r ON s.rid = r.rid    WHERE rname = 'secretary' )GROUP BY ename;


SELECT name FROM student s JOIN volunteer r ON s.roll=r.roll;


SELECT e.ename FROM event e  JOIN student s ON e.eid = s.eid  JOIN volunteer r ON s.roll = r.roll WHERE s.dept = 'CSE';




SELECT college_name
FROM (
    SELECT college_name, COUNT(*) AS participant_count
    FROM participant
    WHERE event_id = (SELECT EID FROM event WHERE ENAME = 'megaevent')
    GROUP BY college_name
) AS college_participant_count
WHERE participant_count = (
    SELECT MAX(participant_count)
    FROM (
        SELECT COUNT(*) AS participant_count
        FROM participant
        WHERE event_id = (SELECT EID FROM event WHERE ENAME = 'megaevent')
        GROUP BY college_name
    ) AS max_counts
)
ORDER BY college_name;






SELECT college_name
FROM (
    SELECT college_name, COUNT(*) AS participant_count
    FROM participant
    GROUP BY college_name
) AS college_participant_count
WHERE participant_count = (
    SELECT MAX(participant_count)
    FROM (
        SELECT COUNT(*) AS participant_count
        FROM participant
        GROUP BY college_name
    ) AS max_counts
)
ORDER BY college_name;





WITH dept_volunteer_counts AS (
    SELECT s.dept, COUNT(*) AS volunteer_count,
           RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
    FROM student s
    JOIN volunteer v ON s.roll = v.roll
    WHERE EXISTS (
        SELECT 1
        FROM participant p
        WHERE p.college_name = 'IITB' AND p.event_id = s.eid
    )
    GROUP BY s.dept
)
SELECT dept
FROM dept_volunteer_counts
WHERE rank = 1;



