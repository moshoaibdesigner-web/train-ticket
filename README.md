# train-ticket

Shared seat tracker for our group trip: Dhaka → Sylhet, 14.11.2026, Parabat Express.

Pick a class and coach, tap the seats we got, and record who bought them (name + ELX ID). Max 4 tickets per person.

## How it works

- `index.html` is the whole website (no build step). Deploy it on Vercel as a static site.
- Data is stored in Supabase, in one table `public.docs` (classes, coaches and seats).
- Changes show up for everyone live, with a 15-second refresh as backup.

## One-time database setup

In Supabase open **SQL Editor → New query**, paste the contents of `supabase/setup.sql`, and click **Run**.
It creates the table, allows the website to read and write it, turns on live updates, and loads the classes, coaches and seats saved so far.

Note: anyone with the website link can add or remove seats.
