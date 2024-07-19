/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 1 of the case study, which means that there'll be more guidance for you about how to 
setup your local SQLite connection in PART 2 of the case study. 

The questions in the case study are exactly the same as with Tier 2. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT name
FROM Facilities
WHERE membercost > 0;

/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT(*) AS Count_of_free_facilities
FROM Facilities
WHERE membercost = 0;

Count_of_free_facilities 	
4

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance
From Facilities
WHERE membercost < (0.20 * monthlymaintenance);

 Full texts 	facid 	name 	membercost 	monthlymaintenance
	Edit Edit 	Copy Copy 	Delete Delete 	0 	Tennis Court 1 	5.0 	200
	Edit Edit 	Copy Copy 	Delete Delete 	1 	Tennis Court 2 	5.0 	200
	Edit Edit 	Copy Copy 	Delete Delete 	2 	Badminton Court 	0.0 	50
	Edit Edit 	Copy Copy 	Delete Delete 	3 	Table Tennis 	0.0 	10
	Edit Edit 	Copy Copy 	Delete Delete 	4 	Massage Room 1 	9.9 	3000
	Edit Edit 	Copy Copy 	Delete Delete 	5 	Massage Room 2 	9.9 	3000
	Edit Edit 	Copy Copy 	Delete Delete 	6 	Squash Court 	3.5 	80
	Edit Edit 	Copy Copy 	Delete Delete 	7 	Snooker Table 	0.0 	15
	Edit Edit 	Copy Copy 	Delete Delete 	8 	Pool Table 	0.0 	15

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT *
FROM Facilities
WHERE facid IN (1, 5);

 Full texts 	facid 	name 	membercost 	guestcost 	initialoutlay 	monthlymaintenance 	priceCategory
	Edit Edit 	Copy Copy 	Delete Delete 	1 	Tennis Court 2 	5.0 	25.0 	8000 	200 	expensive
	Edit Edit 	Copy Copy 	Delete Delete 	5 	Massage Room 2 	9.9 	80.0 	4000 	3000 	expensive

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance,
	CASE
		WHEN monthlymaintenance > 100 THEN 'expensive'
		ELSE 'cheap'
	END AS cost_label
FROM Facilities;

 name 	monthlymaintenance 	cost_label 	
Tennis Court 1 	200 	expensive
Tennis Court 2 	200 	expensive
Badminton Court 	50 	cheap
Table Tennis 	10 	cheap
Massage Room 1 	3000 	expensive
Massage Room 2 	3000 	expensive
Squash Court 	80 	cheap
Snooker Table 	15 	cheap
Pool Table 	15 	cheap


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

SELECT firstname, surname
FROM Members
WHERE joindate = (SELECT MAX(joindate) FROM Members);

firstname 	surname 	
Darren 	Smith

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT CONCAT(m.firstname, ' ', m.surname) AS member_name, f.name AS court_name
FROM Bookings AS b
JOIN Members AS m ON b.bookid = m.memid
JOIN Facilities AS f ON b.bookid = f.facid
WHERE f.name LIKE '%Tennis Court%'
ORDER BY member_name;

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT f.name AS facility_name,
       CONCAT(m.firstname, ' ', m.surname) AS member_name,
       CASE
           WHEN b.memid = 0 THEN b.slots * f.guestcost
           ELSE b.slots * f.membercost
       END AS cost
FROM Bookings AS b
JOIN Members AS m ON b.memid = m.memid
JOIN Facilities AS f ON b.facid = f.facid
WHERE b.starttime >= '2012-09-14 00:00:00' AND b.starttime < '2012-09-15 00:00:00'
HAVING cost > 30
ORDER BY cost DESC;


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT facility_name, member_name, cost
FROM (
    SELECT f.name AS facility_name,
           CONCAT(m.firstname, ' ', m.surname) AS member_name,
           CASE
               WHEN b.memid = 0 THEN b.slots * f.guestcost
               ELSE b.slots * f.membercost
           END AS cost
    FROM Bookings AS b
    JOIN Members AS m ON b.memid = m.memid
    JOIN Facilities AS f ON b.facid = f.facid
    WHERE b.starttime >= '2012-09-14 00:00:00' AND b.starttime < '2012-09-15 00:00:00'
) AS booking_costs
WHERE cost > 30
ORDER BY cost DESC;

/* PART 2: SQLite
/* We now want you to jump over to a local instance of the database on your machine. 

Copy and paste the LocalSQLConnection.py script into an empty Jupyter notebook, and run it. 

Make sure that the SQLFiles folder containing thes files is in your working directory, and
that you haven't changed the name of the .db file from 'sqlite\db\pythonsqlite'.

You should see the output from the initial query 'SELECT * FROM FACILITIES'.

Complete the remaining tasks in the Jupyter interface. If you struggle, feel free to go back
to the PHPMyAdmin interface as and when you need to. 

You'll need to paste your query into value of the 'query1' variable and run the code block again to get an output.
 
QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT facility_name, total_revenue
FROM (
    SELECT f.name AS facility_name,
           SUM(CASE
                   WHEN b.memid = 0 THEN b.slots * f.guestcost
                   ELSE b.slots * f.membercost
               END) AS total_revenue
    FROM Bookings AS b
    JOIN Facilities AS f ON b.facid = f.facid
    GROUP BY f.name
) AS facility_revenues
WHERE total_revenue < 1000
ORDER BY total_revenue;

 Full texts 	facility_name 	total_revenue Ascending
	Edit Edit 	Copy Copy 	Delete Delete 	Table Tennis 	180.0
	Edit Edit 	Copy Copy 	Delete Delete 	Snooker Table 	240.0
	Edit Edit 	Copy Copy 	Delete Delete 	Pool Table 	270.0

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

SELECT m1.surname AS member_surname,
       m1.firstname AS member_firstname,
       m2.surname AS recommender_surname,
       m2.firstname AS recommender_firstname
FROM Members AS m1
LEFT JOIN Members AS m2 ON m1.recommendedby = m2.memid
ORDER BY m1.surname, m1.firstname;

 member_surname 	member_firstname 	recommender_surname 	recommender_firstname 	
Bader 	Florence 	Stibbons 	Ponder
Baker 	Anne 	Stibbons 	Ponder
Baker 	Timothy 	Farrell 	Jemima
Boothe 	Tim 	Rownam 	Tim
Butters 	Gerald 	Smith 	Darren
Coplin 	Joan 	Baker 	Timothy
Crumpet 	Erica 	Smith 	Tracy
Dare 	Nancy 	Joplette 	Janice
Farrell 	David 	NULL	NULL
Farrell 	Jemima 	NULL	NULL
Genting 	Matthew 	Butters 	Gerald
GUEST 	GUEST 	NULL	NULL
Hunt 	John 	Purview 	Millicent
Jones 	David 	Joplette 	Janice
Jones 	Douglas 	Jones 	David
Joplette 	Janice 	Smith 	Darren
Mackenzie 	Anna 	Smith 	Darren
Owen 	Charles 	Smith 	Darren
Pinker 	David 	Farrell 	Jemima
Purview 	Millicent 	Smith 	Tracy
Rownam 	Tim 	NULL	NULL
Rumney 	Henrietta 	Genting 	Matthew
Sarwin 	Ramnaresh 	Bader 	Florence
Smith 	Darren 	NULL	NULL
Smith 	Darren 	NULL	NULL
Smith 	Jack 	Smith 	Darren
Smith 	Tracy 	NULL	NULL
Stibbons 	Ponder 	Tracy 	Burton
Tracy 	Burton 	NULL	NULL
Tupperware 	Hyacinth 	NULL	NULL
Worthington-Smyth 	Henry 	Smith 	Tracy

/* Q12: Find the facilities with their usage by member, but not guests */

SELECT f.name AS facility_name,
       COUNT(b.memid) AS member_usage_count,
       SUM(b.slots) AS total_slots_used
FROM Bookings AS b
JOIN Facilities AS f ON b.facid = f.facid
WHERE b.memid != 0  -- Exclude guest bookings
GROUP BY f.name
ORDER BY facility_name;

 facility_name 	member_usage_count 	total_slots_used 	
Badminton Court 	344 	1086
Massage Room 1 	421 	884
Massage Room 2 	27 	54
Pool Table 	783 	856
Snooker Table 	421 	860
Squash Court 	195 	418
Table Tennis 	385 	794
Tennis Court 1 	308 	957
Tennis Court 2 	276 	882

/* Q13: Find the facilities usage by month, but not guests */

SELECT f.name AS facility_name,
       DATE_FORMAT(b.starttime, '%Y-%m') AS month,
       COUNT(b.memid) AS member_usage_count,
       SUM(b.slots) AS total_slots_used
FROM Bookings AS b
JOIN Facilities AS f ON b.facid = f.facid
WHERE b.memid != 0  -- Exclude guest bookings
GROUP BY f.name, DATE_FORMAT(b.starttime, '%Y-%m')
ORDER BY f.name, month;

 facility_name 	month 	member_usage_count 	total_slots_used 	
Badminton Court 	2012-07 	51 	165
Badminton Court 	2012-08 	132 	414
Badminton Court 	2012-09 	161 	507
Massage Room 1 	2012-07 	77 	166
Massage Room 1 	2012-08 	153 	316
Massage Room 1 	2012-09 	191 	402
Massage Room 2 	2012-07 	4 	8
Massage Room 2 	2012-08 	9 	18
Massage Room 2 	2012-09 	14 	28
Pool Table 	2012-07 	103 	110
Pool Table 	2012-08 	272 	303
Pool Table 	2012-09 	408 	443
Snooker Table 	2012-07 	68 	140
Snooker Table 	2012-08 	154 	316
Snooker Table 	2012-09 	199 	404
Squash Court 	2012-07 	23 	50
Squash Court 	2012-08 	85 	184
Squash Court 	2012-09 	87 	184
Table Tennis 	2012-07 	48 	98
Table Tennis 	2012-08 	143 	296
Table Tennis 	2012-09 	194 	400
Tennis Court 1 	2012-07 	65 	201
Tennis Court 1 	2012-08 	111 	339
Tennis Court 1 	2012-09 	132 	417
Tennis Court 2 	2012-07 	41 	123
Tennis Court 2 	2012-08 	109 	345
Tennis Court 2 	2012-09 	126 	414