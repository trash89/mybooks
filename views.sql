drop view v_books;
drop view v_books_authors;
CREATE or replace view v_books_authors as select books.id,books.created_at,books.name,books.langue,books.author_id,books.comment,authors."firstName",authors."lastName",books.coll_id from books,authors where  books.author_id=authors.id ;
CREATE or replace view v_books as select v_books_authors.id,v_books_authors.created_at,v_books_authors.name,v_books_authors.langue,v_books_authors.comment,v_books_authors.author_id,v_books_authors."firstName",v_books_authors."lastName",v_books_authors.coll_id,collections.name as coll_name from v_books_authors left join collections on v_books_authors.coll_id=collections.id ;

