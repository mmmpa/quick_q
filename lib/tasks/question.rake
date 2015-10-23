require 'tanemaki'

Tanemaki.default_eval_scope = self


namespace :q do
  desc 'lib/json内の問題集データから問題のみを作成する'
  task :create do
    Dir[File.expand_path("#{__dir__}/**/*.json", __FILE__)].each do |file_path|
      # テンプレートは除外
      next if file_path.include?('template')

      CoordinateQuestion.from(json: File.read(file_path))
    end
  end
end