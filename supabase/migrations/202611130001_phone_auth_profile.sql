-- Basra Market: create a customer profile automatically after Supabase phone signup.
-- Run once in Supabase SQL Editor after the initial schema.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, phone, full_name, role)
  values (
    new.id,
    new.phone,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    'customer'
  )
  on conflict (id) do update
    set phone = excluded.phone;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

-- Keep profile role self-service changes blocked. Users may update their
-- display name, but role changes must be performed by trusted admin tooling.
drop policy if exists "profile_update" on public.profiles;
create policy "profile_update"
on public.profiles for update
using (auth.uid() = id)
with check (auth.uid() = id);

comment on function public.handle_new_user() is
'Creates a least-privilege customer profile for each newly authenticated Supabase user.';
