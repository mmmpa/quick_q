#
# テキストデータから問題を登録するタスク
# 新規インポートの際に意図しないアップデート（識別子かぶりなど）が発生しないように
# createとupdateを区別する必要がある
#

namespace :q do
  desc 'db/json内の問題集データから問題のみを作成する'
  task :create_from_json => :environment do
    Dir[File.expand_path("#{__dir__}/db/md/**/*.json", __FILE__)].each do |file_path|
      # テンプレートは除外
      next if file_path.include?('template')

      CoordinateQuestion.from(json: File.read(file_path))
    end
  end

  desc 'db/md内のファイルをインポートする（not アップデート）'
  task :create_from_md => :environment do
    Dir[File.expand_path("#{Rails.root}/db/md/**/*.md", __FILE__)].each do |file_path|
      # テンプレートは除外
      next if file_path.include?('template')

      ConvertMdTo.questions(File.read(file_path)).execute
    end
  end

  desc 'db/md内のファイルでアップデートする'
  task :update_from_md => :environment do
    Dir[File.expand_path("#{Rails.root}/db/md/**/*.md", __FILE__)].each do |file_path|
      # テンプレートは除外
      next if file_path.include?('template')

      ConvertMdTo.questions(File.read(file_path), update: true).execute
    end
  end
end