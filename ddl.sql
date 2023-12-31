create database lho_jobs;

set search_path = 'public';

create or replace function random_between(low int, high int)
    returns int as
$$
begin
    return floor(random() * (high - low + 1) + low);
end;
$$ language 'plpgsql' strict;

create table cities(
    id serial not null,
    name varchar(100) not null,
    country varchar(100) not null,
    region varchar(100) not null,

    constraint cities_pk primary key (id)
);

create table disabilities(
    id serial not null,
    name varchar(50),
    description text,

    constraint disabilities_pk primary key (id)
);

create table employers(
    id serial not null,
    name varchar(100) not null,
    email varchar(255) not null,
    company_description text,
    web_site_link varchar(255),
    phone_number varchar(20) not null,

    constraint employers_pk primary key (id)
);

create table employers_to_auth_codes(
    id serial not null,
    employer_id int not null,
    code int not null default random_between(100000, 999999),

    constraint employers_to_auth_codes_pk primary key (id, employer_id),
    constraint employers_fk foreign key (employer_id)
        references employers
        on update restrict
        on delete cascade
);

create table applicants(
    id serial not null,
    name varchar(100) not null,
    email varchar(100) not null,
    phone_number varchar(20) not null,
    password_hash varchar(255) not null,
    photo_url varchar(255) default null,
    resume text not null default '',
    city_id int not null,

    constraint applicants_pk primary key (id),
    constraint city_fk foreign key (city_id)
        references cities
        on update restrict
        on delete restrict
);

create table vacancies(
    id serial not null,
    employer_id int not null,
    city_id int not null,
    is_active bool not null default true,
    name varchar(100) not null,
    job_description text not null default '',

    constraint vacancies_pk primary key (id),
    constraint employer_fk foreign key (employer_id)
        references employers
        on update restrict
        on delete cascade,
    constraint city_fk foreign key (city_id)
        references cities
        on update restrict
        on delete restrict
);

create table vacancies_disabilities(
    vacancy_id int not null,
    disability_id int not null,

    constraint vd_pk primary key (vacancy_id, disability_id),
    constraint vacancy_fk foreign key (vacancy_id)
        references vacancies
        on update restrict
        on delete cascade,
    constraint disabilities_fk foreign key (disability_id)
        references disabilities
        on update restrict
        on delete cascade
);

create table applicants_disabilities(
    applicant_id int not null,
    disability_id int not null,

    constraint ad_pk primary key (applicant_id, disability_id),
    constraint applicant_fk foreign key (applicant_id)
        references applicants
        on update restrict
        on delete cascade,
    constraint disabilities_fk foreign key (disability_id)
        references disabilities
        on update restrict
        on delete cascade
);

create table responses(
    vacancy_id int not null,
    applicant_id int not null,
    sent_time timestamp not null,
    cover_letter text,

    constraint responses_pk primary key (vacancy_id, applicant_id),
    constraint vacancy_fk foreign key (vacancy_id)
        references vacancies
        on update restrict
        on delete cascade,
    constraint applicant_fk foreign key (applicant_id)
        references applicants
        on update restrict
        on delete cascade
);
