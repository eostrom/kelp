require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Kelp::Visibility, "should_see" do
  before(:each) do
    visit('/home')
  end

  context "passes when" do
    context "String" do
      it "exists" do
        should_see "Hello world"
        should_see "Goodbye world"
      end

      it "multiple exist" do
        should_see [
          "Hello world",
          "Goodbye world"
        ]
      end

      it "is within the scope" do
        should_see "Hello world", :within => "#greeting"
      end
    end

    context "Regexp" do
      it "matches" do
        should_see /(Hello|Goodbye) world/
      end

      it "matches within the scope" do
        should_see /(Hello|Goodbye) world/, :within => "#greeting"
        should_see /(Hello|Goodbye) world/, :within => "#farewell"
      end
    end
  end

  context "fails when" do
    context "String" do
      it "does not exist" do
        lambda do
          should_see "Goodbye cruel world"
        end.should raise_error(RSpec::Expectations::ExpectationNotMetError)
      end

      it "any of several do not exist" do
        lambda do
          should_see [
            "Hello world",
            "Goodbye world",
            "Hello, nurse!"
          ]
        end.should raise_error(RSpec::Expectations::ExpectationNotMetError)
      end

      it "is not within the scope" do
        lambda do
          should_see "Goodbye world", :within => "#greeting"
        end.should raise_error(RSpec::Expectations::ExpectationNotMetError)
      end
    end

    context "Regexp" do
      it "does not match" do
        lambda do
          should_see /(Yo|Wazzup) world/
        end.should raise_error(RSpec::Expectations::ExpectationNotMetError)
      end

      it "matches but is not within the scope" do
        lambda do
          should_see /Goodbye world/, :within => "#greeting"
        end.should raise_error(RSpec::Expectations::ExpectationNotMetError)
      end
    end
  end

end


describe Kelp::Visibility, "should_not_see" do
  before(:each) do
    visit('/home')
  end

  context "passes when" do
    context "String" do
      it "does not exist" do
        should_not_see "Goodbye cruel world"
      end

      it "none of several strings exist" do
        should_not_see [
          "Hello nurse",
          "Goodbye cruel world"
        ]
      end

      it "exists but is not within the scope" do
        should_not_see "Goodbye world", :within => "#greeting"
      end
    end

    context "Regexp" do
      it "does not match" do
        should_not_see /(Yo|Wazzup) world/
      end

      it "none of several regexps match" do
        should_not_see [
          /(Yo|Wazzup) world/,
          /(Ciao|Later) world/
        ]
      end

      it "matches but is not within the scope" do
        should_not_see /Goodbye world/, :within => "#greeting"
      end
    end
  end


  context "fails when" do
    context "String" do
      it "exists" do
        lambda do
          should_not_see "Hello world"
        end.should raise_error(RSpec::Expectations::ExpectationNotMetError)
      end

      it "any of several exist" do
        lambda do
          should_not_see [
            "Hello nurse",
            "Goodbye cruel world",
            "Goodbye world"
          ]
        end.should raise_error(RSpec::Expectations::ExpectationNotMetError)
      end

      it "exists within the scope" do
        lambda do
          should_not_see "Hello world", :within => "#greeting"
        end.should raise_error(RSpec::Expectations::ExpectationNotMetError)
      end
    end

    context "Regexp" do
      it "matches" do
        lambda do
          should_not_see /(Hello|Goodbye) world/
        end.should raise_error(RSpec::Expectations::ExpectationNotMetError)
      end

      it "any of several regexps match" do
        lambda do
          should_not_see [
            /(Yo|Wazzup) world/,
            /(Ciao|Later) world/,
            /(Hello|Goodbye) world/
          ]
        end.should raise_error(RSpec::Expectations::ExpectationNotMetError)
      end

      it "matches within the scope" do
        lambda do
          should_not_see /(Hello|Goodbye) world/, :within => "#greeting"
        end.should raise_error(RSpec::Expectations::ExpectationNotMetError)
      end
    end

  end
end


describe Kelp::Visibility, "should_see_in_same_row" do
  before(:each) do
    visit('/home')
  end

  context "passes when" do
    it "two strings are in the same row" do
      should_see_in_same_row ["Eric", "Edit"]
      should_see_in_same_row ["John", "Edit"]
    end

    it "two strings are in the same row, and one has single and/or double-quotes" do
      should_see_in_same_row [%{Eric "Quoted"}, "Edit"]
      should_see_in_same_row [%{"John's" quo'ta'tions}, "Edit"]
      should_see_in_same_row [%{Terry's "Big" thing}, "Edit"]
    end

    it "three strings are in the same row" do
      should_see_in_same_row ["Eric", "555-4444", "Edit"]
      should_see_in_same_row ["John", "666-5555", "Edit"]
    end
  end
end

describe Kelp::Visibility, "should_see_in_same_row" do
  before(:each) do
    visit('/home')
  end

  context "passes when" do
    it "two strings are not in the same row" do
      should_not_see_in_same_row ["Eric", "Delete"]
      should_not_see_in_same_row ["John", "Delete"]
      should_not_see_in_same_row ["Terry", "Delete"]
    end

    it "any two of three strings are not in the same row" do
      should_not_see_in_same_row ["Eric", "555-4444", "Delete"]
      should_not_see_in_same_row ["John", "666-5555", "Delete"]
      should_not_see_in_same_row ["Terry", "777-6666", "Delete"]
    end
  end
end


describe Kelp::Visibility, "page_should_contain" do
  before(:each) do
    visit('/home')
  end

  context "passes when" do
    context "String" do
      it "exists" do
        page_should_contain "Hello world"
        page_should_contain "Goodbye world"
      end
    end
    context "Regexp" do
      it "matches" do
        page_should_contain /(Hello|Goodbye) world/
        page_should_contain /\d\d\d-\d\d\d\d/
      end
    end
  end

  context "fails when" do
    context "String" do
      it "does not exist" do
        lambda do
          page_should_contain "Wazzup world"
        end.should raise_error(RSpec::Expectations::ExpectationNotMetError)
      end
    end

    context "Regexp" do
      it "does not match" do
        lambda do
          page_should_contain /(Foo|Bar|Baz) world/
        end.should raise_error(RSpec::Expectations::ExpectationNotMetError)
      end
    end

    it "not a String or Regexp" do
      lambda do
        page_should_contain 123
      end.should raise_error(ArgumentError)
    end
  end

end


describe Kelp::Visibility, "page_should_not_contain" do
  before(:each) do
    visit('/home')
  end

  context "passes when" do
    context "String" do
      it "does not exist" do
        page_should_not_contain "Wazzup world"
      end
    end

    context "Regexp" do
      it "does not match" do
        page_should_not_contain /(Foo|Bar|Baz) world/
      end
    end
  end

  context "fails when" do
    context "String" do
      it "exists" do
        lambda do
          page_should_not_contain "Hello world"
        end.should raise_error(RSpec::Expectations::ExpectationNotMetError)
        lambda do
          page_should_not_contain "Goodbye world"
        end.should raise_error(RSpec::Expectations::ExpectationNotMetError)
      end
    end
    context "Regexp" do
      it "matches" do
        lambda do
          page_should_not_contain /(Hello|Goodbye) world/
        end.should raise_error(RSpec::Expectations::ExpectationNotMetError)
        lambda do
          page_should_not_contain /\d\d\d-\d\d\d\d/
        end.should raise_error(RSpec::Expectations::ExpectationNotMetError)
      end
    end

    it "not a String or Regexp" do
      lambda do
        page_should_not_contain 123
      end.should raise_error(ArgumentError)
    end
  end

end


