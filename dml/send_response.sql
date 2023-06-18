begin transaction isolation level repeatable read;

insert into lho_jobs.public.responses
(vacancy_id, applicant_id, sent_time, cover_letter) VALUES
(:vacancy, :applicant, :time, :cv);

commit;
end transaction;
