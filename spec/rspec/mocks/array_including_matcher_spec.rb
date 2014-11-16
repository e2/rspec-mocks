module RSpec
  module Mocks
    module ArgumentMatchers
      RSpec.describe ArrayIncludingMatcher do
        it "describes itself properly" do
          expect(ArrayIncludingMatcher.new([1, 2, 3]).description).to eq "array_including(1, 2, 3)"
        end

        it "describes passed matchers" do
          fake_matcher = Class.new do
            def self.name
              "RSpec::Mocks::ArgumentMatchers::"
            end
          end.new

          expect(fake_matcher).to receive(:description).with(no_args)

          expect(RSpec::Support.is_a_matcher?(fake_matcher)).to be true

          array_including(fake_matcher).description
        end

        context "passing" do
          it "matches the same array" do
            expect(array_including(1, 2, 3)).to be === [1, 2, 3]
          end

          it "matches the same array,  specified without square brackets" do
            expect(array_including(1, 2, 3)).to be === [1, 2, 3]
          end

          it "matches the same array,  which includes nested arrays" do
            expect(array_including([1, 2], 3, 4)).to be === [[1, 2], 3, 4]
          end

          it "works with duplicates in expected" do
            expect(array_including(1, 1, 2, 3)).to be === [1, 2, 3]
          end

          it "works with duplicates in actual" do
            expect(array_including(1, 2, 3)).to be === [1, 1, 2, 3]
          end

          it "is composable with other matchers" do
            klass = Class.new
            dbl = double
            expect(dbl).to receive(:a_message).with(3, array_including(instance_of(klass)))
            dbl.a_message(3, [1, klass.new, 4])
          end

        end

        context "failing" do
          it "fails when not all the entries in the expected are present" do
            expect(array_including(1,2,3,4,5)).not_to be === [1,2]
          end
        end
      end
    end
  end
end
