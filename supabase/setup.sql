-- Train Ticket: run this once in Supabase → SQL Editor → New query → Run.
-- It creates one table for classes, coaches and seats, lets the website read and write it,
-- turns on live updates, and copies in the data saved so far.

create table if not exists public.docs (
  collection text not null,
  id text not null,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (collection, id)
);

alter table public.docs enable row level security;

drop policy if exists "docs read" on public.docs;
drop policy if exists "docs insert" on public.docs;
drop policy if exists "docs update" on public.docs;
drop policy if exists "docs delete" on public.docs;
create policy "docs read"   on public.docs for select to anon, authenticated using (true);
create policy "docs insert" on public.docs for insert to anon, authenticated with check (true);
create policy "docs update" on public.docs for update to anon, authenticated using (true) with check (true);
create policy "docs delete" on public.docs for delete to anon, authenticated using (true);
grant select, insert, update, delete on public.docs to anon, authenticated;

-- live updates (ignore the error if it says the table is already a member)
do $$ begin
  alter publication supabase_realtime add table public.docs;
exception when duplicate_object then null; end $$;

insert into public.docs (collection, id, data) values
  ('classes', 'AC_S', '{"fare":943,"name":"AC_S","order":4,"vat":true}'::jsonb),
  ('classes', 'F_SEAT', '{"fare":633,"name":"F_SEAT","order":3,"vat":true}'::jsonb),
  ('classes', 'SNIGDHA', '{"fare":788,"name":"SNIGDHA","order":1,"vat":true}'::jsonb),
  ('classes', 'S_CHAIR', '{"fare":410,"name":"S_CHAIR","order":2,"vat":false}'::jsonb),
  ('coaches', 'CHA', '{"seatClass":"SNIGDHA","seats":55}'::jsonb),
  ('coaches', 'DA', '{"layout":"schair","order":8,"seatClass":"S_CHAIR","seats":60}'::jsonb),
  ('coaches', 'DANT', '{"layout":"ka","order":9,"seatClass":"S_CHAIR","seats":15}'::jsonb),
  ('coaches', 'DHA', '{"layout":"schair","order":10,"seatClass":"S_CHAIR","seats":60}'::jsonb),
  ('coaches', 'GA', '{"layout":"acs","seatClass":"AC_S","seats":33}'::jsonb),
  ('coaches', 'GHA', '{"layout":"acs","seatClass":"AC_S","seats":33}'::jsonb),
  ('coaches', 'JA', '{"layout":"schair","order":3,"seatClass":"S_CHAIR","seats":60}'::jsonb),
  ('coaches', 'JHA', '{"layout":"schair","order":4,"seatClass":"S_CHAIR","seats":60}'::jsonb),
  ('coaches', 'KA', '{"layout":"ka","order":1,"seatClass":"S_CHAIR","seats":15}'::jsonb),
  ('coaches', 'NEO', '{"layout":"schair","order":5,"seatClass":"S_CHAIR","seats":60}'::jsonb),
  ('coaches', 'SCHA', '{"layout":"schair","order":2,"seatClass":"S_CHAIR","seats":60}'::jsonb),
  ('coaches', 'TA', '{"layout":"schair","order":6,"seatClass":"S_CHAIR","seats":60}'::jsonb),
  ('coaches', 'THA', '{"layout":"schair","order":7,"seatClass":"S_CHAIR","seats":60}'::jsonb),
  ('coaches', 'TO', '{"layout":"schair","order":11,"seatClass":"S_CHAIR","seats":60}'::jsonb),
  ('coaches', 'UMA', '{"order":1,"seatClass":"SNIGDHA","seats":55}'::jsonb),
  ('seats', 'UMA-1', '{"buyer":"Shoaib","coach":"UMA","elx":"","seat":1,"seatClass":"SNIGDHA","status":"booked","updatedAt":1793760708118}'::jsonb),
  ('seats', 'UMA-2', '{"buyer":"sajal","coach":"UMA","elx":"","seat":2,"seatClass":"SNIGDHA","status":"booked","updatedAt":1793761454116}'::jsonb),
  ('seats', 'UMA-52', '{"buyer":"KOWSAR","coach":"UMA","elx":"","seat":52,"seatClass":"SNIGDHA","status":"booked","updatedAt":1793760891896}'::jsonb),
  ('seats', 'UMA-55', '{"buyer":"KOWSAR","coach":"UMA","elx":"","seat":55,"seatClass":"SNIGDHA","status":"booked","updatedAt":1793760891483}'::jsonb)
on conflict (collection, id) do update set data = excluded.data, updated_at = now();
