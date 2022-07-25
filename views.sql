drop view v_books_comments;
drop view v_books;
drop view v_books_authors;


CREATE or replace view v_books_authors as select books.id,books.created_at,books.name,books.langue,books.author_id,authors."firstName",authors."lastName",books.coll_id from books,authors where  books.author_id=authors.id ;

CREATE or replace view v_books as select v_books_authors.id,v_books_authors.created_at,v_books_authors.name,v_books_authors.langue,v_books_authors.author_id,v_books_authors."firstName",v_books_authors."lastName",v_books_authors.coll_id,collections.name as coll_name from v_books_authors left join collections on v_books_authors.coll_id=collections.id ;

CREATE or replace view v_books_comments as select v_books.id,v_books.created_at,v_books.name,v_books.langue,v_books.author_id,v_books."firstName",v_books."lastName",v_books.coll_id,v_books.coll_name,comments.comment from v_books full outer join comments on v_books.id=comments.book_id ;
