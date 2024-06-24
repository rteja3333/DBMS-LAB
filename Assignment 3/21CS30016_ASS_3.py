import psycopg2

# Connect to your PostgreSQL database
conn = psycopg2.connect(
    dbname="21CS30016",
    user="21CS30016",
    password="21CS30016",
    host="10.5.18.70",
    port="5432"
)

# Create a cursor object using the cursor() method
cursor = conn.cursor()

# Define the queries
queries = [
    "SELECT s.roll, s.name FROM student s JOIN event e ON s.eid = e.eid WHERE e.ENAME = 'megaevent';",
    "SELECT s.roll, s.name FROM student s JOIN role r ON s.rid = r.rid JOIN event e ON s.eid = e.eid WHERE e.ENAME = 'megaevent' AND r.Rname = 'secretary';",
    "SELECT p.name FROM participant p JOIN event e ON p.event_id = e.EID WHERE p.college_name = 'IITB' AND e.ENAME = 'megaevent';",
    "SELECT DISTINCT p.college_name FROM participant p JOIN event e ON p.event_id = e.EID WHERE e.ENAME = 'megaevent';",
    "SELECT e.ENAME FROM event e JOIN student s ON e.EID = s.eid JOIN role r ON s.rid = r.RID WHERE r.Rname = 'secretary';",
    "SELECT s.name FROM student s JOIN volunteer v ON s.roll = v.roll WHERE s.dept = 'CSE' AND v.eid = (SELECT EID FROM event WHERE ENAME = 'megaevent');",
    "SELECT DISTINCT e.ENAME FROM event e JOIN student s ON e.EID = s.eid JOIN volunteer v ON s.roll = v.roll WHERE s.dept = 'CSE';",
    "SELECT college_name FROM (SELECT college_name, COUNT(*) AS participant_count FROM participant WHERE event_id = (SELECT EID FROM event WHERE ENAME = 'megaevent') GROUP BY college_name) AS college_participant_count WHERE participant_count = (SELECT MAX(participant_count) FROM (SELECT COUNT(*) AS participant_count FROM participant WHERE event_id = (SELECT EID FROM event WHERE ENAME = 'megaevent') GROUP BY college_name) AS max_counts) ORDER BY college_name;",
    "SELECT college_name FROM (SELECT college_name, COUNT(*) AS participant_count FROM participant GROUP BY college_name) AS college_participant_count WHERE participant_count = (SELECT MAX(participant_count) FROM (SELECT COUNT(*) AS participant_count FROM participant GROUP BY college_name) AS max_counts) ORDER BY college_name;",
    "SELECT s.dept FROM student s JOIN volunteer v ON s.roll = v.roll WHERE EXISTS (SELECT 1 FROM participant p WHERE p.college_name = 'IITB' AND p.event_id = s.eid) GROUP BY s.dept ORDER BY COUNT(*) DESC LIMIT 1;",
    "SELECT s.roll, s.name FROM student s JOIN event e ON s.eid = e.eid WHERE e.ENAME = %s;"
]

# Function to execute query based on user choice
def execute_query(choice):
    if choice < 1 or choice > len(queries):
        print("Invalid choice!")
        return
    query = queries[choice - 1]
    if choice == 11:
        event_name = input("Enter the name of the event: ")
        cursor.execute(query, (event_name,))
    else:
        cursor.execute(query)
    rows = cursor.fetchall()
    for index, row in enumerate(rows, start=1):
        print(f"{index}. {row}")
    print()

# Menu function
def menu():
    print("Menu: ")
    print("\n1. Roll number and name of all the students who are managing the 'Megaevent'")
    print("2. Roll number and name of all the students who are managing 'Megaevent' as a 'Secretary'")
    print("3. Name of all the participants from the college 'IITB' in 'Megaevent'")
    print("4. Name of all the colleges who have at least one participant in 'Megaevent'")
    print("5. Name of all the events which is managed by a 'Secretary'")
    print("6. Name of all the 'CSE' department student volunteers of 'Megaevent'")
    print("7. Name of all the events which has at least one volunteer from 'CSE'")
    print("8. Name of the college with the largest number of participants in 'Megaevent'")
    print("9. Name of the college with the largest number of participant overall")
    print("10. Name of the department with the largest number of volunteers in all the events which has at least one participant from 'IITB'")
    print("11. Custom query with event name input")
    print("0. Exit")
    choice = int(input("\nEnter your choice: "))
    if choice == 0:
        return
    execute_query(choice)
    menu()

# Main function
def main():
    menu()
    # Close the cursor and connection
    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
