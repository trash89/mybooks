create unique index uk_idx_collections on collections(user_id,name);
create unique index uk_idx_authors on authors(user_id,"firstName","lastName");
create unique index uk_idx_books on books(user_id,author_id,name);


CREATE POLICY "policy_authors"
ON public.authors
FOR all USING (
  auth.uid() = user_id
);

CREATE POLICY "policy_collections"
ON public.collections
FOR all USING (
  auth.uid() = user_id
);

CREATE POLICY "policy_books"
ON public.books
FOR all USING (
  auth.uid() = user_id
);


CREATE or replace view v_books_authors as select books.id,books.created_at,books.name,books.langue,books.author_id,books.comment,authors."firstName",authors."lastName",books.coll_id from books,authors where  books.author_id=authors.id and books.user_id=auth.uid() and authors.user_id=auth.uid();
CREATE or replace view v_books as select v_books_authors.id,v_books_authors.created_at,v_books_authors.name,v_books_authors.langue,v_books_authors.comment,v_books_authors.author_id,v_books_authors."firstName",v_books_authors."lastName",v_books_authors.coll_id,collections.name as coll_name from v_books_authors left join collections on v_books_authors.coll_id=collections.id and  collections.user_id=auth.uid();

