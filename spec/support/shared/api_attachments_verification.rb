shared_examples_for "API Attachable" do
  it 'returns list comments' do
    expect(response.body).to have_json_size(1).at_path("#{path}/attachments")
  end

  it 'question object contain id' do
    expect(response.body).to be_json_eql(attachment.id.to_json).at_path("#{path}/attachments/0/id")
  end

  it 'question object contain url' do
    expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("#{path}/attachments/0/url")
  end
end
