# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: User do
    id { 'ece633c2-7381-4a1c-9b03-831e4bd0cc64' }
    email { 'testprop1010x@gmail.com' }
    first_name { 'Michael' }
    avatar { 'https://lh4.googleusercontent.com/-RvG2IRlxR1M/AAAAAAAAAAI/AAAAAAAAAAA/APUIFaMWpRoBeTn_zbuPfQdqZO9ZAjJyjA/mo/photo.jpg' }
    created_at { '2018-09-18 12:44:01.391418' }
    updated_at { '2018-09-18 12:44:01.391418' }
    last_name { 'Tester' }
    token { 'ya29.GlscBmZFSrg-1Id4fgF-RNGgHwQA-VTaekI00c6vPYLRjGSPUAztKE--91Xr0LgmAt_AjSBK_fs1Ok-TuDoqNoey1qID_dORBBMH5OejKEh3sAdDNsq_RAQ4I9mz' }
    refresh_token { '1/D6iWf8azhYQo5j9n4yc1oGNERO-N_VuI8wtz4DrykSI' }
    expires_at { '2018-09-18 13:44:00'}
  end
end
