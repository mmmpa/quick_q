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

shared_examples 'response for multiple questions question' do
  it do
    hash = JSON.parse(response.body)
    expect(check_required_key(hash, :id, :text, :way, :children, :source_link_id, :premise_id)).to be_truthy

    for_children = JSON.parse(response.body)
    for_children['children'].each do |q|
      case q['way'].to_sym
        when :free_text, :ox
          expect(check_required_key(q, :id, :text, :way, :source_link_id, :premise_id)).to be_truthy
        when :single_choice, :multiple_choices
          expect(check_required_key(q, :id, :text, :way, :options, :source_link_id, :premise_id)).to be_truthy
        when :in_order
          expect(check_required_key(q, :id, :text, :way, :options, :answers_number, :source_link_id, :premise_id)).to be_truthy
        else
          nil
      end
    end
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