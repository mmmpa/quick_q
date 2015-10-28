def read_csv(name)
  @stored_csv ||= {}
  @stored_csv[name] ||= File.read("#{Rails.root}/spec/fixtures/#{name}.csv")
end
