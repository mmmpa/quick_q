shared_examples 'response for no option question' do |json|
  it do
    hash = JSON.parse(response.body)

    expect(check_required_key(hash, :id, :text, :way, :source_link_id, :premise_id)).to be_truthy
  end
end

shared_examples 'response for have options question' do
  it do
    hash = JSON.parse(response.body)

    expect(check_required_key(hash, :id, :text, :way, :options, :source_link_id, :premise_id)).to be_truthy
  end
end

shared_examples 'response for in order question' do
  it do
    hash = JSON.parse(response.body)

    expect(check_required_key(hash, :id, :text, :way, :options, :answers_number, :source_link_id, :premise_id)).to be_truthy
  end
end

def check_required_key(hash, *keys)
  keys.map(&:to_s).each do |required_key|
    raise RequiredKeyMissing unless hash.has_key?(required_key)
    hash.delete(required_key)
  end

  raise ExtraKeyIncluding if hash != {}

  true
end

class RequiredKeyMissing < StandardError

end

class ExtraKeyIncluding < StandardError

end