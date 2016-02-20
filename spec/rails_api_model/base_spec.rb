require 'spec_helper'

describe Base do
  it { is_expected.to be_a Filters }

  it { is_expected.to be_a Builders::Filters }

  it { is_expected.to be_a ModelApi }

  it { is_expected.to respond_to :ar_model }
end
