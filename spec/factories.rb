FactoryGirl.define do

  factory :user do
    vk_id '123456'
    name 'il.ya'
  end

  factory :artist do
    name 'Limp Bizkit'
    mbid '8f9d6bb2-dba4-4cca-9967-cc02b9f4820c'
    lastfm_url 'http://www.last.fm/music/Limp+Bizkit'
    image 'http://userserve-ak.last.fm/serve/126/90418.jpg'

    trait :ratm do
      name 'Rage Against The Machine'
      mbid '8f9d6bb2-dba4-4cca-9967-cc02b9f4820cr'
    end
    trait :lb do
      name 'Limp Bizkit'
      mbid '8f9d6bb2-dba4-4cca-9967-cc02b9f4820ce'
    end
    trait :soad do
      name 'System of a Down'
      mbid '8f9d6bb2-dba4-4cca-9967-cc02b9f4820cw'
    end
    trait :bhg do
      name 'Bloodhound Gang'
      mbid '8f9d6bb2-dba4-4cca-9967-cc02b9f4820cq'
    end

    trait :untitled do
      sequence(:name) {|n| "Group[#{n}]"}
      sequence(:mbid) {|n| "8f9d6bb2-dba4-4cca-9967-cc02b9f48#{n}c"}
    end

  end

  factory :bet do
    association :user, factory: :user
    association :artist, factory: :artist
  end

end