RSpec.shared_examples "create a new object successfully" do |obj|
  it "increase the number of #{obj.name} by 1" do
    expect(obj.count).to eq(count_before + 1)
  end
end

RSpec.shared_examples "create a new object failed" do |obj|
  it "don't change the number of #{obj.name}" do
    expect(obj.count).to eq(count_before)
  end
end
