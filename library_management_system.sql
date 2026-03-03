create database Library_Management_System;
 use library_management_system;

-- - Find the number of books each member has borrowed.
select l.member_id, m.name, count(l.loan_id)
from loans l
join members m on l.member_id = m.member_id
group by l.member_id, m.name
order by m.name desc;

-- List all overdue books (assume return_date > 14 days after loan_date).

select l.book_id, l.return_date, l.loan_date 
from loans l
WHERE L.RETURN_date is not null
AND L.RETURN_DATE > date_add(L.LOAN_DATE, INTERVAL 14 DAY);

select * from loans;

-- - Find members who have never paid a fine.

-- with left join
select distinct l.member_id
from loans l
left join fines f on l.loan_id = f.loan_id
where f.loan_id is null;

-- or using NOT EXISTS:

select distinct l.member_id
from loans l
where NOT EXISTS (
SELECT 1
FROM fines f
where f.loan_id = l.loan_id); 

-- List the top 3 most borrowed books.

select b.book_id, b.title, count(l.loan_id) as borrow_count
from books b
join loans l on b.book_id = l.book_id
group by b.book_id, b.title
order by borrow_count desc
limit 3 

-- next

select
b.book_id, 
b.name,
 count(l.loan_id) as borrow_count,
rank() over(order by count(l.loan_id) desc) as rank,
dense_rank() over(order by count(l.loan_id) desc) as dense_rank
from books b
join loans l on b.book_id = l.book_id
group by b.book_id, b.name
order by borrow_count desc;

-- - Get the most recent loan for each member.

select m.member_id, m.name, l.loan_id, l.loan_date
from ( select m.member_id, m.name, l.loan_id,
row_number() over ( partition by l.member_id order by l.loan_date desc) as rn
from loans l
) recent_loan
join members m on m.member_id = l.member_id
where rn =1 ;

-- - Create a view of active loans (books not yet returned)

create view Active_Loans as
select l.member_id, l.book_id, l.return_date
from loans l
where l.return_date is null;

select * from active_loans;

-- Use a CTE to calculate total fines per member

with fine_calculation as ( select l.member_id, sum(f.amount) as amount
from loans l
join fines f on l.loan_id = f.loan_id
group by l.member_id
)
select * from fine_calculation
order by amount desc;


-- - Write a procedure to automatically insert a fine if a book is returned late.

DELIMITER //
DELIMITER //

CREATE TRIGGER trg_insert_fine
AFTER UPDATE ON Loans
FOR EACH ROW
BEGIN
    -- Check if book is returned and it's late
    IF NEW.return_date IS NOT NULL 
       AND NEW.return_date > DATE_ADD(NEW.loan_date, INTERVAL 14 DAY) THEN

        -- Insert a fine (e.g., $1 per day late)
        INSERT INTO Fines (Loan_ID, Amount, Paid, Staff_ID)
        VALUES (
            NEW.Loan_ID,
            DATEDIFF(NEW.return_date, DATE_ADD(NEW.loan_date, INTERVAL 14 DAY)) * 1, -- $1/day late
            FALSE,
            NULL -- Or provide a Staff_ID if available
        );

    END IF;
END;
//

DELIMITER ;

show triggers where 'table' = 'loans';

 select * from books ;

select 
title,
substring(title, 1,5) as short_title
from books;

select curtime();

select * from members;
select * from books;


select book_id from books
union
select book_id from loan_id
order by book_id;
















