-- search by given parameters

begin transaction isolation level read committed;

select * from lho_jobs.public.vacancies vac
where city_id = :city_id
and not exists(
    select * from lho_jobs.public.vacancies_disabilities dis
    where dis.vacancy_id = vac.id
    and dis.disability_id not in :given_disabilities
);

end transaction;

-- search by user defaults

begin transaction isolation level read committed;

with user_disabilities as (
    select disability_id from lho_jobs.public.applicants_disabilities
    where applicant_id = :user_id
)
select * from lho_jobs.public.vacancies vac
where vac.city_id = (
    select app.city_id from lho_jobs.public.applicants app
    where app.id = :user_id
    )
and not exists(
    select * from user_disabilities
    where user_disabilities.disability_id not in (
        select vd.disability_id from lho_jobs.public.vacancies_disabilities vd
        where vd.vacancy_id = vac.id
        )
);

end transaction;

-- search by company

begin transaction isolation level read committed;

select * from lho_jobs.public.vacancies
where employer_id = :employer;

end transaction;
