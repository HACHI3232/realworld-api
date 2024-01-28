5.times do |i|
  Article.create!(
    title: "テスト記事 #{i + 1}",
    body: "これはテスト記事 #{i + 1} の本文です。これはサンプルテキストです。"
  )
end
