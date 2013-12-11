FactoryGirl.define do

  factory :user do
    vk_id '123456'
    name 'il.ya'
  end

  factory :artist do
    name 'Limp Bizkit'
    lastfm_url 'http://www.last.fm/music/Limp+Bizkit'
    mbid '8f9d6bb2-dba4-4cca-9967-cc02b9f4820c'
    image 'http://userserve-ak.last.fm/serve/126/90418.jpg'
  end

  factory :bet do
    association :user, factory: :user
    association :artist, factory: :artist
  end

end