#
# テキストデータから問題を登録するタスク
# 新規インポートの際に意図しないアップデート（識別子かぶりなど）が発生しないように
# createとupdateを区別する必要がある
#

namespace :q do
  desc 'タグを登録する'
  task :register_tag => :environment do
    Dir[File.expand_path("#{Rails.root}/db/csv/tag/**/*.csv", __FILE__)].each do |file_path|
      # テンプレートは除外
      next if file_path.include?('template')

      RegisterTag.(File.read(file_path))
    end
  end

  desc '問題にタギングする'
  task :tag_q_to_tag => :environment do
    Dir[File.expand_path("#{Rails.root}/db/csv/tagging/**/*.csv", __FILE__)].each do |file_path|
      # テンプレートは除外
      next if file_path.include?('template')

      TagQToTag.(File.read(file_path))
    end
  end

  desc '問題種別でタギングする'
  task :tag_way => :environment do
    TagQToTag.with_way
  end

  desc '問題の出典元を登録する'
  task :register_source => :environment do
    Dir[File.expand_path("#{Rails.root}/db/csv/link/**/*.csv", __FILE__)].each do |file_path|
      # テンプレートは除外
      next if file_path.include?('template')

      RegisterSourceLink.(File.read(file_path))
    end
  end

  desc '問題を出典にリンクする'
  task :link_q_to_src => :environment do
    Dir[File.expand_path("#{Rails.root}/db/csv/linking/**/*.csv", __FILE__)].each do |file_path|
      # テンプレートは除外
      next if file_path.include?('template')

      LinkQToSource.(File.read(file_path))
    end
  end

  desc 'db/json内の問題集データから問題のみを作成する'
  task :create_from_json => :environment do
    Dir[File.expand_path("#{__dir__}/db/md/**/*.json", __FILE__)].each do |file_path|
      # テンプレートは除外
      next if file_path.include?('template')

      CoordinateQuestion.from(json: File.read(file_path))
    end
  end

  desc 'db/csv内のファイルをインポートする（not アップデート）'
  task :create_from_csv => :environment do
    Qa::Question.transaction do
      Dir[File.expand_path("#{Rails.root}/db/csv/multiple/*.csv", __FILE__)].each do |file_path|
        # テンプレートは除外
        next if file_path.include?('template')

        CoordinateQuestion.from(csv: File.read(file_path), way: :multiple_choices)
      end

      Dir[File.expand_path("#{Rails.root}/db/csv/order/*.csv", __FILE__)].each do |file_path|
        # テンプレートは除外
        next if file_path.include?('template')

        CoordinateQuestion.from(csv: File.read(file_path), way: :in_order)
      end

      Dir[File.expand_path("#{Rails.root}/db/csv/ox/*.csv", __FILE__)].each do |file_path|
        # テンプレートは除外
        next if file_path.include?('template')

        CoordinateQuestion.from(csv: File.read(file_path), way: :ox)
      end

      Dir[File.expand_path("#{Rails.root}/db/csv/single/*.csv", __FILE__)].each do |file_path|
        # テンプレートは除外
        next if file_path.include?('template')

        CoordinateQuestion.from(csv: File.read(file_path), way: :single_choice)
      end

      Dir[File.expand_path("#{Rails.root}/db/csv/text/*.csv", __FILE__)].each do |file_path|
        # テンプレートは除外
        next if file_path.include?('template')

        CoordinateQuestion.from(csv: File.read(file_path), way: :free_text)
      end
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