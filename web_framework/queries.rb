QUERIES = {
  all_submissions:
    '
        select * from submissions
    ',
  create_submissions:
    '
        insert into submissions(name) 
        values({name})
    ',
  find_submissions_by_name:
    '
        select * from submissions
        where name = {name}
    '
}
