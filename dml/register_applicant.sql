-- repeatable read level wouldn't cause errors connected if the city or any of given disabilities would be deleted

begin transaction isolation level repeatable read;

insert into lho_jobs.public.applicants
(name, email, password_hash, city_id, phone_number) VALUES
(:name, :email, :pwd_hash, :city_id, :phone_number);

-- repeat for every disability
insert into lho_jobs.public.applicants_disabilities
(applicant_id, disability_id) VALUES
(:applicant, :disability);

commit;
end transaction;
