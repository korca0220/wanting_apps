-- Storage bucket for Piece photos. Private (signed URLs only).
-- Object path convention: {user_id}/{piece_id}.{ext} — policies below
-- enforce ownership by checking the first folder segment against auth.uid().

insert into storage.buckets (id, name, public)
values ('pieces', 'pieces', false);

create policy "owner can upload pieces objects"
  on storage.objects for insert
  with check (
    bucket_id = 'pieces'
    and auth.uid()::text = (storage.foldername(name))[1]
  );

create policy "owner can read pieces objects"
  on storage.objects for select
  using (
    bucket_id = 'pieces'
    and auth.uid()::text = (storage.foldername(name))[1]
  );

create policy "owner can update pieces objects"
  on storage.objects for update
  using (
    bucket_id = 'pieces'
    and auth.uid()::text = (storage.foldername(name))[1]
  )
  with check (
    bucket_id = 'pieces'
    and auth.uid()::text = (storage.foldername(name))[1]
  );

create policy "owner can delete pieces objects"
  on storage.objects for delete
  using (
    bucket_id = 'pieces'
    and auth.uid()::text = (storage.foldername(name))[1]
  );
