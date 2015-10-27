require 'tanemaki'

Tanemaki.default_eval_scope = self


namespace :q do
  desc 'db/json内の問題集データから問題のみを作成する'
  task :create_from_json do
    Dir[File.expand_path("#{__dir__}/db/md/**/*.json", __FILE__)].each do |file_path|
      # テンプレートは除外
      next if file_path.include?('template')

      CoordinateQuestion.from(json: File.read(file_path))
    end
  end

  desc 'db/md内のファイルをインポートする'
  task :create_from_md do
    Dir[File.expand_path("#{__dir__}/db/md/**/*.md", __FILE__)].each do |file_path|
      # テンプレートは除外
      next if file_path.include?('template')

      ConvertMdTo.questions(File.read(file_path))
    end
  end
end