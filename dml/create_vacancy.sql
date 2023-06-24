begin transaction isolation level read committed;

insert into lho_jobs.public.vacancies
(employer_id, city_id, name, job_description) VALUES
(:employer_id, :city_id, :title, :job_description);

end transaction;
