INSERT INTO storage.buckets (id, name, public) VALUES ('minutes', 'minutes', true)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "authenticated_read_minutes" ON storage.objects
  FOR SELECT TO authenticated
  USING (bucket_id = 'minutes');

CREATE POLICY "leader_upload_minutes" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'minutes' AND is_leader_or_admin());

CREATE POLICY "treasurer_upload_minutes" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'minutes' AND is_treasurer_or_admin());

CREATE POLICY "leader_delete_minutes" ON storage.objects
  FOR DELETE TO authenticated
  USING (bucket_id = 'minutes' AND is_leader_or_admin());

CREATE POLICY "treasurer_delete_minutes" ON storage.objects
  FOR DELETE TO authenticated
  USING (bucket_id = 'minutes' AND is_treasurer_or_admin());
